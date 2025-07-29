FROM jenkins/jenkins:jdk17

LABEL org.opencontainers.image.authors="Lucas Omena"
LABEL org.opencontainers.image.version="1.0.2"
LABEL org.opencontainers.image.description="Jenkins with Docker, Terraform, and DevSecOps tools"

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:8080/login || exit 1

USER root

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    sudo \
    curl \
    unzip \
    gnupg \
    lsb-release \
    software-properties-common \
    docker.io \
    python3 \
    python3-pip \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Give jenkins user passwordless sudo
RUN echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Add jenkins to docker group so it can run docker
RUN usermod -aG docker jenkins

# Install Terraform inside Jenkins shell
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
RUN curl -fsSL https://releases.hashicorp.com/terraform/1.8.4/terraform_1.8.4_linux_amd64.zip -o /tmp/terraform.zip \
    && unzip /tmp/terraform.zip -d /usr/local/bin \
    && rm /tmp/terraform.zip

RUN jenkins-plugin-cli --plugins \
    terraform \
    docker-workflow \
    blueocean \
    git \
    github \
    pipeline-utility-steps \
    aws-credentials \
    azure-credentials \
    google-oauth-plugin

USER jenkins