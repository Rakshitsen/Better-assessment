from flask import Flask, render_template
import psutil
import socket

app = Flask(__name__)

def get_private_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(('10.255.255.255', 1))
        IP = s.getsockname()[0]
    except Exception:
        IP = '127.0.0.1'
    finally:
        s.close()
    return IP

@app.route("/")
def home():
    cpu = psutil.cpu_percent(interval=1)
    memory = psutil.virtual_memory().percent
    disk = psutil.disk_usage('/').percent
    private_ip = get_private_ip()
    return render_template(
        "dashboard.html",
        cpu=cpu,
        memory=memory,
        disk=disk,
        private_ip=private_ip
    )

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
