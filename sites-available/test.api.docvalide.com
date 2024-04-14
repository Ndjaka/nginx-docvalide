server {
    listen 80;
    listen [::]:80;
    server_name www.test-api.docvalide.com test-api.docvalide.com;

        location / {
         proxy_pass http://localhost:8083/;
         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
         proxy_set_header X-Forwarded-Proto $scheme;
         proxy_set_header X-Forwarded-Port $server_port;
    }

}

