import argparse
from huggingface_hub import HfApi
print("LC2HuggingFace Fetcher v.1.0 (c)by David Honisch")
parser = argparse.ArgumentParser(
                    prog='app.py',
                    description='LC2AI Agent',
                    epilog='LC2AI Agent - (c)by David Honisch')
parser.add_argument("task", help="task number", type=str)
parser.add_argument("author", help="author", type=str)
parser.add_argument("library", help="library", type=str)
parser.add_argument("limit", help="limit e.g.:10", type=int)
args = parser.parse_args()
print(args.task+""+args.author+""+args.library+""+str(args.limit))
api = HfApi()
models = api.list_models(
    task=args.task, #"automatic-speech-recognition",  # Filter by task directly
    author=args.author,#"openai",                      # Optional: filter by author
    library=args.library,#"transformers",               # Optional: filter by library
    limit=args.limit                              # Optional: limit results
)
models = list(models)
print(len(models), models[0].modelId)
for model in models:
    print(model.modelId)
# from huggingface_hub import HfApi, ModelFilter
# api = HfApi()
# models = api.list_models(
#     filter=ModelFilter(
#         task="automatic-speech-recognition"
#     )
# )
# models = list(models)
# print(len(models))
# print(models[0].modelId)