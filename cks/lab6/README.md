# Pod Security Policy 
enforce configuration

e.g.
- Privileged Mode 
- Host namespaces 
- RunAsUser / RunAsGroup
- Volumes
- AllowedHostPaths

* Deprecated and will be replaced by different funtionality in the future

# Admission controller
sudo vi /etc/kubernetes/manifests/kube-apiserver.yaml

--enable-admission-plugins=NodeRestrition,PodSecuirtyPolicy

# Create PodSecurityPolicy
kubectl create -f psp-nopriv.yaml 

kubectl create namespace psp-test

kubectl create serviceaccount psp-test-sa -n psp-test 

# OPA Gatekeeper
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/release-3.5/deploy/gatekeeper.yaml

Create constraints using rego ("ray-go") programming language 

# Secrets 
using volumeMounts and Env Variables

# Runtime Sandbox
gVisor/runsc 

Run these commands in all three nodes
curl -fsSL https://gvisor.dev/archive.key | sudo apt-key add - 

sudo add-apt-repository "deb [arch=amd64,arm64] https://storage.googleapis.com/gvisor/releases release main"

sudo apt-get update && sudo apt-get install -y runsc 

sudo vi /etc/containerd/config.toml

- Add to disabled_plugins = ["io.containerd.internal.v1.restart"]
- Under plugins, add a new block 
[plugins."io.containerd.grp.v1.cri".containerd.runtimes.runc]
  runtime_type = "io.containerd.runsc.v1"
- Edit shim_debug to true 
- Restart containerd service 
sudo systemctl restart containerd 
sudo systemctl status containerd

# Running sandbox containers 
kubectl exec pod-name -- dmesg 
- dmesg gets kernel info

# Signing Certificate 
sudo apt-get install -y golang-cfssl

cat <<EOF | cfssl genkey - | cfssljson -bare server
{
  "hosts": [
    "my-svc.my-namespace.svc.cluster.local",
    "my-pod.my-namespace.pod.cluster.local",
    "192.0.2.24",
    "10.0.34.2"
  ],
  "CN": "my-pod.my-namespace.pod.cluster.local",
  "key": {
    "algo": "ecdsa",
    "size": 256
  },
  "names": [
    {
        "O": "system:nodes"l
    }
  ]
}
EOF

# Check certificate request
kubectl get csr 

# Approve certificate in pending state
kubectl certificate approve <certificate-name>

# Show certificate decoded
kubectl get csr <certificate-name> -ojsonpath='{.status.certificate}' | base64 --decode

