from transformers import AutoModelForCausalLM, AutoTokenizer

# Load the Llama 3 model and tokenizer
model_name = "meta-llama/Llama-3-8b-chat-hf"
model = AutoModelForCausalLM.from_pretrained(model_name)
tokenizer = AutoTokenizer.from_pretrained(model_name)

# Input prompt
prompt = "Write a short story about a robot learning to feel emotions."

# Tokenize and generate
inputs = tokenizer(prompt, return_tensors="pt")
outputs = model.generate(**inputs, max_length=150)

# Decode and print the result
print(tokenizer.decode(outputs[0], skip_special_tokens=True))