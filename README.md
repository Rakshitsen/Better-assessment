
# EC2 Instance Metrics Dashboard

A Flask web application that displays real-time EC2 instance metrics (CPU, Memory, and Disk utilization) as speedometer (gauge) charts, along with the instance's private IP address.

## Features

- **Live Dashboard:** Visualizes CPU, memory, and disk utilization using Plotly gauges.
- **Private IP Display:** Shows the EC2 instance's private IP address.
- **Simple Setup:** Minimal configuration needed; runs on any EC2 Linux instance.

## Requirements

- Python 3.7+
- Flask
- psutil
- plotly
- (Optional) boto3 (if you want to fetch AWS metadata)

## Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/Rakshitsen/flask-ec2-dashboard.git
   cd flask-ec2-dashboard
   ```

2. **Install dependencies:**

   ```bash
   pip install flask psutil plotly
   ```

3. **(Optional) If you want to use AWS metadata for more details:**

   ```bash
   pip install boto3
   ```

## Usage

1. **Run the Flask app:**

   ```bash
   python app.py
   ```

2. **Visit the dashboard:**

   Open your browser and go to: [http://localhost:5000](http://localhost:5000) (or the EC2 instance's public IP if running remotely).

## Project Structure

```
.
├── app.py
├── test_app.py
└── templates/
    └── dashboard.html
```

- `app.py`: Main Flask application.
- `test_app.py`: Unit tests for the Flask app.
- `templates/dashboard.html`: HTML template with Plotly gauges.

## Screenshot

*(Add a screenshot of your dashboard here)*

## Notes

- The app uses `psutil` to gather system metrics, so it works best when run directly on the EC2 instance you want to monitor.
- The gauges auto-update only upon page refresh. For real-time updates, consider adding AJAX or WebSocket support.

## Testing

To run tests:

```bash
python test_app.py
```

## Contributing

Pull requests and suggestions are welcome! Please open an issue for any bugs or feature requests.

## License

MIT
=======
