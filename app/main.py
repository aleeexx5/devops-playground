from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def describe():
    return { "status": "ok", "app": "devops-playground" }

@app.get("/health")
def health():
    return { "status": "ok" }

@app.get("/info")
def info():
    return { "version": "1.0.0", "environment": "playground" }