import json
import logging
import os
import random
import time

from flask import Flask, Response, jsonify, request
from prometheus_client import CONTENT_TYPE_LATEST, Counter, Histogram, generate_latest

APP_NAME = os.getenv("APP_NAME", "app-a")
CLUSTER_NAME = os.getenv("CLUSTER_NAME", "unknown")
app = Flask(__name__)

REQUESTS = Counter("http_requests_total", "HTTP requests", ["app", "method", "path", "status"])
LATENCY = Histogram("http_request_duration_seconds", "Request latency", ["app", "path"])


class JsonFormatter(logging.Formatter):
    def format(self, record):
        return json.dumps({
            "severity": record.levelname,
            "message": record.getMessage(),
            "app": APP_NAME,
            "cluster": CLUSTER_NAME,
            "timestamp": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        })


handler = logging.StreamHandler()
handler.setFormatter(JsonFormatter())
app.logger.handlers = [handler]
app.logger.setLevel(logging.INFO)


@app.after_request
def record(response):
    REQUESTS.labels(APP_NAME, request.method, request.path, response.status_code).inc()
    app.logger.info(f"request path={request.path} status={response.status_code}")
    return response


@app.get("/")
def home():
    return jsonify(application=APP_NAME, cluster=CLUSTER_NAME, status="ok", message="Welcome to Application A")


@app.get("/healthz")
def health():
    return jsonify(status="healthy"), 200


@app.get("/readyz")
def ready():
    return jsonify(status="ready"), 200


@app.get("/work")
def work():
    delay_ms = min(int(request.args.get("delay_ms", random.randint(20, 200))), 2000)
    with LATENCY.labels(APP_NAME, "/work").time():
        time.sleep(delay_ms / 1000)
    return jsonify(delay_ms=delay_ms, status="completed")


@app.get("/error")
def error():
    app.logger.error("synthetic error requested for observability validation")
    return jsonify(error="synthetic failure", purpose="dashboard validation"), 500


@app.get("/metrics")
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)

