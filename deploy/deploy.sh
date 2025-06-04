#!/bin/bash

read -r -sp "Enter Hugging Face Token : " HF_TOKEN
echo -e "\nYour Hugging Face token is $HF_TOKEN"

NAMESPACE=f5-demo

oc new-project $NAMESPACE
helm upgrade --install llm-service llm-service \
--set models.llama-3-2-1b-instruct.enabled=true \
--set models.llama-3-2-1b-instruct-quantized.enabled=true \
--set secret.hf_token="$HF_TOKEN" -n $NAMESPACE





