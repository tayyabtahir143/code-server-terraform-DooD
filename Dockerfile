# Dockerfile
FROM ghcr.io/coder/code-server:latest

# Switch to root for package install
USER root

# Install Terraform the modern way (keyring) and keep the image slim
RUN apt-get update && apt-get install -y --no-install-recommends wget gpg ca-certificates \
 && install -m 0755 -d /etc/apt/keyrings \
 && wget -qO- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /etc/apt/keyrings/hashicorp.gpg \
 && chmod a+r /etc/apt/keyrings/hashicorp.gpg \
 && . /etc/os-release \
 && echo "deb [signed-by=/etc/apt/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com ${VERSION_CODENAME} main" \
    > /etc/apt/sources.list.d/hashicorp.list \
 && apt-get update && apt-get install -y --no-install-recommends terraform \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Back to the unprivileged user
USER coder

