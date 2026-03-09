#!/bin/bash
# =========================================================
# File: apache_ssh_site_deploy.sh
# Purpose:
# Install and enable SSH + Apache, create a website folder,
# generate a simple HTML page, and copy a local image into
# the Apache web root.
# =========================================================

set -euo pipefail

# -----------------------------
# Personal details
# -----------------------------
NAME="Mariam Mueen"
STUDENT_ID="200606351"
IMG_FILE="favourite.jpg"
WEBROOT="/var/www/html/comp2018_A3"

# -----------------------------
# Course data for webpage table
# -----------------------------
COURSES=(
  "COMP2006|Intro to C++"
  "COMP2068|JavaScript Frameworks"
  "COMP3006|Advanced Databases"
  "COMP2139|Cloud Computing Services (Azure)"
  "COMP2018|Linux System Administration"
)

echo "Starting Assignment 03 automation..."
sleep 1

# -----------------------------
# 1. Install and start SSH
# -----------------------------
echo "Installing and enabling SSH server..."
sudo dnf install openssh-server -y
sudo systemctl enable sshd
sudo systemctl start sshd
sudo systemctl status sshd --no-pager

# -----------------------------
# 2. Install and start Apache
# -----------------------------
echo "Installing and enabling webserver (httpd)..."
sudo dnf install httpd -y
sudo systemctl enable httpd
sudo systemctl start httpd
sudo systemctl status httpd --no-pager

# -----------------------------
# 3. Create deployment directory
# -----------------------------
echo "Creating deployment directory..."
sudo mkdir -p "$WEBROOT"
sudo chmod 755 "$WEBROOT"

# -----------------------------
# 4. Generate webpage
# -----------------------------
echo "Building webpage..."

TMP_HTML=$(mktemp)

cat > "$TMP_HTML" <<EOF
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Assignment 03 Webpage</title>
</head>
<body>

<h1>Welcome to my Assignment 03 Webpage</h1>

<h2>Student Info</h2>
<p><b>Name:</b> $NAME</p>
<p><b>Student Number:</b> $STUDENT_ID</p>

<h2>Courses This Semester</h2>
<table border="1" cellpadding="8">
    <tr>
        <th>Course Code</th>
        <th>Course Name</th>
    </tr>
EOF

for course in "${COURSES[@]}"; do
    CODE="${course%%|*}"
    TITLE="${course#*|}"
    echo "    <tr><td>$CODE</td><td>$TITLE</td></tr>" >> "$TMP_HTML"
done

cat >> "$TMP_HTML" <<EOF
</table>

<h2>Favourite Sport: Biking</h2>
<h2>Favourite Book: The Hunger Games Trilogy</h2>
<img src="$IMG_FILE" width="300" alt="Favourite image">

</body>
</html>
EOF

sudo cp "$TMP_HTML" "$WEBROOT/index.html"
rm -f "$TMP_HTML"

# -----------------------------
# 5. Copy image into web folder
# -----------------------------
if [ -f "$HOME/Documents/$IMG_FILE" ]; then
    sudo cp "$HOME/Documents/$IMG_FILE" "$WEBROOT/"
else
    echo "Image not found at: $HOME/Documents/$IMG_FILE"
    echo "Copy your image there, then run:"
    echo "sudo cp ~/Documents/$IMG_FILE $WEBROOT/"
fi

# -----------------------------
# 6. SELinux context fix
# -----------------------------
if command -v getenforce >/dev/null 2>&1; then
    if [ "$(getenforce)" != "Disabled" ]; then
        sudo chcon -R -t httpd_sys_content_t "$WEBROOT" || true
    fi
fi

# -----------------------------
# 7. Final output
# -----------------------------
echo
echo "Webpage created successfully."
echo "Open in browser:"
echo "http://localhost/comp2018_A3/"
echo

IP_ADDR=$(hostname -I | awk '{print $1}')
echo "Or from another machine on the same network:"
echo "http://$IP_ADDR/comp2018_A3/"