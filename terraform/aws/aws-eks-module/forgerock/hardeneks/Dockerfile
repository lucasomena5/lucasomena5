FROM python:3.8-slim-buster
FROM gcr.io/forgerock-io/java-11:latest

ENV EKS_CLUSTER_NAME cluster  
ENV HARDENEKS_INSTANCE_DIR /hardeneks
ENV AWS_REGION us-east-1 

COPY requirements.txt requirements.txt

RUN apt-get update -y
RUN pip3 install -r requirements.txt

COPY . .

#CMD ["hardeneks", "--region" , "${AWS_REGION}", "--cluster", "${EKS_CLUSTER_NAME}", "--export-html", "${HARDENEKS_INSTANCE_DIR}"]