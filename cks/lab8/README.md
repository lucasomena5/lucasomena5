# Image Vulnerability Scanning 
trivy image nginx:1.14.1 
or
trivy nginx:1.14.1 

# Scanning Images with an Admission Controller
ImagePolicyWebhook

# Image Scanner
https://github.com/linuxacademy/content-cks-trivy-k8s-webhook/blob/main/trivy-k8s-webhook.yml

sudo mv trivy-k8s-webhook.yml /etc/kubernetes/manifests
sudo chown root:root /etc/kubernetes/manifests/trivy-k8s-webhook.yml
sudo chmod 600 /etc/kubernetes/manifests/trivy-k8s-webhook.yml

kubectl get pods -n kube-system trivy-k8s-webhook-k8s-control

# add a localhost entry to /etc/hosts 
127.0.0.1 acg.trivy.k8s.webhook

# Test out the wekhook
curl https://acg.trivy.k8s.webhook:8090/scan -X POST --header "Content-Type: application/json" -d '{"spec":{"containers":[{"image":"nginx:1.19.10"},{"image":"nginx:1.14.1"}]}}' -k

# Configuring the ImagePolicyWebhook
sudo mkdir /etc/kubernetes/admission-controller
sudo wget -O /etc/kubernetes/admission-controller/imagepolicywebhook-ca.crt https://raw.githubusercontent.com/linuxacademy/content-cks-trivy-k8s-webhook/main/certs/ca.crt

sudo wget -O /etc/kubernetes/admission-control/api-server-client.crt https://raw.githubusercontent.com/linuxacademy/content-cks-trivy-k8s-webhook/main/certs/api-server-client.crt

sudo wget -O /etc/kubernetes/admission-control/api-server-client.key https://raw.githubusercontent.com/linuxacademy/content-cks-trivy-k8s-webhook/main/certs/api-server-client.key

sudo vi /etc/kubernetes/admission-control/admission-control.conf

sudo vi /etc/kubernetes/admission-control/imagepolicywebhook_backend.kubeconfig

# enable admission control to kube-apiserver
--enable-admission-plugins=NodeRestriction,ImagePolicyWebhook 
--admission-control-config-file=/etc/kubernetes/admission-control/admission-control.conf

# add volume mount
- name: admission-control
  mountPath: /etc/kubernetes/admission-control
  readOnly: true 

# add volume 
- name: admission-control
  hostPath:
    path: /etc/kubernetes/admission-control
    type: DirectoryOrCreate