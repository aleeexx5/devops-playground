from fastapi import FastAPI
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI()

Instrumentator().instrument(app).expose(app, endpoint="/metrics")

@app.get("/")
def describe():
    return { "status": "ok", "app": "devops-playground", "version": "2.0.0" }

@app.get("/health")
def health():
    return { "status": "ok" }

@app.get("/info")
def info():
    return { "environment": "playground" }