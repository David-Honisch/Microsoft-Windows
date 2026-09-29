import os
from qwen import Qwen

# Set your API key and other configurations
os.environ["QWEN_API_KEY"] = "your_api_key_here"

# Initialize the Qwen model
qwen = Qwen(model="qwen-max")

# Generate text
response = qwen.generate("Write a short story about a robot learning to feel emotions.")
print(response)
