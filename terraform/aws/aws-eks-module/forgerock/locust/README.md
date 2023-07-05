locust -f ./forgerock/locust/locustfile.py --headless -u 100 -r 5 --host https://ig-alb-336528761.us-east-1.elb.amazonaws.com --web-port 8443

locust -f locustfile.py --headless -u 100 -r 5 --host http://ig-alb-336528761.us-east-1.elb.amazonaws.com --web-port 80 -t 60m