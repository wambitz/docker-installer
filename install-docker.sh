#!/usr/bin/env bash
#
# install-docker.sh
#
# This script installs Docker CE, Docker Compose, and related tools
# on an Ubuntu system according to Docker's official instructions.

# 1. Remove any conflicting or outdated Docker-related packages
#    We use 'for pkg in ...; do ...; done' to iterate through all specified packages and remove them if they exist.
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc
do
  sudo apt-get remove -y "$pkg"
done

# 2. Update apt package index to ensure we are pulling the latest information
sudo apt-get update

# 3. Install necessary packages for adding Docker’s GPG key over HTTPS
sudo apt-get install -y ca-certificates curl

# 4. Create a directory to store the Docker GPG key (if it doesn’t exist already)
#    The directory is created with permissions 0755 (rwxr-xr-x).
sudo install -m 0755 -d /etc/apt/keyrings

# 5. Download Docker’s official GPG key and save it to /etc/apt/keyrings/docker.asc
#    The -fsSL flags mean: fail silently (-f), show error if any (-S), follow redirects (-L).
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

# 6. Make the GPG key readable by all users
sudo chmod a+r /etc/apt/keyrings/docker.asc

# 7. Add Docker’s stable repository to the system’s APT sources list
#    We dynamically insert the system architecture and Ubuntu release codename.
#    The 'signed-by' attribute ensures packages are verified using the provided GPG key.
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 8. Update apt package index again to include Docker’s newly added repository
sudo apt-get update

# 9. Install Docker CE (Community Edition), Docker CLI, containerd, Buildx plugin, and Compose plugin
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 10. (Optional) Verify Docker installation by running the hello-world image
sudo docker run hello-world

# 11. Create a 'docker' group if it does not exist, to allow managing Docker as a non-root user
sudo groupadd docker 2>/dev/null || true

# 12. Add your current user to the 'docker' group
#     This lets you run 'docker' commands without typing 'sudo'.
sudo usermod -aG docker "$USER"

# 13. Start a new shell session with the updated group memberships
newgrp docker

# 14. Verify that you can run Docker commands without sudo
docker run hello-world

# End of script
