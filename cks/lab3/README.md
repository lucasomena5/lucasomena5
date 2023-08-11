# TLS certs
openssl req -nodes -new -x509 -keyout tls-ingress.key -out tls-ingress.crt -subj "/CN=ingress.test"

base64 tls-ingress.crt
base64 tls-ingress.key