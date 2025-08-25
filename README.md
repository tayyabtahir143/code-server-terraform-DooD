# Code-Server + Terraform + Multi-Cloud + Kubernetes

This project provides VS Code in the browser using code-server with Terraform, AWS CLI, Azure CLI, Google Cloud SDK (gcloud), Kubernetes CLI (kubectl), and OpenShift CLI (oc) preinstalled. Docker CLI access is also available inside the environment by mounting the host socket. You only need Docker and Docker Compose installed on your host machine.

To use it, make sure Docker and Docker Compose are installed on your host and verify with:

```bash 
docker --version
docker compose version
```


Clone this repository:

```bash
git clone https://github.com/tayyabtahir143/code-server-terraform-DooD.git

cd code-server-terraform
```

Edit `docker-compose.yaml` and set a strong password by replacing `PASSWORD=change-me` with your own.

Start the container:

```bash
docker compose up -d --build
```

Open your browser at https://localhost:8443 and log in with your password.

Inside the VS Code terminal you can check tools:
- `terraform -version` → verify Terraform
- `aws --version` → AWS CLI
- `az --version` → Azure CLI
- `gcloud --version` → Google Cloud SDK
- `kubectl version --client` → Kubernetes CLI
- `oc version` → OpenShift CLI

All these tools are baked into the container and ready to use.

If you want Docker commands inside VS Code, the host socket is mounted. Because the code-server user is not root, you must prefix Docker commands with `sudo`:
`sudo docker ps`
`sudo docker build .`
`sudo docker compose up`

If you want to avoid typing sudo each time, you can adjust user/group mappings or give the container user Docker group membership, but by default `sudo` is required for safety.

To manage the container itself:
- Stop: `docker compose down`
- Restart: `docker compose restart`
- Logs: `docker compose logs -f`

Cleanup everything including images and volumes:
```bash	
docker compose down -v --rmi all
```

If running on Rocky Linux, AlmaLinux, or Fedora with SELinux enabled, fix permissions on bind mounts so code-server can write to them:

For security always set a strong password, use HTTPS via a reverse proxy if exposing remotely, and never commit secrets, `.tfstate`, or `.env` files (add them to `.gitignore`).


If you are running on Rocky Linux, AlmaLinux, or Fedora with SELinux enabled, fix the context for bind mounts so the container can write to them:

```bash
sudo dnf -y install policycoreutils-python-utils
sudo semanage fcontext -a -t container_file_t "$(pwd)/data(/.*)?"
sudo semanage fcontext -a -t container_file_t "$(pwd)/projects(/.*)?"
sudo restorecon -Rv ./data ./projects
```

License: MIT, free to use, modify, and distribute.

