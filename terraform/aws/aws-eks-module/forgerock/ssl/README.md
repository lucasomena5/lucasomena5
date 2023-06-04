# GENERATE CERTIFICATE 


sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ig-ssl-selfsigned.key -out ig-ssl.crt -subj "/C=CA/ST=British Columbia/L=Vancouver/O=ACN IG SSL Security/OU=IT Department/CN=ig.example.com"

openssl x509 -in ig-ssl.crt -noout -text


# SAMPLE APP
kubectl create configmap ig-certificates --from-file=id.key.for.signing.jwt.pem=./id.key.for.signing.jwt.pem --from-file=id.key.for.verifying.jwt.pem=./id.key.for.verifying.jwt.pem --from-file=key.manager.secret.id.pem=./key.manager.secret.id.pem --from-file=ig.example.com-certificate.pem=./ig.example.com-certificate.pem --from-file=ig.example.com-key.pem=./ig.example.com-key.pem --dry-run=client -oyaml > certs.yaml

kubectl apply -f certs.yaml 

kubectl apply -f ig-ingress.yaml