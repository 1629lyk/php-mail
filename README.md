# PHP Mail System with System User Creation in Docker

This project sets up a **PHP-based web interface** that:

* Creates **system users** inside a Docker container
* Sends a **welcome email** using `Postfix` and `Mailutils`
* Stores user mail in **Maildir format**

---

## Folder Structure

```
.
├── Dockerfile
├── docker-entrypoint.sh
├── index.php
├── create_user.php
├── adduser_web.sh
```

---

## Features

* Apache2 + PHP 8.x frontend
* Postfix for local mail delivery
* `mkpasswd` (SHA-512) to hash passwords
* `sudo` rules configured so PHP can create system users
* Emails stored in Maildir for each user

---

## Getting Started

### 1. Build the Docker Image

```bash
sudo docker build -t php-mail .
```

### 2. Run the Container

```bash
sudo docker run -p 8080:80 --name php-mail-frontend --privileged php-mail
```

* The `--privileged` flag is required to create system users inside the container.
* The container will run Apache and Postfix.

---

## Access the Web Interface

Open your browser and go to:

```
http://localhost:8080
```

* Fill in the **username** and **password** form.
* This will create a system user and send a welcome mail to `<username>@localhost`.

---

## Check User Mail

```bash
sudo docker exec -it php-mail-frontend bash
su - <username>
cat Maildir/new/*
```

Example:

```bash
su - alice
cat Maildir/new/*
```

---

## Password Security

* Passwords are **hashed** using SHA-512 via `mkpasswd` before user creation.
* They are never stored in plaintext.

---

## Common Docker Commands

| Purpose                                | Command                                                                |
| -------------------------------------- | ---------------------------------------------------------------------- |
| Build the image                        | `docker build -t php-mail .`                                           |
| Run container                          | `docker run -p 8080:80 --name php-mail-frontend --privileged php-mail` |
| Exec into container                    | `docker exec -it php-mail-frontend bash`                               |
| Restart existing container             | `docker start -ai php-mail-frontend`                                   |
| Stop container                         | `docker stop php-mail-frontend`                                        |
| Remove stopped container               | `docker rm php-mail-frontend`                                          |
| See all containers (including stopped) | `docker ps -a`                                                         |
| List running containers                | `docker ps`                                                            |
| Delete all stopped containers          | `docker container prune`                                               |

---

## Cleanup

To completely remove everything:

```bash
sudo docker stop php-mail-frontend
sudo docker rm php-mail-frontend
sudo docker rmi php-mail
```

---

## Notes

* Default Apache welcome page is removed at container start (`rm /var/www/html/index.html`)
* PHP scripts are mounted inside `/var/www/html/`
* All system users and their Maildir folders are confined inside the container

---