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

