import anthropic

# Set your Anthropic API key
client = anthropic.Anthropic(api_key="your_claude_api_key_here")

# Generate text
response = client.completions.create(
    model="claude-3-5-sonnet-20240604",
    prompt="Write a short story about a robot learning to feel emotions.",
    max_tokens=150
)

print(response.completion)
