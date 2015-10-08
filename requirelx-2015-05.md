%title: Introduction to Docker for the Node.js Developer
%author: @lukeb0nd luke@yld.io
%date: 2015-05-19


\                    \_         \_     
    \_ \__   \___   \__| | \___   (\_)\___ 
   | '\_ \\ / \_ \\ / \_` |/ \_ \\  | / \__|
   | | | | (\_) | (\_| |  \__/\_ | \\\__ \\
   |\_| |\_|\\\___/ \\\__,\_|\\\___(\_)/ |\___/
                           |\__/     
                \___   
               ( \_ )  
               / \_ \\/\\
              | (\_>  <
               \\___/\\/
                   
\         \_            \_             
      \__| | \___   \___| | \_____ \_ \__ 
     / \_` |/ \_ \\ / \__| |/ / \_ \\ '\__|
    | (\_| | (\_) | (\__|   <  \__/ |   
     \\__,\_|\\\___/ \\\___|\_|\\\_\\\___|\_|   
                                  


-> # @requirelx / @dockerlisbon <-
-> ## May 2015 <-





-> Luke Bond <-
-> YLD.io <-
-> @lukeb0nd <-

---

## CONTENTS

- What is Docker
- Why Node.js & Docker are a good pair
- Docker Basics
- Build and deploy a Node.js app with Docker

---

## WHAT IS DOCKER

- Docker is Linux Containers...
  - with good UX
  - with a package manager
- What are LXCs?
  - LXCs are like chroots
  - Can limit slice of OS resources allocated to them
  - Isolation b/w containers liks VMs
  - Faster to start than VMs
  - Direct access to OS resources
-  What Docker does isn't new
  - But they nailed the UX for devs
- Docker consists of:
  - A daemon with an API
  - A CLI
  - Extra components (compose, swarm, machine)

---

## WHY NODE.JS & DOCKER ARE A GOOD PAIR

- Docker best-practice recomments one-process-per-container
- Node.js is single-process
- .'. Docker <3 Node.js

---

## DOCKER BASICS

_The Docker Lexicon_

*Images*
A tar file with metadata; the unit of distribution in Docker. Can have metadata such as tags.

*Containers*
An instance of an image; extracted and running as a LXC.

*Layers*
Images are made up of multiple layers which can be shared between images.

*Repository*
Analogous to a Git repository, but for storing an image with its layers, metadata and history.

*Registry*
A service that hosts repositories. If *repositories* are analogous to Git repositories, GitHub is a like a registry.

A *registry* houses multiple repositories.
A *repository* stores one image, and is namespaced by username; e.g. `coreos/etcd` or `lukebond/my-api`.
You *pull* *images* from *repositories* hosted in a *registry*.
You *run* *containers* based on *images*.
There can be many *containers* running the same image (e.g. multiple instances of Redis).

---

## DOCKER BASICS

The *Docker Hub* is Docker's own hosted registory. There are others.

Browse the Docker Hub at [https://hub.docker.com](https://hub.docker.com).

It hosts "official" and user-contributed images. Examples of official repositories are ubuntu, Node.js, MySQL and Redis.

---

**View information about your Docker install**

    $ docker info

**Pull an image from the Docker Hub**

    $ docker pull nginx

**You can pull a specific version (tag)**

    $ docker pull nginx:1.7.7

**View images that have been pulled**

    $ docker images

**Remove a downloaded image**

    $ docker rmi mongo

---

## DOCKER BASICS

**Run a Docker container**

    $ docker run --name nginx-p 8080:80 -d nginx
    $ curl -i localhost

Launches a container based on the **nginx** image, gives it a name, maps the container's port `80` to port `8080` on the host and runs it in the background, giving us back our command-prompt.

**View running Docker containers**

    $ docker ps

**Stop a running Docker container**

    $ docker stop 

**View running and stopped Docker containers**

    $ docker ps -a

**Remove a stopped Docker container**

    $ docker rm nginx

You can also mount volumes, specify environment variables, limit resources and customise the networking setup of the running containers.

---

## THE DOCKERFILE

* A text file that describes how to build a Docker image
* You specify an image to build up, and add files and run commands
* An image can then be built from the Dockerfile
  * And then run or pushed to a repository

An example (adapted from: https://github.com/enokd/docker-node-hello):

    FROM    centos:6.4
    RUN     rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
    RUN     yum install -y npm
    ADD . /src
    RUN cd /src; npm install
    EXPOSE  8080
    CMD ["node", "/src/index.js"]

---

## THE DOCKERFILE

Example (repeated):

    FROM    centos:6.4
    RUN     rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
    RUN     yum install -y npm
    ADD . /src
    RUN cd /src; npm install
    EXPOSE  8080
    CMD ["node", "/src/index.js"]

# Commands

**FROM** Image to base this image off (we'll create layers on top)
**RUN** Execute a shell command
**ADD** Add files from host filesystem to image tar
**EXPOSE** Expose a port from the container
**CMD** The process that will be PID 1 in the container

When the container's PID 1 exists, the container stops.

---

## BUILD PUSH AND RUN A NODE.JS APP WITH DOCKER

Create this Node.js app (app.js):

    var http = require('http');
    http.createServer(function (req, res) {
      res.writeHead(200, {'Content-Type': 'text/plain'});
      res.end('Hello World\n');
    }).listen(8080, '127.0.0.1');
    console.log('Server running at http://127.0.0.1:8080/');

Dockerfile:

    FROM gliderlabs/alpine:3.1
    RUN apk --update add nodejs
    ADD app.js /opt/app/app.js
    RUN cd /opt/app
    EXPOSE 9000
    CMD ["node", "/opt/app/app.js"]

---

## BUILD PUSH AND RUN A NODE.JS APP WITH DOCKER

Build the image:

    $ docker build -t lukebond/hello-world

Push the image to the Docker hub:

    $ docker push lukebond/hello-world

Pull the image on a remote host

    $ ssh core@lisbon-demo    # I added the IP to my /etc/hosts
    $ docker pull lukebond/hello-world
    $ docker run --name=hello-world -p 80:80 -d lukebond/hello-world

Now let's try and cURL it from here:

    $ curl -i lisbon-demo
    Hello World

\\o/

---

## WHAT NEXT?

- Run it properly using the OS's init system (in this case *systemd*)
- Dockerise your own apps and put them on the Docker hub
- Consider some sort of PaaS if you need multi-host networking
- Shameless plug:
  - [http://paz.sh](http://paz.sh)
  - A Docker PaaS written in Node.js, built on CoreOS, Fleet and Etcd
