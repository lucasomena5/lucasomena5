openssl req -nodes -new -x509 -keyout accounts.key -out accounts.crt -subj "/CN=accounts.svc"

 kubectl create secret generic accounts-tls-certs -n accounts --from-file=tls.crt=accounts.crt --from-file=tls.key=accounts.key