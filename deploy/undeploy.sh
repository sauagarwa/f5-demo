#!/bin/bash

NAMESPACE=f5-demo

echo "Uninstalling F5 Demo..."

echo "Removing Demo UI..."
helm delete demo-ui -n $NAMESPACE

echo "Removing LLama Stack server..."
helm delete llama-stack -n $NAMESPACE

echo "Removing LLMs..."
helm delete llm-service  -n $NAMESPACE

sleep 30

echo "Deleting namespace f5-demo..."
oc delete namespace $NAMESPACE

