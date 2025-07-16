import unittest
from app import app

class FlaskAppTestCase(unittest.TestCase):
    def setUp(self):
        # Sets up the test client
        self.app = app.test_client()
        self.app.testing = True

    def test_home_status_code(self):
        # Test that the home page loads correctly
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)

    def test_home_content(self):
        # Test that the home page contains expected keys/labels
        response = self.app.get('/')
        content = response.get_data(as_text=True)
        self.assertIn("EC2 Instance Metrics", content)
        self.assertIn("CPU Utilization (%)", content)
        self.assertIn("Memory Utilization (%)", content)
        self.assertIn("Disk Utilization (%)", content)
        self.assertIn("Private IP:", content)

if __name__ == '__main__':
    unittest.main()
