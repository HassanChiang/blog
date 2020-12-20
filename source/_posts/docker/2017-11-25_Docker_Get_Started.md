---

title: Docker Get Started
date: 2017-11-25
description:
{: id="20201220214147-umf1fpn"}

tags:
{: id="20201220214147-ce441tj"}

- {: id="20201220214147-6ma76lu"}Docker
- {: id="20201220214147-3m7j4d5"}入门
{: id="20201220214147-7eou747"}

nav:
{: id="20201220214147-sifiiwi"}

- {: id="20201220214147-01yrbsz"}工具
{: id="20201220214147-4ez7jao"}

categories:
{: id="20201220214147-kyngybr"}

- {: id="20201220214147-eteyzy6"}Docker
{: id="20201220214147-ayncenp"}

image: images/docker.png
{: id="20201220214147-srhfljh"}

---

**环境**
{: id="20201220214147-maxq4ia"}

Vmware11 安装 Centos 7 系统，版本如下。
{: id="20201220214147-2l2mi9d"}

```
$ uname -s -r 
Linux 3.10.0-229.el7.x86_64
```
{: id="20201220214147-0dvmiim"}

**安装**
{: id="20201220214147-k15x0x8"}

1.使用 root 账户或具有 root 权限的用户登录。
{: id="20201220214147-vjxkl12"}

2.更新安装包。
{: id="20201220214147-vbnect1"}

```
sudo yum update
```
{: id="20201220214147-moiuwds"}

3.给 yum 添加 docker repository。
{: id="20201220214147-1ezrh8f"}

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
{: id="20201220214147-lb4wmwb"}

4.安装 docker 引擎
{: id="20201220214147-ztnlzat"}

```
$ sudo yum install docker-engine
```
{: id="20201220214147-yf1a5wb"}

5. {: id="20201220214147-7njhz4u"}启动 docker 守护进程
{: id="20201220214147-uwzpegg"}

```
sudo service docker start
```
{: id="20201220214147-634td7h"}

6.验证 docker 安装和启动是否正确
{: id="20201220214147-ufroc3x"}

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
{: id="20201220214147-mq0zzly"}

ok，看见以上信息，就说明 docker 已经正确安装并启动。
{: id="20201220214147-ucmj8ik"}

在系统里创建一个 docker 用户组
{: id="20201220214147-u1ppoyp"}

从 0.5.2 开始 docker 的守护进程总是以 root 用户来运行。docker 守护进程绑定的是 Unix 的 socket 而不是一个 TCP 端口。Unix 的 socket 默认属于 root 用户，所以，使用 docker 时必须加上 sudo。
{: id="20201220214147-gr3ghgn"}

从 0.5.3 开始，创建一个名为 docker 组，然后将用户加入这个组内。当 docker 守护进程启动时，它会把 Unix 的读写权限赋予 docker 组。这样，当你作为 docker 组内用户使用 docker 客户端时，你就无须使用 sudo 了。
{: id="20201220214147-u98vr1y"}

需要注意的是，docker 用户组是等价于 root 用户的，进一步了 docker 用户组对系统安全的影响，可以看看这个：走你。
{: id="20201220214147-e2dclhm"}

执行:
{: id="20201220214147-0ms8suo"}

```
sudo usermod -aG docker your_username
```
{: id="20201220214147-0mjpeaj"}

执行完后，退出 shell，再重新登录，以确保用户获得正确的运行权限。
{: id="20201220214147-fk91re9"}

重新登录系统后，执行：
{: id="20201220214147-rfqlvsx"}

```
docker run hello-world
```
{: id="20201220214147-2j5o4yd"}

执行结果应该同 “安装” 部分第六步的执行结果一样。
{: id="20201220214147-ouqwkqx"}

设置 docker 守护进程开机启动
{: id="20201220214147-9z2z1bp"}

```
$ sudo chkconfig docker on
```
{: id="20201220214147-1jml1ci"}

运行一下官方教程提供的镜像
{: id="20201220214147-tyzc0tr"}

执行：
{: id="20201220214147-65xapyh"}

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
{: id="20201220214147-cgvsfjv"}

第一次执行的时候，会从 Docker Hub 上下载该镜像。镜像还挺大的，有 247MB，如果网速不快的，需要耐心等待。
{: id="20201220214147-cpjlgoy"}

Docker 的镜像（images）和容器（containers）
{: id="20201220214147-sp6l3v5"}

首先，看一下下面这个图例:
{: id="20201220214147-220p41a"}

执行以上命令，docker 引擎会做这几件事：
{: id="20201220214147-xnc6475"}

1. {: id="20201220214147-qql7b2v"}检查本地是否有 hello-world 镜像
2. {: id="20201220214147-t0t1ynf"}如果没有则从 Docker Hub 下载该镜像，如果有，则使用本地镜像
3. {: id="20201220214147-ken1mcc"}把 hello-world 镜像加载到容器里，并执行。
{: id="20201220214147-p2nw01k"}

Docker 镜像可以是一个简单的命令行，执行完后就退出了。也可以是一个复杂的程序集合，比如一个数据库，启动后，可以进行复杂的数据库操作。
{: id="20201220214147-09rzsox"}

Docker 的镜像是只读的，可以理解为是一个软件。Docker 镜像通过镜像 ID 进行识别。镜像 ID 是一个 64 字符的十六进制的字符串。通常我们不会使用镜像 ID 来引用镜像，而是使用镜像名来引用。
{: id="20201220214147-cfacfem"}

查看本地镜像：
{: id="20201220214147-u87tyt1"}

```
$ docker images
REPOSITORY              TAG                 IMAGE ID            CREATED             SIZE
docker-whale            latest              03643993f0ca        7 minutes ago       255.6 MB
hello-world             latest              690ed74de00f        4 months ago        960 B
docker/whalesay         latest              6b362a9f73eb        8 months ago        247 MB
```
{: id="20201220214147-gqu0ifh"}

这里的 Image ID 只有前 12 个字符，想要显示全部，需要添加选项：–no-trunc。
{: id="20201220214147-dzmm1yh"}

```
$ docker images --no-trunc
REPOSITORY              TAG                 IMAGE ID                                                                  CREATED             SIZE
docker-whale            latest              sha256:03643993f0cacd07968d99265815543a0f2d296e4fc434253b2b4ac2e2c84aae   About an hour ago   255.6 MB
hello-world             latest              sha256:690ed74de00f99a7d00a98a5ad855ac4febd66412be132438f9b8dbd300a937d   4 months ago        960 B
docker/whalesay         latest              sha256:6b362a9f73eb8c33b48c95f4fcce1b6637fc25646728cf7fb0679b2da273c3f4   8 months ago        247 MB
```
{: id="20201220214147-zx4ryjd"}

容器就是运行镜像的地方。当执行 docker run 的时候，就会启动一个容器，而 docker run hello-world 便会把 hello-world 这个程序加载到这个容器里面运行。每个容器相互独立，我们可以使用同一个镜像启动多个容器（多个虚拟环境），我们对其中一个容器所做的变更只会局限于那个容器本身，对容器的变更是写入到容器的文件系统的，而不是写入到 Docker 镜像中的。
{: id="20201220214147-vdqf6vv"}

容器之间可以通过暴露端口进行通信，这个在以后学习中再说。
{: id="20201220214147-vauurbp"}

Docker 使用 64 字符的十六进制的字符串来定义容器 ID，它是容器的唯一标识符。容器之间的交互是依靠容器 ID 识别的，由于容器 ID 的字符太长，我们通常只需键入容器 ID 的前 4 个字符即可。当然，我们还可以使用容器名，但显然用 4 字符的容器 ID 更为简便。
{: id="20201220214147-9talz5y"}

查看当前运行的容器可以使用命令：
{: id="20201220214147-vo7xnqz"}

```
$ docker ps
CONTAINER ID        IMAGE                    COMMAND                  CREATED             STATUS              PORTS                     NAMES
a45a2d3b95e7        sample-spring-boot-app   "/bin/sh -c 'java -DC"   3 seconds ago       Up 2 seconds        0.0.0.0:8080->8080/tcp    silly_morse
0b2494881e6c        sample-spring-boot-app   "/bin/sh -c 'java -DC"   3 minutes ago       Up 3 minutes        0.0.0.0:32771->8080/tcp   compassionate_austin
```
{: id="20201220214147-u74opwo"}

简单的理解，可以把 “镜像 - 容器” 理解为 “类 - 实例”。容器是一个实例，这个实例是根据镜像创建的。
{: id="20201220214147-dvbntkp"}


{: id="20201220214147-g9untlw" type="doc"}
