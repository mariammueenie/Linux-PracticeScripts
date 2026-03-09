#!/bin/bash
# =========================================================
# File: apache_htaccess_security_setup.sh
# Purpose:
# Install Apache, create a sample protected directory,
# generate an index page, configure .htaccess-based
# Basic Authentication, and restart the web server.
# =========================================================

set -euo pipefail

WEBROOT="/var/www/html"
read -rp "Enter the folder name to create inside /var/www/html: " FOLDER_NAME
TARGET_DIR="$WEBROOT/$FOLDER_NAME"
HTPASSWD_FILE="/etc/httpd/.htpasswd"

COURSES=(
  "COMP2006 - Intro to C++"
  "COMP2068 - JavaScript Frameworks"
  "COMP2139 - Cloud Computing Services (Azure)"
  "COMP2018 - Linux System Administration"
)

echo "Installing Apache..."
sudo dnf install httpd -y

echo "Enabling and starting Apache..."
sudo systemctl enable httpd
sudo systemctl start httpd

echo "Creating protected deployment folder..."
sudo mkdir -p "$TARGET_DIR"

echo "Creating sample webpage..."
TMP_HTML=$(mktemp)

{
  echo "<html>"
  echo "<body>"
  echo "<h1>Website to test .htaccess security</h1>"
  echo "<p>Today's date: $(date)</p>"
  echo "<h2>Courses Currently Studying</h2>"
  echo "<ul>"
  for course in "${COURSES[@]}"; do
    echo "<li>$course</li>"
  done
  echo "</ul>"
  echo "<p>Dummy page for testing..</p>"
  echo "</body>"
  echo "</html>"
} > "$TMP_HTML"

sudo cp "$TMP_HTML" "$TARGET_DIR/index.html"
rm -f "$TMP_HTML"

echo "Creating .htaccess file..."
sudo bash -c "cat > '$TARGET_DIR/.htaccess'" <<EOF
AuthType Basic
AuthName "Restricted Content"
AuthUserFile $HTPASSWD_FILE
Require valid-user
EOF

echo "Ensuring Apache allows .htaccess overrides..."
CONF_FILE="/etc/httpd/conf/httpd.conf"

if ! sudo grep -q "<Directory \"$WEBROOT\">" "$CONF_FILE"; then
  echo "Warning: could not automatically confirm Directory block in $CONF_FILE"
  echo "You may need to manually ensure AllowOverride AuthConfig or AllowOverride All is enabled."
else
  sudo sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' "$CONF_FILE" || true
fi

echo "Creating password file..."
read -rp "Enter username for protected access: " AUTH_USER
sudo htpasswd -c "$HTPASSWD_FILE" "$AUTH_USER"

echo "Restarting Apache..."
sudo systemctl restart httpd
sudo systemctl status httpd --no-pager

echo
echo "Protected site created."
echo "Test in browser at:"
echo "http://localhost/$FOLDER_NAME"
echo
echo "Check logs with:"
echo "sudo cat /var/log/httpd/access_log | tail -5"