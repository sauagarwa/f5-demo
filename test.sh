curl https://vllm-f5-demo.apps.gpu-ai.bd.f5.com/v1/chat/completions -k \
  -H "Content-Type: application/json" \
  -d '{
    "model": "meta-llama/Llama-3.2-3B-Instruct",
    "messages": [
      {
        "role": "system",
        "content": "You are a helpful assistant."
      },
      {
        "role": "user",
        "content": "Where is Los Angeles"
      }
    ]
  }'

# Working example
curl https://aigw-ai-gateway.apps.gpu-ai.bd.f5.com/demo-endpoint -k \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {
        "role": "system",
        "content": "You are a helpful assistant."
      },
      {
        "role": "user",
        "content": "Where is Los Angeles"
      }
    ]
  }'

# Giving Error
curl -v https://aigw-ai-gateway.apps.gpu-ai.bd.f5.com/demo-endpoint/v1/chat/completions -k \
-H "Content-Type: application/json" \
-d '{
  "messages":
    [
      {
        "role": "system",
        "content":
          [{ "type": "text", "text": "You are a helpful AI assistant." }],
      },
      {
        "role": "user",
        "content":
          [
            {
              "type": "text",
              "text": "Please answer the following query. \n\nQUERY:\nwho is president of America?",
            },
          ],
      },
    ],
  "model": "meta-llama/Llama-3.1-8B-Instruct",
  "audio": NOT_GIVEN,
  "frequency_penalty": NOT_GIVEN,
  "function_call": NOT_GIVEN,
  "functions": NOT_GIVEN,
  "logit_bias": NOT_GIVEN,
  "logprobs": NOT_GIVEN,
  "max_completion_tokens": NOT_GIVEN,
  "max_tokens": 512,
  "metadata": NOT_GIVEN,
  "modalities": NOT_GIVEN,
  "n": NOT_GIVEN,
  "parallel_tool_calls": NOT_GIVEN,
  "prediction": NOT_GIVEN,
  "presence_penalty": NOT_GIVEN,
  "reasoning_effort": NOT_GIVEN,
  "response_format": NOT_GIVEN,
  "seed": NOT_GIVEN,
  "service_tier": NOT_GIVEN,
  "stop": NOT_GIVEN,
  "store": NOT_GIVEN,
  "stream": True,
  "stream_options": NOT_GIVEN,
  "temperature": 0.1,
  "tool_choice": NOT_GIVEN,
  "tools": NOT_GIVEN,
  "top_logprobs": NOT_GIVEN,
  "top_p": 0.95,
  "user": NOT_GIVEN,
  "web_search_options": NOT_GIVEN,
}'


# Giving model error
curl https://vllm-f5-demo.apps.gpu-ai.bd.f5.com/v1/chat/completions -k \
  -H "Content-Type: application/json" \
  -d '{
    "model": "meta-llama/Llama-3.2-3B-Instruct",
    "audio": NOT_GIVEN,
    "frequency_penalty": NOT_GIVEN,
    "function_call": NOT_GIVEN,
    "functions": NOT_GIVEN,
    "logit_bias": NOT_GIVEN,
    "logprobs": NOT_GIVEN,
    "max_completion_tokens": NOT_GIVEN,
    "max_tokens": 512,
    "metadata": NOT_GIVEN,
    "modalities": NOT_GIVEN,
    "n": NOT_GIVEN,
    "parallel_tool_calls": NOT_GIVEN,
    "prediction": NOT_GIVEN,
    "presence_penalty": NOT_GIVEN,
    "reasoning_effort": NOT_GIVEN,
    "response_format": NOT_GIVEN,
    "seed": NOT_GIVEN,
    "service_tier": NOT_GIVEN,
    "stop": NOT_GIVEN,
    "store": NOT_GIVEN,
    "stream": True,
    "stream_options": NOT_GIVEN,
    "temperature": 0.1,
    "tool_choice": NOT_GIVEN,
    "tools": NOT_GIVEN,
    "top_logprobs": NOT_GIVEN,
    "top_p": 0.95,
    "user": NOT_GIVEN,
    "web_search_options": NOT_GIVEN,
    "messages": [
      {
        "role": "system",
        "content": "You are a helpful assistant."
      },
      {
        "role": "user",
        "content": "Where is Los Angeles"
      }
    ]
  }'


# Giving model error
curl https://aigw-ai-gateway.apps.gpu-ai.bd.f5.com/demo-endpoint/v1/chat/completions -k \
  -H "Content-Type: application/json" \
  -d '{
    "model": "meta-llama/Llama-3.2-3B-Instruct",
    "messages":
    [
      {
        "role": "system",
        "content":
          [{ "type": "text", "text": "You are a helpful AI assistant." }],
      },
      {
        "role": "user",
        "content":
          [
            {
              "type": "text",
              "text": "Please answer the following query. \n\nQUERY:\nwho is president of America?",
            },
          ],
      },
    ],
  }'

  # Giving model error
curl https://vllm-f5-demo.apps.gpu-ai.bd.f5.com/v1/chat/completions -k \
-H "Content-Type: application/json" \
-d '{
  "model": "meta-llama/Llama-3.2-3B-Instruct",
  "messages":
  [
    {
      "role": "system",
      "content":
        [{ "type": "text", "text": "You are a helpful AI assistant." }],
    },
    {
      "role": "user",
      "content":
        [
          {
            "type": "text",
            "text": "Please answer the following query. \n\nQUERY:\nwho is president of America?",
          },
        ],
    },
  ],
}'

# Giving model error
curl https://vllm-f5-demo.apps.gpu-ai.bd.f5.com/v1/chat/completions -k \
  -H "Content-Type: application/json" \
  -d '{
    "model": "meta-llama/Llama-3.2-3B-Instruct",
    "messages": [
      {
        "role": "system",
        "content": "You are a helpful assistant."
      },
      {
        "role": "user",
        "content": "Where is Los Angeles"
      }
    ]
  }'
