#!/bin/bash
sudo apt-get install -y install build-essential golang mercurial git
git clone https://github.com/inconshreveable/ngrok.git ngrok
cd ngrok
NGROK_DOMAIN="ngrok1280.joe1280.com"
openssl genrsa -out base.key 2048
openssl req -new -x509 -nodes -key base.key -days 10000 -subj "/CN=$NGROK_DOMAIN" -out base.pem
openssl genrsa -out server.key 2048
openssl req -new -key server.key -subj "/CN=$NGROK_DOMAIN" -out server.csr
openssl x509 -req -in server.csr -CA base.pem -CAkey base.key -CAcreateserial -days 10000 -out server.crt
cp base.pem assets/client/tls/ngrokroot.crt
make release-server release-client
sudo ./bin/ngrokd -tlsKey=server.key -tlsCrt=server.crt -domain=$NGROK_DOMAIN -httpAddr=":8081" -httpsAddr=":8082"
sudo GOOS=windows  GOARCH=386 make release-client
sudo GOOS=linux  GOARCH=amd64 make release-client