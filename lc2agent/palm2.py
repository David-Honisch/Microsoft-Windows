from google.cloud import palm

# Initialize the PaLM 2 client
client = palm.Client(api_key="your_palmp2_api_key_here")

# Generate text
response = client.generate_text(
    prompt="Write a short story about a robot learning to feel emotions.",
    max_output_tokens=150
)

print(response.result)
