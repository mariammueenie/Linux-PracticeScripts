#!/bin/bash
# =========================================================
# File: web_node_setup.sh
# Purpose:
# Configure a backend Apache web server node for the
# NGINX load balancer environment.
#
# Usage examples:
# ./web_node_setup.sh "this is web hosting machine 1"
# ./web_node_setup.sh "this is web hosting machine 2"
# =========================================================

set -euo pipefail

PAGE_TEXT="${1:-this is a backend web server page}"
WEBROOT="/var/www/html/index.html"

echo "Starting backend web node setup..."

echo "Removing nginx if present..."
sudo dnf remove nginx -y || true

echo "Installing Apache..."
sudo dnf install httpd -y

echo "Enabling and starting Apache..."
sudo systemctl enable httpd
sudo systemctl start httpd
sudo systemctl status httpd --no-pager

echo "Backing up default index page if present..."
if [ -f /var/www/html/index.html ]; then
    sudo cp /var/www/html/index.html /var/www/html/backupindex
fi

echo "Writing custom webpage..."
sudo bash -c "cat > $WEBROOT" <<EOF
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Backend Web Server</title>
</head>
<body>
    <h1>$PAGE_TEXT</h1>
</body>
</html>
EOF

echo "Opening firewall for HTTP..."
sudo firewall-cmd --permanent --add-service=http --zone=public
sudo firewall-cmd --reload

echo
echo "Backend node setup complete."
hostname -I