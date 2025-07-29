# Jenkins DevSecOps for Kubernetes

This project provides a **custom Jenkins Docker image** with preinstalled tools for DevSecOps pipelines, deployed to a **Kubernetes cluster** using a simple `Deployment` and `Service` manifest.

Created and maintained by **Lucas Omena**, the Jenkins setup enables:
- Docker access from within Jenkins
- Sudo privileges for plugin and tool installs
- Built-in Terraform CLI
- Preinstalled Jenkins plugins for cloud IaC and CI/CD

---

## Image Details

- **Base Image**: `jenkins/jenkins:jdk17`
- **Custom Tag**: `jenkins:1.0.2`
- **Registry**: `registry:5010/jenkins:1.0.2`
- **Maintainer**: Lucas Omena

### Preinstalled Tools

| Tool         | Version         |
|--------------|-----------------|
| Docker       | via `apt`       |
| Python 3     | + pip           |
| Terraform    | 1.8.4           |

### Preinstalled Jenkins Plugins

- `terraform`
- `docker-workflow`
- `blueocean`
- `git`, `github`
- `pipeline-utility-steps`
- `aws-credentials`
- `azure-credentials`
- `google-oauth-plugin`

---

## Deploying to Kubernetes

### 1 Build the Docker Image

```bash
docker build -t jenkins:1.0.2 .
docker tag jenkins:1.0.2 registry:5010/jenkins:1.0.2
docker push registry:5010/jenkins:1.0.2
```

> Replace `registry:5010` with your actual private Docker registry URL.

### 2 Apply the Kubernetes Manifests

```bash
kubectl create namespace devsecops
kubectl apply -f jenkins-deployment.yaml
```

### 3 Access Jenkins

Once deployed, Jenkins is available at:

```
http://localhost:30080
```

Get the admin password:

```bash
kubectl -n devsecops exec -it $(kubectl -n devsecops get pod -l app=jenkins -o jsonpath="{.items[0].metadata.name}") -- \
  cat /var/jenkins_home/secrets/initialAdminPassword
```

---

## Kubernetes Manifest Overview

Your deployment includes:

### Deployment

* **1 Jenkins pod**
* Uses image `registry:5010/jenkins:1.0.2`
* Runs on port 8080 (UI) and 50000 (agent)
* `imagePullPolicy: Never` — uses locally loaded images (for dev)
* `privileged: true` — allows Docker access
* `emptyDir` volume for Jenkins home (ephemeral)

### Service

* **NodePort** service
* Exposes:

  * Jenkins UI on `localhost:30080`
  * Agent port on `localhost:31000`

---

## Notes

* The image must be **loaded into your local cluster's Docker daemon** (e.g. Docker Desktop or Minikube).
* Use `imagePullPolicy: Never` **only** if you're using local images.
* Consider replacing `emptyDir` with a PersistentVolumeClaim for persistent Jenkins data.
* For production, use Ingress + TLS + PVC for stability and security.

---

## Next Steps

* [ ] Add persistent storage
* [ ] Add Ingress with HTTPS
* [ ] Add GitHub webhook integration
* [ ] Add security tools (e.g. Checkov, Trivy) into the image
* [ ] Define Jenkins pipelines for IaC, CI/CD, and DevSecOps scanning

---

## Author

**Lucas Omena**
Jenkins + Kubernetes + DevSecOps Engineer

---

## License

This project inherits the license from the base `jenkins/jenkins` Docker image.