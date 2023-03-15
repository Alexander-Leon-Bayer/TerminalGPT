import os
import openai
import sys
import pickle

openai.api_key = ""

SystemMessage = {"role": "system", "content": "You are a helpful assistant.  My name is Alex, refer to me by name"}
context = [SystemMessage]
try:
    with open('context.pkl', 'rb') as f:
        context = pickle.load(f)
except: FileNotFoundError: context = []

while(True):
    
    with open('context.pkl', 'wb') as f:
        pickle.dump(context, f)

    input_str = input("User: ")
    #user_input = input("User: ")
    user_input = input_str
    context.append({"role": "user", "content": user_input})
    if len(context) > 100:
        context[-100:].append(SystemMessage)
        context[-100:].append({"role": "user", "content": user_input})
    #print(context)
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=context
    )
    message = response["choices"][0]["message"]["content"]
    print("Assistant: " + message)
    # update the context with the prompt and response
    context.append({"role": "user", "content": user_input})
    context.append({"role": "assistant", "content": message})






