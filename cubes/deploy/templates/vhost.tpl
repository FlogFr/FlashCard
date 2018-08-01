server {
	listen 443 ssl;
	server_name ${VHOST_FRONT};

	access_log  /var/log/nginx/${VHOST_FRONT}.access.log;
	error_log   /var/log/nginx/${VHOST_FRONT}.error.log;

	ssl_certificate /etc/dehydrated/certs/${VHOST_FRONT}/fullchain.pem;
	ssl_certificate_key /etc/dehydrated/certs/${VHOST_FRONT}/privkey.pem;
	ssl_session_cache shared:SSL:20m;

	location / {
		root /var/www/${VHOST_FRONT};
	}
}

server {
	listen 443 ssl;
	server_name ${VHOST_API};

	access_log  /var/log/nginx/${VHOST_API}.access.log;
	error_log   /var/log/nginx/${VHOST_API}.error.log;

	ssl_certificate /etc/dehydrated/certs/${VHOST_API}/fullchain.pem;
	ssl_certificate_key /etc/dehydrated/certs/${VHOST_API}/privkey.pem;
	ssl_session_cache shared:SSL:20m;

	location / {
		proxy_set_header Host $host;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_pass http://127.1:8080/;
	}
}

server {
	listen 80;
	server_name ${VHOST_FRONT} ${VHOST_API};

	access_log  /var/log/nginx/http.access.log;
	error_log   /var/log/nginx/http.error.log;

	location / {
		rewrite ^(.*) https://$host$1 permanent;
	}

	location ^~ /.well-known/acme-challenge {
		alias /var/www/dehydrated;
	}
}
