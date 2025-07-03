#!/bin/bash

read -r -sp "Enter Hugging Face Token : " HF_TOKEN
echo -e "\nYour Hugging Face token is $HF_TOKEN"

NAMESPACE=f5-demo

echo "Creating namespace $NAMESPACE"
oc new-project $NAMESPACE

echo "Installing LLMs in namespace $NAMESPACE. This will take around 15-20 mins"
helm upgrade --install llm-service llm-service -n $NAMESPACE \
--set models.granite-3-3-2b-instruct.enabled=true \
--set models.llama-3-2-1b-instruct-quantized.enabled=true \
--set secret.hf_token="$HF_TOKEN" -n $NAMESPACE

echo "Installing LLama Stack server in namespace $NAMESPACE"
helm upgrade --install llama-stack llama-stack -n $NAMESPACE \
--set models.granite-3-3-2b-instruct.enabled=true \
--set models.llama-3-2-1b-instruct-quantized.enabled=true \
--set models.f5-ai-gateway.enabled=true \
--set models.f5-ai-gateway.url=http://aigw.ai-gateway.svc.cluster.local/demo-endpoint/v1

echo "Installing F5 Demo UI server in namespace $NAMESPACE"
helm upgrade --install demo-ui demo-ui -n $NAMESPACE
