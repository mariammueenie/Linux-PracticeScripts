# 03 - Web Server and Static Site Deployment

Built a Bash-based Linux deployment script to automate OpenSSH and Apache installation, configure services with `systemd`, create and populate a web root under `/var/www/html`, generate a static HTML page from script output, deploy media assets, and validate the hosted site through localhost and browser testing on Fedora.

## File

- `apache_ssh_site_deploy.sh`

## What the Script Does

This script:

- installs `openssh-server`
- enables and starts the `sshd` service
- installs Apache (`httpd`)
- enables and starts the `httpd` service
- creates a website deployment directory inside `/var/www/html`
- generates an `index.html` webpage from within the Bash script
- adds student information and a course table to the webpage
- copies a local image into the website directory
- applies SELinux content context if needed
- serves the webpage through Apache
- prints localhost and network URLs for testing

## Skills Demonstrated

- Bash scripting
- Linux package management with `dnf`
- service management with `systemctl`
- SSH server setup
- Apache web server deployment
- Linux filesystem and directory management
- file copying and deployment
- static HTML generation from Bash
- local web hosting on Fedora
- browser-based validation and testing
- basic SELinux-aware deployment workflow

## Deployment Output

- `index.html` created in `/var/www/html/comp2018_A3`
- `favourite.jpg` copied into the same deployment directory
- website accessible through:
  - `http://localhost/comp2018_A3/`
  - `http://<machine-ip>/comp2018_A3/`

## Screenshots

### Create and run the script
![Create and run the script](screenshots/assignment03_p1.png)

### SSH service setup output
![SSH service setup output](screenshots/assignment03_p2.png)

### Apache service setup output
![Apache service setup output](screenshots/assignment03_p3.png)

### Deployment directory and file copy
![Deployment directory and file copy](screenshots/assignment03_p4.png)

### Webpage browser result
![Webpage browser result](screenshots/assignment03_p5.png)

### Script source header
![Script source header](screenshots/assignment03_p6.png)

### Script HTML generation section
![Script HTML generation section](screenshots/assignment03_p7.png)

### Rerun script output
![Rerun script output](screenshots/assignment03_p8(somechangesmade).png)

### Apache output and existing directory message
![Apache output and existing directory message](screenshots/assignment03_p9.png)

### Updated webpage browser result
![Updated webpage browser result](screenshots/assignment03_p10.png)

## Run

From the repo root:

```bash
chmod +x 03-web-server-and-static-site-deployment/apache_ssh_site_deploy.sh
./03-web-server-and-static-site-deployment/apache_ssh_site_deploy.sh