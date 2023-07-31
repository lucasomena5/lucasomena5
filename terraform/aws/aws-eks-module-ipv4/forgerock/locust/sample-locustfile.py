import time 
from locust import HttpUser, task 

class DemoUser(HttpUser):
    @task 
    def loadTesting(self):
        self.client.get("/")

    def onStart(self):
        self.client.post("/login", json={"username": "test", "password": "password"})