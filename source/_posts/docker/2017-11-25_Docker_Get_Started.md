----
title: Docker Get Started
date: 2017-11-25
description: 

tags:
- Docker
- 入门

nav:
- 工具

categories:
- Docker

image: images/docker.png

----

**环境**

Vmware11 安装 Centos 7 系统，版本如下。
```
$ uname -s -r 
Linux 3.10.0-229.el7.x86_64
```
**安装**

1.使用 root 账户或具有 root 权限的用户登录。

2.更新安装包。

```
sudo yum update
```
3.给 yum 添加 docker repository。
```
$ sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
```
4.安装 docker 引擎
```
$ sudo yum install docker-engine
```
5. 启动 docker 守护进程
```
sudo service docker start
```
6.验证 docker 安装和启动是否正确
```
$ sudo docker run hello-world
Unable to find image 'hello-world:latest' locally
    latest: Pulling from hello-world
    a8219747be10: Pull complete
    91c95931e552: Already exists
    hello-world:latest: The image you are pulling has been verified. Important: image verification is a tech preview feature and should not be relied on to provide security.
    Digest: sha256:aa03e5d0d5553b4c3473e89c8619cf79df368babd1.7.1cf5daeb82aab55838d
    Status: Downloaded newer image for hello-world:latest
    Hello from Docker.
    This message shows that your installation appears to be working correctly.
    To generate this message, Docker took the following steps:
     1. The Docker client contacted the Docker daemon.
     2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
            (Assuming it was not already locally available.)
     3. The Docker daemon created a new container from that image which runs the
            executable that produces the output you are currently reading.
     4. The Docker daemon streamed that output to the Docker client, which sent it
            to your terminal.
    To try something more ambitious, you can run an Ubuntu container with:
     $ docker run -it ubuntu bash
    For more examples and ideas, visit:
     http://docs.docker.com/userguide/
```
ok，看见以上信息，就说明 docker 已经正确安装并启动。

在系统里创建一个 docker 用户组

从 0.5.2 开始 docker 的守护进程总是以 root 用户来运行。docker 守护进程绑定的是 Unix 的 socket 而不是一个 TCP 端口。Unix 的 socket 默认属于 root 用户，所以，使用 docker 时必须加上 sudo。

从 0.5.3 开始，创建一个名为 docker 组，然后将用户加入这个组内。当 docker 守护进程启动时，它会把 Unix 的读写权限赋予 docker 组。这样，当你作为 docker 组内用户使用 docker 客户端时，你就无须使用 sudo 了。

需要注意的是，docker 用户组是等价于 root 用户的，进一步了 docker 用户组对系统安全的影响，可以看看这个：走你。

执行:
```
sudo usermod -aG docker your_username
```
执行完后，退出 shell，再重新登录，以确保用户获得正确的运行权限。

重新登录系统后，执行：
```
docker run hello-world
```
执行结果应该同 “安装” 部分第六步的执行结果一样。

设置 docker 守护进程开机启动
```
$ sudo chkconfig docker on
```
运行一下官方教程提供的镜像

执行：
```
$ docker run docker/whalesay cowsay boo
Unable to find image 'docker/whalesay:latest' locally
latest: Pulling from docker/whalesay
e9e06b06e14c: Pull complete
a82efea989f9: Pull complete
37bea4ee0c81: Pull complete
07f8e8c5e660: Pull complete
676c4a1897e6: Pull complete
5b74edbcaa5b: Pull complete
1722f41ddcb5: Pull complete
99da72cfe067: Pull complete
5d5bd9951e26: Pull complete
fb434121fc77: Already exists
Digest: sha256:d6ee73f978a366cf97974115abe9c4099ed59c6f75c23d03c64446bb9cd49163
Status: Downloaded newer image for docker/whalesay:latest
 _____
< boo >
 -----
    \
     \
      \
                    ##        .
              ## ## ##       ==
           ## ## ## ##      ===
       /""""""""""""""""___/ ===
  ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~
       \______ o          __/
        \    \        __/
          \____\______/
```
第一次执行的时候，会从 Docker Hub 上下载该镜像。镜像还挺大的，有 247MB，如果网速不快的，需要耐心等待。

Docker 的镜像（images）和容器（containers）

首先，看一下下面这个图例:



执行以上命令，docker 引擎会做这几件事：
1. 检查本地是否有 hello-world 镜像
2. 如果没有则从 Docker Hub 下载该镜像，如果有，则使用本地镜像
3. 把 hello-world 镜像加载到容器里，并执行。

Docker 镜像可以是一个简单的命令行，执行完后就退出了。也可以是一个复杂的程序集合，比如一个数据库，启动后，可以进行复杂的数据库操作。

Docker 的镜像是只读的，可以理解为是一个软件。Docker 镜像通过镜像 ID 进行识别。镜像 ID 是一个 64 字符的十六进制的字符串。通常我们不会使用镜像 ID 来引用镜像，而是使用镜像名来引用。

查看本地镜像：
```
$ docker images
REPOSITORY              TAG                 IMAGE ID            CREATED             SIZE
docker-whale            latest              03643993f0ca        7 minutes ago       255.6 MB
hello-world             latest              690ed74de00f        4 months ago        960 B
docker/whalesay         latest              6b362a9f73eb        8 months ago        247 MB
```
这里的 Image ID 只有前 12 个字符，想要显示全部，需要添加选项：–no-trunc。
```
$ docker images --no-trunc
REPOSITORY              TAG                 IMAGE ID                                                                  CREATED             SIZE
docker-whale            latest              sha256:03643993f0cacd07968d99265815543a0f2d296e4fc434253b2b4ac2e2c84aae   About an hour ago   255.6 MB
hello-world             latest              sha256:690ed74de00f99a7d00a98a5ad855ac4febd66412be132438f9b8dbd300a937d   4 months ago        960 B
docker/whalesay         latest              sha256:6b362a9f73eb8c33b48c95f4fcce1b6637fc25646728cf7fb0679b2da273c3f4   8 months ago        247 MB
```

容器就是运行镜像的地方。当执行 docker run 的时候，就会启动一个容器，而 docker run hello-world 便会把 hello-world 这个程序加载到这个容器里面运行。每个容器相互独立，我们可以使用同一个镜像启动多个容器（多个虚拟环境），我们对其中一个容器所做的变更只会局限于那个容器本身，对容器的变更是写入到容器的文件系统的，而不是写入到 Docker 镜像中的。

容器之间可以通过暴露端口进行通信，这个在以后学习中再说。

Docker 使用 64 字符的十六进制的字符串来定义容器 ID，它是容器的唯一标识符。容器之间的交互是依靠容器 ID 识别的，由于容器 ID 的字符太长，我们通常只需键入容器 ID 的前 4 个字符即可。当然，我们还可以使用容器名，但显然用 4 字符的容器 ID 更为简便。

查看当前运行的容器可以使用命令：
```
$ docker ps
CONTAINER ID        IMAGE                    COMMAND                  CREATED             STATUS              PORTS                     NAMES
a45a2d3b95e7        sample-spring-boot-app   "/bin/sh -c 'java -DC"   3 seconds ago       Up 2 seconds        0.0.0.0:8080->8080/tcp    silly_morse
0b2494881e6c        sample-spring-boot-app   "/bin/sh -c 'java -DC"   3 minutes ago       Up 3 minutes        0.0.0.0:32771->8080/tcp   compassionate_austin
```

简单的理解，可以把 “镜像 - 容器” 理解为 “类 - 实例”。容器是一个实例，这个实例是根据镜像创建的。