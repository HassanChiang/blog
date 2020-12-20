---

title: 从零开始搭建Prometheus自动监控报警系统（企业级）
date: 2017-12-09
description:
{: id="20201220214147-kt0r0iw"}

tags:
{: id="20201220214147-7tr5jlo"}

- {: id="20201220214147-eb7t49s"}监控
- {: id="20201220214147-e5t28mx"}报警
- {: id="20201220214147-cz1xyog"}Prometheus
{: id="20201220214147-vwagqev"}

nav:
{: id="20201220214147-zo2p6qf"}

- {: id="20201220214147-mm5ryic"}工具
{: id="20201220214147-qjh9gu4"}

categories:
{: id="20201220214147-5sgrssy"}

- {: id="20201220214147-20y9yi2"}监控
{: id="20201220214147-30jazu4"}

image: images/grafana.png
{: id="20201220214147-ebeoika"}

---

## 什么是Prometheus?
{: id="20201220214147-heep4oc"}

Prometheus是由SoundCloud开发的开源监控报警系统和时序列数据库(TSDB)。Prometheus使用Go语言开发，是Google BorgMon监控系统的开源版本。
{: id="20201220214147-cu5sfwh"}

2016年由Google发起Linux基金会旗下的原生云基金会(Cloud Native Computing Foundation), 将Prometheus纳入其下第二大开源项目。
{: id="20201220214147-0q2f7v7"}

Prometheus目前在开源社区相当活跃。
{: id="20201220214147-u0inpmq"}

Prometheus和Heapster(Heapster是K8S的一个子项目，用于获取集群的性能数据。)相比功能更完善、更全面。Prometheus性能也足够支撑上万台规模的集群。
{: id="20201220214147-mawkur4"}

## Prometheus的特点
{: id="20201220214147-ha1xskz"}

- {: id="20201220214147-bcu6urd"}多维度数据模型。
- {: id="20201220214147-rj9c4ui"}灵活的查询语言。
- {: id="20201220214147-a4u3va7"}不依赖分布式存储，单个服务器节点是自主的。
- {: id="20201220214147-ytxvq2g"}通过基于HTTP的pull方式采集时序数据。
- {: id="20201220214147-warwbgo"}可以通过中间网关进行时序列数据推送。
- {: id="20201220214147-t04sj5n"}通过服务发现或者静态配置来发现目标服务对象。
- {: id="20201220214147-lz7t3p3"}支持多种多样的图表和界面展示，比如Grafana等。
{: id="20201220214147-skiyp3y"}

官网地址：https://prometheus.io/
{: id="20201220214147-idu4vii"}

## 架构图
{: id="20201220214147-hs4w08u"}

![](./2017-12-10_从零开始搭建Prometheus自动监控报警系统/1.png)
{: id="20201220214147-yf9jab0"}

![](./2017-12-10_从零开始搭建Prometheus自动监控报警系统/2.png)
{: id="20201220214147-qij15ph"}

## 基本原理
{: id="20201220214147-h2tg7xp"}

Prometheus的基本原理是通过HTTP协议周期性抓取被监控组件的状态，任意组件只要提供对应的HTTP接口就可以接入监控。不需要任何SDK或者其他的集成过程。这样做非常适合做虚拟化环境监控系统，比如VM、Docker、Kubernetes等。输出被监控组件信息的HTTP接口被叫做exporter 。目前互联网公司常用的组件大部分都有exporter可以直接使用，比如Varnish、Haproxy、Nginx、MySQL、Linux系统信息(包括磁盘、内存、CPU、网络等等)。
{: id="20201220214147-ytwhsgj"}

## 服务过程
{: id="20201220214147-xvtcgf7"}

- {: id="20201220214147-03hgee8"}Prometheus Daemon负责定时去目标上抓取metrics(指标)数据，每个抓取目标需要暴露一个http服务的接口给它定时抓取。Prometheus支持通过配置文件、文本文件、Zookeeper、Consul、DNS SRV Lookup等方式指定抓取目标。Prometheus采用PULL的方式进行监控，即服务器可以直接通过目标PULL数据或者间接地通过中间网关来Push数据。
- {: id="20201220214147-kv4puxi"}Prometheus在本地存储抓取的所有数据，并通过一定规则进行清理和整理数据，并把得到的结果存储到新的时间序列中。
- {: id="20201220214147-qudp27e"}Prometheus通过PromQL和其他API可视化地展示收集的数据。Prometheus支持很多方式的图表可视化，例如Grafana、自带的Promdash以及自身提供的模版引擎等等。Prometheus还提供HTTP API的查询方式，自定义所需要的输出。
- {: id="20201220214147-alpvm6g"}PushGateway支持Client主动推送metrics到PushGateway，而Prometheus只是定时去Gateway上抓取数据。
- {: id="20201220214147-fi123ii"}Alertmanager是独立于Prometheus的一个组件，可以支持Prometheus的查询语句，提供十分灵活的报警方式。
{: id="20201220214147-y1vjsal"}

## 三大套件
{: id="20201220214147-z1k4mas"}

- {: id="20201220214147-9eihhpd"}Server 主要负责数据采集和存储，提供PromQL查询语言的支持。
- {: id="20201220214147-tom8zve"}Alertmanager 警告管理器，用来进行报警。
- {: id="20201220214147-zpbhu1i"}Push Gateway 支持临时性Job主动推送指标的中间网关。
{: id="20201220214147-kucqgae"}

## 本飞猪教程内容简介
{: id="20201220214147-gcar2w8"}

- {: id="20201220214147-7y2hqqv"}1.演示安装Prometheus Server
- {: id="20201220214147-tdykm8z"}2.演示通过golang和node-exporter提供metrics接口
- {: id="20201220214147-njsuvxu"}3.演示pushgateway的使用
- {: id="20201220214147-iebjsp5"}4.演示grafana的使用
- {: id="20201220214147-fkf01p4"}5.演示alertmanager的使用
{: id="20201220214147-w2djyqt"}

## 安装准备
{: id="20201220214147-8ao48al"}

这里我的IP是10.211.55.25，登入，建立相应文件夹
{: id="20201220214147-9bgrdd7"}

```
mkdir -p /home/chenqionghe/promethues
mkdir -p /home/chenqionghe/promethues/server
mkdir -p /home/chenqionghe/promethues/client
touch /home/chenqionghe/promethues/server/rules.yml
chmod 777 /home/chenqionghe/promethues/server/rules.yml
```
{: id="20201220214147-k2w0rw5"}

下面开始三大套件的学习
{: id="20201220214147-jwyvfhs"}

# 一.安装Prometheus Server
{: id="20201220214147-jeexju1"}

通过docker方式
{: id="20201220214147-i61x95m"}

首先创建一个配置文件/home/chenqionghe/test/prometheus/prometheus.yml
{: id="20201220214147-r9k6y83"}

挂载之前需要改变文件权限为777，要不会引起修改宿主机上的文件 会引起内容不同步的问题
{: id="20201220214147-c6j0bfn"}

```
global:
  scrape_interval:     15s # 默认抓取间隔, 15秒向目标抓取一次数据。
  external_labels:
    monitor: 'codelab-monitor'
# 这里表示抓取对象的配置
scrape_configs:
    #这个配置是表示在这个配置内的时间序例，每一条都会自动添加上这个{job_name:"prometheus"}的标签  - job_name: 'prometheus'
    scrape_interval: 5s # 重写了全局抓取间隔时间，由15秒重写成5秒
    static_configs:
      - targets: ['localhost:9090']
```
{: id="20201220214147-8pe5ypt"}

```
docker rm -f prometheus
docker run --name=prometheus -d \
-p 9090:9090 \
-v /home/chenqionghe/promethues/server/prometheus.yml:/etc/prometheus/prometheus.yml \
-v /home/chenqionghe/promethues/server/rules.yml:/etc/prometheus/rules.yml \
prom/prometheus:v2.7.2 \
--config.file=/etc/prometheus/prometheus.yml \
--web.enable-lifecycle
```
{: id="20201220214147-t1j76ac"}

启动时加上--web.enable-lifecycle启用远程热加载配置文件
{: id="20201220214147-bv1jjdq"}

调用指令是curl -X POST http://localhost:9090/-/reload
{: id="20201220214147-sdld9x8"}

访问http://10.211.55.25:9090
{: id="20201220214147-3uh5q8l"}

我们会看到如下l界面
{: id="20201220214147-lde5teu"}

![](./2017-12-10_从零开始搭建Prometheus自动监控报警系统/3.png)
{: id="20201220214147-gvez32y"}

访问http://10.211.55.25:9090/metrics
{: id="20201220214147-4p5ez82"}

![](./2017-12-10_从零开始搭建Prometheus自动监控报警系统/4.png)
{: id="20201220214147-1enfn2l"}

我们配置了9090端口，默认prometheus会抓取自己的/metrics接口
{: id="20201220214147-ubgtucw"}

在Graph选项已经可以看到监控的数据
{: id="20201220214147-0vzv30y"}

![](./2017-12-10_从零开始搭建Prometheus自动监控报警系统/5.png)
{: id="20201220214147-vuvtmei"}

# 二.安装客户端提供metrics接口
{: id="20201220214147-642nxd7"}

## 1.通过golang客户端提供metrics
{: id="20201220214147-6aefozw"}

```
mkdir -p /home/chenqionghe/promethues/client/golang/src
cd !$
export GOPATH=/home/chenqionghe/promethues/client/golang/
#克隆项目
git clone https://github.com/prometheus/client_golang.git
#安装需要FQ的第三方包
mkdir -p $GOPATH/src/golang.org/x/
cd !$
git clone https://github.com/golang/net.git
git clone https://github.com/golang/sys.git
git clone https://github.com/golang/tools.git
#安装必要软件包
go get -u -v github.com/prometheus/client_golang/prometheus
#编译
cd $GOPATH/src/client_golang/examples/random
go build -o random main.go
```
{: id="20201220214147-3jo5bfn"}

运行3个示例metrics接口
{: id="20201220214147-hmtlbxy"}

```
./random -listen-address=:8080 &
./random -listen-address=:8081 &
./random -listen-address=:8082 &
```
{: id="20201220214147-w4dzd0p"}

## 2.通过node exporter提供metrics
{: id="20201220214147-tozkom6"}

```
docker run -d \
--name=node-exporter \
-p 9100:9100 \
prom/node-exporter
```
{: id="20201220214147-dwgnfl0"}

然后把这两些接口再次配置到prometheus.yml, 重新载入配置curl -X POST http://localhost:9090/-/reload
{: id="20201220214147-zdbwut0"}

```
global:
  scrape_interval:     15s # 默认抓取间隔, 15秒向目标抓取一次数据。
  external_labels:
    monitor: 'codelab-monitor'
rule_files:
  #- 'prometheus.rules'
# 这里表示抓取对象的配置
scrape_configs:
  #这个配置是表示在这个配置内的时间序例，每一条都会自动添加上这个{job_name:"prometheus"}的标签  - job_name: 'prometheus'
  - job_name: 'prometheus'
    scrape_interval: 5s # 重写了全局抓取间隔时间，由15秒重写成5秒
    static_configs:
      - targets: ['localhost:9090']
      - targets: ['http://10.211.55.25:8080', 'http://10.211.55.25:8081','http://10.211.55.25:8082']
        labels:
          group: 'client-golang'
      - targets: ['http://10.211.55.25:9100']
        labels:
          group: 'client-node-exporter'

```
{: id="20201220214147-9jvuntr"}

可以看到接口都生效了
{: id="20201220214147-mi1zs6t"}

prometheus还提供了各种exporter工具，感兴趣小伙伴可以去研究一下
{: id="20201220214147-9xnr2c8"}

# 三.安装pushgateway
{: id="20201220214147-p4c0v3s"}

pushgateway是为了允许临时作业和批处理作业向普罗米修斯公开他们的指标。
{: id="20201220214147-bsdsk19"}

由于这类作业的存在时间可能不够长, 无法抓取到, 因此它们可以将指标推送到推网关中。
{: id="20201220214147-8a04tgm"}

Prometheus采集数据是用的pull也就是拉模型，这从我们刚才设置的5秒参数就能看出来。但是有些数据并不适合采用这样的方式，对这样的数据可以使用Push Gateway服务。
{: id="20201220214147-qkh4khv"}

它就相当于一个缓存，当数据采集完成之后，就上传到这里，由Prometheus稍后再pull过来。
{: id="20201220214147-za58ply"}

我们来试一下，首先启动Push Gateway
{: id="20201220214147-lf1mpih"}

```
mkdir -p /home/chenqionghe/promethues/pushgateway
cd !$
docker run -d -p 9091:9091 --name pushgateway prom/pushgateway
```
{: id="20201220214147-zlr4et6"}

访问http://10.211.55.25:9091 已经pushgateway运行起来了
{: id="20201220214147-ckp0ktf"}

![](./2017-12-10_从零开始搭建Prometheus自动监控报警系统/6.png)
{: id="20201220214147-s3mhcca"}

接下来我们就可以往pushgateway推送数据了，prometheus提供了多种语言的sdk，最简单的方式就是通过shell
{: id="20201220214147-0e4m0j1"}

- {: id="20201220214147-6b5wqu5"}推送一个指标
{: id="20201220214147-dy8wwtv"}

```
echo "cqh_metric 3.14" | curl --data-binary @- http://ubuntu-linux:9091/metrics/job/cqh
```
{: id="20201220214147-uv351pk"}

- {: id="20201220214147-haq7tg9"}推送多个指标
{: id="20201220214147-440weyd"}

```
cat <<EOF | curl --data-binary @- http://10.211.55.25:9091/metrics/job/cqh/instance/test
# 锻炼场所价格
muscle_metric{label="gym"} 8800
# 三大项数据 kg
bench_press 100
dead_lift 160
deep_squal 160
EOF
```
{: id="20201220214147-1ln8jzp"}

然后我们再将pushgateway配置到prometheus.yml里边,重载配置
{: id="20201220214147-t4ngzcx"}

看到已经可以搜索出刚刚推送的指标了
{: id="20201220214147-xhtl9dc"}

![](./2017-12-10_从零开始搭建Prometheus自动监控报警系统/7.png)
{: id="20201220214147-ndn6r4m"}

# 四.安装Grafana展示
{: id="20201220214147-kjjf6iy"}

Grafana是用于可视化大型测量数据的开源程序，它提供了强大和优雅的方式去创建、共享、浏览数据。
{: id="20201220214147-r7dx711"}

Dashboard中显示了你不同metric数据源中的数据。
{: id="20201220214147-83fn4la"}

Grafana最常用于因特网基础设施和应用分析，但在其他领域也有用到，比如：工业传感器、家庭自动化、过程控制等等。
{: id="20201220214147-oyd9sk8"}

Grafana支持热插拔控制面板和可扩展的数据源，目前已经支持Graphite、InfluxDB、OpenTSDB、Elasticsearch、Prometheus等。
{: id="20201220214147-cdl8oq5"}

我们使用docker安装
{: id="20201220214147-lbncrka"}

```
docker run -d -p 3000:3000 --name grafana grafana/grafana
```
{: id="20201220214147-atreitr"}

默认登录账户和密码都是admin，进入后界面如下
{: id="20201220214147-1pkb0oy"}

![](./2017-12-10_从零开始搭建Prometheus自动监控报警系统/8.png)
{: id="20201220214147-jgbm90j"}

我们添加一个数据源
{: id="20201220214147-4rkubce"}

把Prometheus的地址填上
{: id="20201220214147-h8nriq1"}

导入prometheus的模板
{: id="20201220214147-giyk437"}

![](./2017-12-10_从零开始搭建Prometheus自动监控报警系统/9.png)
{: id="20201220214147-2xvuz5w"}

打开左上角选择已经导入的模板会看到已经有各种图
{: id="20201220214147-7r3dx4a"}

![](./2017-12-10_从零开始搭建Prometheus自动监控报警系统/10.png)
{: id="20201220214147-sef1ujf"}

我们来添加一个自己的图表
{: id="20201220214147-2nbjn8s"}

![](./2017-12-10_从零开始搭建Prometheus自动监控报警系统/11.png)
{: id="20201220214147-jko0ayz"}

![](./2017-12-10_从零开始搭建Prometheus自动监控报警系统/12.png)
{: id="20201220214147-wqu0dhs"}

指定自己想看的图标和关键字，右上角保存
{: id="20201220214147-518kpvl"}

![](./2017-12-10_从零开始搭建Prometheus自动监控报警系统/13.png)
{: id="20201220214147-b65sdii"}

看到如下数据
{: id="20201220214147-xag5udd"}

![](./2017-12-10_从零开始搭建Prometheus自动监控报警系统/14.png)
{: id="20201220214147-68xg8i9"}

到这里我们就已经实现了数据的自动收集和展示，下面来说下prometheus如何自动报警
{: id="20201220214147-r68hdhe"}

# 五.安装AlterManager
{: id="20201220214147-mm9grm3"}

Pormetheus的警告由独立的两部分组成。
{: id="20201220214147-r3ygdb5"}

Prometheus服务中的警告规则发送警告到Alertmanager。
{: id="20201220214147-vqu3791"}

然后这个Alertmanager管理这些警告。包括silencing, inhibition, aggregation，以及通过一些方法发送通知，例如：email，PagerDuty和HipChat。
{: id="20201220214147-h1e4y9b"}

建立警告和通知的主要步骤：
{: id="20201220214147-lrxf3tu"}

- {: id="20201220214147-22pd86k"}创建和配置Alertmanager
- {: id="20201220214147-evhzvfn"}启动Prometheus服务时，通过-alertmanager.url标志配置Alermanager地址，以便Prometheus服务能和Alertmanager建立连接。
{: id="20201220214147-5ir2giq"}

创建和配置Alertmanager
{: id="20201220214147-qlatar9"}

```
mkdir -p /home/chenqionghe/promethues/alertmanager
cd !$
```
{: id="20201220214147-3ik13o3"}

创建配置文件alertmanager.yml
{: id="20201220214147-9esajr3"}

```
global:
  resolve_timeout: 5m
route:
  group_by: ['cqh']
  group_wait: 10s #组报警等待时间
  group_interval: 10s #组报警间隔时间
  repeat_interval: 1m #重复报警间隔时间
  receiver: 'web.hook'
receivers:
  - name: 'web.hook'
    webhook_configs:
      - url: 'http://10.211.55.2:8888/open/test'
inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'dev', 'instance']
```
{: id="20201220214147-farut4e"}

这里配置成了web.hook的方式，当server通知alertmanager会自动调用webhook http://10.211.55.2:8888/open/test
{: id="20201220214147-ib64e5f"}

下面运行altermanager
{: id="20201220214147-fufb9re"}

```
docker rm -f alertmanager
docker run -d -p 9093:9093 \
--name alertmanager \
-v /home/chenqionghe/promethues/alertmanager/alertmanager.yml:/etc/alertmanager/alertmanager.yml \
prom/alertmanager
```
{: id="20201220214147-ccs1ktu"}

访问http://10.211.55.25:9093
{: id="20201220214147-tb7q5ef"}

![](./2017-12-10_从零开始搭建Prometheus自动监控报警系统/15.png)
{: id="20201220214147-mq02i70"}

接下来修改Server端配置报警规则和altermanager地址
{: id="20201220214147-v9z55q6"}

修改规则/home/chenqionghe/promethues/server/rules.yml
{: id="20201220214147-dqonva7"}

```
groups:
  - name: cqh
    rules:
      - alert: cqh测试
        expr: dead_lift > 150
        for: 1m
        labels:
          status: warning
        annotations:
          summary: "{{$labels.instance}}:硬拉超标！lightweight baby!!!"
          description: "{{$labels.instance}}:硬拉超标！lightweight baby!!!"
```
{: id="20201220214147-wltllio"}

这条规则的意思是，硬拉超过150公斤，持续一分钟，就报警通知
{: id="20201220214147-3qpmxth"}

然后再修改prometheus添加altermanager配置
{: id="20201220214147-ah4y5yp"}

```
global:
  scrape_interval:     15s # 默认抓取间隔, 15秒向目标抓取一次数据。
  external_labels:
    monitor: 'codelab-monitor'
rule_files:
  - /etc/prometheus/rules.yml
# 这里表示抓取对象的配置
scrape_configs:
  #这个配置是表示在这个配置内的时间序例，每一条都会自动添加上这个{job_name:"prometheus"}的标签  - job_name: 'prometheus'
  - job_name: 'prometheus'
    scrape_interval: 5s # 重写了全局抓取间隔时间，由15秒重写成5秒
    static_configs:
      - targets: ['localhost:9090']
      - targets: ['10.211.55.25:8080', '10.211.55.25:8081','10.211.55.25:8082']
        labels:
          group: 'client-golang'
      - targets: ['10.211.55.25:9100']
        labels:
          group: 'client-node-exporter'
      - targets: ['10.211.55.25:9091']
        labels:
          group: 'pushgateway'
alerting:
  alertmanagers:
    - static_configs:
        - targets: ["10.211.55.25:9093"]
```
{: id="20201220214147-f5gahci"}

重载prometheus配置，规则就已经生效
{: id="20201220214147-bmxcj6j"}

接下来我们观察grafana中数据的变化
{: id="20201220214147-b605pim"}

然后我们点击prometheus的Alert模块，会看到已经由绿->黄-红，触发了报警
{: id="20201220214147-fujy95y"}

![](./2017-12-10_从零开始搭建Prometheus自动监控报警系统/16.png)
{: id="20201220214147-p4kqa25"}

![](./2017-12-10_从零开始搭建Prometheus自动监控报警系统/17.png)
{: id="20201220214147-ley45q8"}

然后我们再来看看提供的webhook接口，这里的接口我是用的golang写的，接到数据后将body内容报警到钉钉
{: id="20201220214147-nm42ogb"}

![](./2017-12-10_从零开始搭建Prometheus自动监控报警系统/18.png)
{: id="20201220214147-2cscqcv"}

钉钉收到报警内容如下
{: id="20201220214147-lztam3w"}

![](./2017-12-10_从零开始搭建Prometheus自动监控报警系统/19.png)
{: id="20201220214147-97bm9zu"}

到这里，从零开始搭建Prometheus实现自动监控报警就说介绍完了，一条龙服务，自动抓取接口+自动报警+优雅的图表展示，你还在等什么，赶紧high起来！
{: id="20201220214147-8liqfkk"}


{: id="20201220214147-j2tw8w4" type="doc"}
