FROM ghcr.io/coder/code-server:latest

# Switch to root
USER root

# Base deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl unzip ca-certificates gnupg lsb-release software-properties-common apt-transport-https \
 && rm -rf /var/lib/apt/lists/*

# ---------- Terraform ----------
RUN install -m 0755 -d /etc/apt/keyrings \
 && wget -qO- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /etc/apt/keyrings/hashicorp.gpg \
 && chmod a+r /etc/apt/keyrings/hashicorp.gpg \
 && . /etc/os-release \
 && echo "deb [signed-by=/etc/apt/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com ${VERSION_CODENAME} main" \
    > /etc/apt/sources.list.d/hashicorp.list \
 && apt-get update && apt-get install -y terraform \
 && rm -rf /var/lib/apt/lists/*

# ---------- AWS CLI v2 ----------
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" \
 && unzip /tmp/awscliv2.zip -d /tmp \
 && /tmp/aws/install \
 && rm -rf /tmp/aws /tmp/awscliv2.zip

# ---------- Azure CLI ----------
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# ---------- Google Cloud SDK (gcloud) ----------
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
     | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
 && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
 && apt-get update && apt-get install -y google-cloud-cli \
 && rm -rf /var/lib/apt/lists/*

# ---------- kubectl ----------
RUN curl -fsSLo /usr/local/bin/kubectl https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl \
 && chmod +x /usr/local/bin/kubectl

# ---------- OpenShift CLI (oc) ----------
RUN curl -fsSL https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz -o /tmp/oc.tar.gz \
 && tar -xzf /tmp/oc.tar.gz -C /usr/local/bin \
 && chmod +x /usr/local/bin/oc \
 && rm -rf /tmp/oc.tar.gz

# Switch back to unprivileged user
USER coder

