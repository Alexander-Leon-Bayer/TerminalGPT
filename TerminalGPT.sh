#!/bin/bash

function TerminalGPT(){
    # This function is used to run the GPT-3 chatbot in the terminal
    PYTHON_ARG="$1"
    echo "User: $1"
    python - <<END
import openai
import sys
import pickle

openai.api_key = ""

SystemMessage = {"role": "system", "content": "You are a concise assistant."}
context = [SystemMessage]
try:
    with open('TerminalContext.pkl', 'rb') as f:
        context = pickle.load(f)
except: FileNotFoundError: context = []

with open('TerminalContext.pkl', 'wb') as f:
    pickle.dump(context, f)

input_str = "$1"
user_input = input_str
context.append({"role": "user", "content": user_input})
if len(context) > 100:
    context[-20:].append(SystemMessage)
    context[-20:].append({"role": "user", "content": "i only use macos terminal.  If i ask how to do something, your response should ONLY be the command I need and nothing more."})
    context[-20:].append({"role": "user", "content": user_input})
response = openai.ChatCompletion.create(
    model="gpt-3.5-turbo",
    messages=context
)
message = response["choices"][0]["message"]["content"]
print("Assistant: " + message)
# update the context with the prompt and response
context.append({"role": "user", "content": user_input})
context.append({"role": "assistant", "content": message})
with open('TerminalContext.pkl', 'wb') as f:
    pickle.dump(context, f)
END
}

if [ "$1" != "" ]; then
    TerminalGPT "$1"
else
    echo "No arguments supplied"
fi