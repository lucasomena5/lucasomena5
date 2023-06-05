# GENERATE CERTIFICATE 
---
openssl req \
-newkey rsa:2048 \
-new \
-nodes \
-x509 \
-days 3650 \
-subj "/CN=ig-alb-1399755160.us-east-1.elb.amazonaws.com/OU=amazonaws/O=com/L=fr/ST=fr/C=fr" \
-keyout ig.amazonaws.com-key.pem \
-out ig.amazonaws.com-certificate.pem
----
openssl req \
-newkey rsa:2048 \
-new \
-nodes \
-x509 \
-days 3650 \
-subj "/CN=ig-alb-1399755160.us-east-1.elb.amazonaws.com/OU=amazonaws/O=com/L=fr/ST=fr/C=fr" \
-keyout id.key.for.signing.jwt.pem \
-out id.key.for.verifying.jwt.pem

# ACM CERTIFICATE
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ig-ssl-selfsigned.key -out ig-ssl.crt -subj "/C=CA/ST=British Columbia/L=Vancouver/O=ACN IG SSL Security/OU=IT Department/CN=ig.example.com"

openssl x509 -in ig-ssl.crt -noout -text


# SAMPLE APP
kubectl create configmap ig-certificates \ 
--from-file=id.key.for.signing.jwt.pem=./id.key.for.signing.jwt.pem \ 
--from-file=id.key.for.verifying.jwt.pem=./id.key.for.verifying.jwt.pem \ 
--from-file=key.manager.secret.id.pem=./key.manager.secret.id.pem \ 
--from-file=ig.example.com-certificate.pem=./ig.example.com-certificate.pem \ 
--from-file=ig.example.com-key.pem=./ig.example.com-key.pem \ 
--dry-run=client -oyaml > certs.yaml

kubectl apply -f certs.yaml 

kubectl apply -f ig-ingress.yaml