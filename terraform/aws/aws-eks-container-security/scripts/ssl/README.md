# GENERATE CERTIFICATE 
---
openssl req \
-newkey rsa:2048 \
-new \
-nodes \
-x509 \
-days 3650 \
-subj "/CN=app-alb-1399755160.us-east-1.elb.amazonaws.com/OU=amazonaws/O=com/L=fr/ST=fr/C=fr" \
-keyout app.amazonaws.com-key.pem \
-out app.amazonaws.com-certificate.pem
----
openssl req \
-newkey rsa:2048 \
-new \
-nodes \
-x509 \
-days 3650 \
-subj "/CN=alb.us-east-1.elb.amazonaws.com/OU=amazonaws/O=com/L=fr/ST=fr/C=fr" \
-keyout id.key.for.signing.jwt.pem \
-out id.key.for.verifying.jwt.pem

# ACM CERTIFICATE
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout app-ssl-selfsigned.key -out app-ssl.crt -subj "/C=CA/ST=British Columbia/L=Vancouver/O=ACN app SSL Security/OU=IT Department/CN=app.example.com"

openssl x509 -in app-ssl.crt -noout -text


# SAMPLE APP
cd scripts/ssl/sample-app/

kubectl create secret generic app-certificates --from-file=id.key.for.signing.jwt.pem="./id.key.for.signing.jwt.pem" --from-file=id.key.for.verifying.jwt.pem="./id.key.for.verifying.jwt.pem" --from-file=key.manager.secret.id.pem="./key.manager.secret.id.pem" --from-file=app.example.com-certificate.pem="./app.example.com-certificate.pem" --from-file=app.example.com-key.pem="./app.example.com-key.pem" --dry-run=client -oyaml > certs.yaml

kubectl apply -f certs.yaml 

kubectl apply -f app-ingress.yaml