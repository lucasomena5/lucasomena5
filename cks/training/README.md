##### Cluster Setup module

###
### CIS BENCHMARK
###

# kube-bench
# ACloudGuru
wget -O kube-bench-control-plane.yaml https://raw.githubusercontent.com/ACloudGuru-Resources/Course-Certified-Kubernetes-Security-Specialist/main/kube-bench-control-plane.yaml
wget -O kube-bench-node.yaml https://raw.githubusercontent.com/ACloudGuru-Resources/Course-Certified-Kubernetes-Security-Specialist/main/kube-bench-node.yaml

# Aqua Security Official 
wget -O kube-bench-control-plane.yaml https://raw.githubusercontent.com/aquasecurity/kube-bench/main/job-master.yaml
wget -O kube-bench-node.yaml https://raw.githubusercontent.com/aquasecurity/kube-bench/main/job-node.yaml

#### Known Issue ####
Even though the issues are fixed, a few outputs from kubectl logs may still show [FAIL] checks due to a known issue (https://github.com/aquasecurity/kube-bench/issues/574). In this case, you can alternatively download and install kube-bench for more accurate results:

curl -L https://github.com/aquasecurity/kube-bench/releases/download/v0.6.9/kube-bench_0.6.9_linux_amd64.deb -o kube-bench_0.6.9_linux_amd64.deb
sudo apt install ./kube-bench_0.6.9_linux_amd64.deb -f
#### Known Issue ####
```
kubectl apply -f kube-bench-control-plane.yaml
```
```
kubectl apply -f kube-bench-node.yaml
```
```
kubectl logs kube-bench-control-plane-pod > kube-bench-control-plane.log
```
```
kubectl logs kube-bench-node-pod > kube-bench-node.log
```

# Fixing issues
kubelet file
/etc/systemd/system/kubelet.service.d/10-kubeadm.conf
/var/lib/kubelet/config.yaml

###
### TLS
###
Generate new self-signed certs 
Create an ingress using TLS 

###
### Node Endpoints
###
Ports          |          Purpose
6443           |      Kubernetes API Server
2379-2380      |      etcd
10250          |      kubelet API
10251          |      kube-scheduler
10252          |      kube-controller-manager
30000-32767    |      NodePort services

###
### Securing GUI Elements
###
e.g. How to protect Kubernetes Dashboard

###
### Kubernetes Platform Binaries
###
kubectl 
kubeadm
kubelet

Use checksum files to verify binaries before running it
e.g. kubectl 
```
kubectl version --short --client
```
```
curl -LO "https://dl.k8s.io/<kubectl client version>/bin/linux/amd64/kubectl.sha256"
```
# Delete the placeholder and replace it from kubectl version output

```
echo "$(<kubectl.sha256) /usr/bin/kubectl" | sha256sum --check
```

###
### SERVICE ACCOUNTS
###
kubectl -n sunnydale auth can-i create pods --as system:serviceaccount:sunnydale:buffy-sa
kubectl -n sunnydale auth can-i list pods --as system:serviceaccount:sunnydale:buffy-sa


# Best practices and recommendations (https://www.wiz.io/academy/kubernetes-security-best-practices#best-practices-and-recommendations-23)
Enable RBAC

Use namespaces properly

Use proper, verified container images

Implement runtime container forensics

Continuously upgrade

Perform proper logging

Practice isolation

Turn on auditing

Apply CIS benchmarks