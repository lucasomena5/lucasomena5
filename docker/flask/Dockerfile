FROM ubuntu 

RUN apt-get update 
RUN apt-get -y install python python-pip

RUN pip install flask
RUN pip install flask-mysql

COPY app.py /opt/app.py

ENTRYPOINT FLASK_APP=/opt/source-code/app.py flask run --host=0.0.0.0

