# Use Ubuntu as the base image
FROM ubuntu:latest
# Update the package list and install necessary packages
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/*
# Set the JAVA_HOME environment variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
# Install JMeter (assuming you have JMeter binaries available locally)
COPY apache-jmeter-5.5.1 /jmeter
# Set JMeter home and add JMeter to PATH
ENV JMETER_HOME /jmeter
ENV PATH $JMETER_HOME/bin:$PATH
# Set the working directory
WORKDIR /jmeter
# Start JMeter GUI by default
CMD ["jmeter"]