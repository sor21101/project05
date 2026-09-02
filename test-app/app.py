from flask import Flask
import hashlib

app = Flask(__name__)

@app.route("/")
def load():
    value = b"load-test"

    for _ in range(300000):
        value = hashlib.sha256(value).digest()

    return "OK\n"

app.run(host="0.0.0.0", port=8080)