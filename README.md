# Docker Installation Script

This README provides a summary of how the `install-docker.sh` script installs Docker Community Edition (CE) on Ubuntu. It follows the [official Docker documentation](https://docs.docker.com/engine/install/ubuntu/) and includes additional comments for clarity.

## Table of Contents
1. [Overview](#overview)
2. [Pre-requisites](#pre-requisites)
3. [Steps Explained](#steps-explained)
4. [Usage](#usage)
5. [Verification](#verification)
6. [Further Reading](#further-reading)

## Overview

This script ensures any outdated or conflicting Docker packages are removed, then sets up the official Docker repository on your system. It installs Docker CE, Docker Compose, and related plugins. Finally, it verifies the installation and optionally configures your system so you can run Docker commands without using `sudo`.

## Pre-requisites

- An Ubuntu-based system (tested on Ubuntu 22.04, 20.04, etc.).
- Access to an account with `sudo` privileges.

## Steps Explained

1. **Removing Old Packages**  
   ```bash
   for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc
   do
     sudo apt-get remove -y "$pkg"
   done
   ```
   - Removes any conflicting packages like `docker.io` or older versions of `docker-compose`.

2. **Updating Package Index & Installing Dependencies**  
   ```bash
   sudo apt-get update
   sudo apt-get install -y ca-certificates curl
   ```
   - Refreshes package lists.
   - Installs tools needed to manage certificates and make remote requests via HTTPS.

3. **Adding Docker’s Official GPG Key**  
   ```bash
   sudo install -m 0755 -d /etc/apt/keyrings
   sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
   sudo chmod a+r /etc/apt/keyrings/docker.asc
   ```
   - Creates a dedicated directory `/etc/apt/keyrings` with safe permissions (0755).
   - Downloads and saves Docker’s official GPG key.
   - Adjusts permissions to ensure the key is readable by the package manager.

4. **Adding Docker’s Repository**  
   ```bash
   echo \
     "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
     $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
     | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   sudo apt-get update
   ```
   - Dynamically inserts system architecture and Ubuntu release codename into the Docker stable repo.
   - Refreshes package lists again, now including Docker’s repo.

5. **Installing Docker Packages**  
   ```bash
   sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
   ```
   - Installs Docker engine, CLI, containerd, Buildx, and the Compose plugin from Docker’s repository.

6. **Verifying Docker Installation**  
   ```bash
   sudo docker run hello-world
   ```
   - Pulls and runs the `hello-world` Docker image to confirm Docker is functioning properly.

7. **Creating and Configuring the Docker Group**  
   ```bash
   sudo groupadd docker
   sudo usermod -aG docker $USER
   newgrp docker
   docker run hello-world
   ```
   - Creates a user group named `docker` if it doesn’t exist.
   - Adds your current user to the `docker` group so you can run Docker commands without `sudo`.
   - Starts a new shell to load the updated group membership.
   - Confirms the setup by running the `hello-world` container again without sudo.

## Usage

1. Make the script executable (if not already):
   ```bash
   chmod +x install-docker.sh
   ```

2. Run the script:
   ```bash
   ./install-docker.sh
   ```

3. When the script finishes, Docker should be installed, and you should be able to use Docker as a non-root user (after restarting your session or using `newgrp docker`).

## Verification

- After installation, you can check your Docker version:
  ```bash
  docker --version
  ```
- Or run a test container:
  ```bash
  docker run hello-world
  ```

## Further Reading

- [Official Docker Documentation](https://docs.docker.com/engine/install/ubuntu/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

