#!/bin/bash
# =========================================================
# File: load_balancer_setup.sh
# Purpose:
# Configure an NGINX load balancer that forwards traffic
# to two backend Apache web servers.
# =========================================================

set -euo pipefail

LB_HOSTS_FILE="/etc/hosts"
NGINX_CONF="/etc/nginx/nginx.conf"
BACKEND1_IP="192.168.2.152"
BACKEND2_IP="192.168.2.153"
LB_IP="192.168.2.154"

echo "Starting load balancer setup..."

sudo bash -c "cat >> $LB_HOSTS_FILE" <<EOF

# Assignment 04 load balancer hosts
$LB_IP ha.example.com ha
$BACKEND1_IP ws1.example.com ws1
$BACKEND2_IP ws2.example.com ws2
EOF

echo "Installing nginx..."
sudo dnf install epel-release -y
sudo dnf install nginx -y

echo "Writing nginx configuration..."
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

sudo bash -c "cat > $NGINX_CONF" <<'EOF'
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    upstream backend {
        server 192.168.2.152;
        server 192.168.2.153;
    }

    server {
        listen 80;
        server_name ha.example.com;

        location / {
            proxy_pass http://backend;
        }
    }
}
EOF

echo "Opening firewall for HTTP..."
sudo firewall-cmd --permanent --add-service=http --zone=public
sudo firewall-cmd --reload

echo "Allowing SELinux proxy network connections..."
sudo setsebool -P httpd_can_network_connect 1

echo "Enabling and starting nginx..."
sudo systemctl enable nginx
sudo systemctl restart nginx
sudo systemctl status nginx --no-pager

echo
echo "Load balancer setup complete."
echo "Test with:"
echo "http://ha.example.com/"
echo "or"
echo "http://$LB_IP/"