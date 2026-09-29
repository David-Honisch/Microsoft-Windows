import openai

# Set your OpenAI API key
openai.api_key = "your_openai_api_key_here"

# Generate text
response = openai.Completion.create(
    engine="gpt-4",
    prompt="Write a short story about a robot learning to feel emotions.",
    max_tokens=150
)

print(response.choices[0].text)
