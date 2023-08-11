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


kubectl apply -f kube-bench-control-plane.yaml
kubectl apply -f kube-bench-node.yaml

kubectl logs kube-bench-control-plane-pod > kube-bench-control-plane.log
kubectl logs kube-bench-node-pod > kube-bench-node.log