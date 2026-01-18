from fastapi import FastAPI
import socket
import os

app = FastAPI()

@app.get("/")
def root():
    return {
        "app": "FastAPI GitOps Demo",
        "pod": socket.gethostname(),
        "region": os.getenv("AWS_REGION", "unknown")
    }

@app.get("/health")
def health():
    return {"status": "ok"}
