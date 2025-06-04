#!/bin/bash

NAMESPACE=f5-demo

helm delete llm-service llm-service -n $NAMESPACE
sleep 30
oc delete namespace $NAMESPACE
