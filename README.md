# Code-Server + Terraform (Dev Environment in Docker)

This project gives you VS Code in the browser using code-server with Terraform preinstalled, and optional Docker access inside the environment. You only need Docker and Docker Compose installed on your host machine.  

To use it, first make sure Docker and Docker Compose are installed on the host and check with:  
`docker --version` and `docker compose version`.  

Clone this repository:  
`git clone https://github.com/YOUR-USERNAME/code-server-terraform.git`  
`cd code-server-terraform`  

Edit `docker-compose.yaml` and set a strong password by replacing `PASSWORD=change-me` with your own.  

Start the container:  
`docker compose up -d --build`  

Open your browser at https://localhost:8443 and log in with your password.  

Inside the VS Code terminal verify Terraform with:  
`terraform -version`  
then start projects with:  
`mkdir my-terraform && cd my-terraform && terraform init && terraform plan && terraform apply`  

If you want Docker access inside code-server, add to volumes in `docker-compose.yaml`:  
`/var/run/docker.sock:/var/run/docker.sock`  
`/usr/bin/docker:/usr/bin/docker:ro`  
Restart with `docker compose up -d` and test inside the terminal with `docker ps`.  

Manage the container with:  
- Stop: `docker compose down`  
- Restart: `docker compose restart`  
- Logs: `docker compose logs -f`  

Cleanup everything with:  
`docker compose down -v --rmi all`  

For security always set a strong password, use HTTPS via a reverse proxy if exposing remotely, and never commit secrets, `.tfstate`, or `.env` files (add them to `.gitignore`).


If you are running on Rocky Linux, AlmaLinux, or Fedora with SELinux enabled, fix the context for bind mounts so the container can write to them:

```bash
sudo dnf -y install policycoreutils-python-utils
sudo semanage fcontext -a -t container_file_t "$(pwd)/data(/.*)?"
sudo semanage fcontext -a -t container_file_t "$(pwd)/projects(/.*)?"
sudo restorecon -Rv ./data ./projects
```

License: MIT, free to use, modify, and distribute.

