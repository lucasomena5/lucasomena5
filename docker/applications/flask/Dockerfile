FROM ubuntu 

RUN apt-get update 
RUN apt-get -y install python3 python3-pip

RUN pip install flask
RUN pip install flask-mysql

COPY app-color.py /opt/app.py

ENTRYPOINT FLASK_APP=/opt/source-code/app.py flask run --host=0.0.0.0

