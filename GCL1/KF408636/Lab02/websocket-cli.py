#!/usr/bin/python
import asyncio
from websockets.sync.client import connect

def hello():
  with connect("ws://172.17.0.2:9090/ws") as websocket:
    websocket.send("2136")
    message = websocket.recv()
    print(f"Received: {message}")

    websocket.send("9000")
    message = websocket.recv()
    print(f"Received: {message}")

    message = websocket.recv()
    print(f"Received: {message}")

hello()