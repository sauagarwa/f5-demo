# Copyright (c) Meta Platforms, Inc. and affiliates.
# All rights reserved.
#
# This source code is licensed under the terms described in the LICENSE file in
# the root directory of this source tree.

import enum
import json
import uuid

import streamlit as st
from llama_stack.apis.common.content_types import ToolCallDelta
from api import llama_stack_api


class AgentType(enum.Enum):
    REGULAR = "Regular"
    REACT = "ReAct"

def get_strategy(temperature, top_p):
    """Determines the sampling strategy for the LLM based on temperature."""
    return {'type': 'greedy'} if temperature == 0 else {
            'type': 'top_p', 'temperature': temperature, 'top_p': top_p
        }


def render_history():
    """Renders the chat history from session state.
    Also displays debug events for assistant messages if tool_debug is enabled.
    """
    # Initialize messages in session state if not present
    if 'messages' not in st.session_state:
        st.session_state.messages = [{"role": "assistant", "content": "How can I help you?"}]
    # Initialize debug_events in session state if not present
    if 'debug_events' not in st.session_state:
         st.session_state.debug_events = []

    for i, msg in enumerate(st.session_state.messages):
        with st.chat_message(msg['role']):
            st.markdown(msg['content'])

def tool_chat_page():
    st.title("💬 Chat")

    client = llama_stack_api.client
    models = client.models.list()
    model_list = [model.identifier for model in models if model.api_model_type == "llm"]

    tool_groups = client.toolgroups.list()
    tool_groups_list = [tool_group.identifier for tool_group in tool_groups]
    mcp_tools_list = [tool for tool in tool_groups_list if tool.startswith("mcp::")]
    builtin_tools_list = [tool for tool in tool_groups_list if not tool.startswith("mcp::")]

    selected_vector_dbs = []

    def reset_agent():
        st.session_state.clear()
        st.cache_resource.clear()

    with st.sidebar:
        st.title("Configuration")
        st.subheader("Model")
        model = st.selectbox(label="Model", options=model_list, on_change=reset_agent, label_visibility="collapsed")

        processing_mode = "Direct"

        if processing_mode == "Direct":
            vector_dbs = llama_stack_api.client.vector_dbs.list() or []
            if not vector_dbs:
                st.info("No vector databases available for selection.")
            vector_dbs = [vector_db.identifier for vector_db in vector_dbs]
            selected_vector_dbs = st.multiselect(
                label="Select Document Collections to use in RAG queries",
                options=vector_dbs,
                on_change=reset_agent,
            )

        st.subheader("Sampling Parameters")
        temperature = st.slider("Temperature", 0.0, 2.0, 0.1, 0.05, on_change=reset_agent)
        top_p = st.slider("Top P", 0.0, 1.0, 0.95, 0.05, on_change=reset_agent)
        max_tokens = st.slider("Max Tokens", 1, 4096, 512, 64, on_change=reset_agent)
        repetition_penalty = st.slider("Repetition Penalty", 1.0, 2.0, 1.0, 0.05, on_change=reset_agent)

        st.subheader("System Prompt")
        default_prompt = "You are a helpful AI assistant."
        system_prompt = st.text_area(
            "System Prompt", value=default_prompt, on_change=reset_agent, height=100
        )

        if st.button("Clear Chat & Reset Config", use_container_width=True):
            reset_agent()
            st.rerun()
    
    if "debug_events" not in st.session_state: # Per-turn debug logs
        st.session_state["debug_events"] = []

    render_history() # Display current chat history and any past debug events


    def direct_process_prompt(prompt, debug_events_list):
        # Query the vector DB
        if selected_vector_dbs:
            with st.spinner("Retrieving context (RAG)..."):
                try:
                    rag_response = llama_stack_api.client.tool_runtime.rag_tool.query(
                        content=prompt, vector_db_ids=list(selected_vector_dbs) 
                    )
                    prompt_context = rag_response.content
                    debug_events_list.append({
                        "type": "rag_query_direct_mode", "query": prompt,
                        "vector_dbs": selected_vector_dbs,
                        "context_length": len(prompt_context) if prompt_context else 0,
                        "context_preview": (str(prompt_context[:200]) + "..." if prompt_context else "None")
                    })
                except Exception as e:
                    st.warning(f"RAG Error (Direct Mode): {e}")
                    debug_events_list.append({"type": "error", "source": "rag_direct_mode", "content": str(e)})
        else:
            prompt_context = None
        
        with st.chat_message("assistant"):
            message_placeholder = st.empty()
            full_response = ""
            retrieval_response = ""

            # Construct the extended prompt
            if prompt_context:
                extended_prompt = f"Please answer the following query using the context below.\n\nCONTEXT:\n{prompt_context}\n\nQUERY:\n{prompt}"
            else:
                extended_prompt = f"Please answer the following query. \n\nQUERY:\n{prompt}"

            # Run inference directly
            #st.session_state.messages.append({"role": "user", "content": extended_prompt})
            messages_for_direct_api = (
                [{'role': 'system', 'content': system_prompt}] +
                [{'role': 'user', 'content': extended_prompt}]
            )
            response = llama_stack_api.client.inference.chat_completion(
                messages=messages_for_direct_api,
                model_id=model,
                sampling_params={
                    "strategy": get_strategy(temperature, top_p),
                    "max_tokens": max_tokens,
                    "repetition_penalty": repetition_penalty,
                },
                stream=True,
            )

            # Display assistant response
            for chunk in response:
                if chunk.event:
                    response_delta = chunk.event.delta
                    if isinstance(response_delta, ToolCallDelta):
                        retrieval_response += response_delta.tool_call.replace("====", "").strip()
                        #retrieval_message_placeholder.info(retrieval_response)
                    else:
                        full_response += chunk.event.delta.text
                        message_placeholder.markdown(full_response + "▌")
            message_placeholder.markdown(full_response)

        response_dict = {"role": "assistant", "content": full_response, "stop_reason": "end_of_message"}
        st.session_state.messages.append(response_dict)
        #st.session_state.displayed_messages.append(response_dict)

    if prompt := st.chat_input(placeholder="Ask a question..."):
        # Append user message to history and display it
        st.session_state.messages.append({"role": "user", "content": prompt})
        with st.chat_message("user"):
            st.markdown(prompt)
        # Prepare for assistant's response
        # Each assistant turn gets its own list for debug events
        st.session_state.debug_events.append([])
        current_turn_debug_events_list = st.session_state.debug_events[-1] # Get the list for this turn

        st.session_state.prompt = prompt
        # rag_mode == "Direct"
        direct_process_prompt(st.session_state.prompt, current_turn_debug_events_list)
        #st.session_state.prompt = None
        st.rerun()

tool_chat_page()
