----
title: 请给Sprint Boot多一些内存
date: 2020-05-20
description: 

tags:
- Java
- Spring
- Spring Boot

nav:
- Spring

categories:
- Spring Boot

image: images/java/spring-framework.png

----
## 概述

SprintBoot总体来说，搭建还是比较容易的，特别是SpringCloud全家桶，简称亲民微服务，但在发展趋势中，容器化技术已经成熟，面对巨耗内存的SprintBoot，小公司表示用不起。如今，很多刚诞生的JAVA微服务框架大多主打“轻量级”，主要还是因为SprintBoot太重。

## JAVA系微服务框架No1-Spring Cloud

#### 介绍

有Spring大靠山在，更新、稳定性、成熟度的问题根本不需要考虑。在JAVA系混的技术人员大约都听说过Spring的大名吧，所以不缺程序员……，而且这入手的难度十分低，完全可以省去一个架构师。
但是，你必然在服务器上付出：

- 至少一台“服务发现 ”的服务器；
- 可能有一个统一的网关Gateway;
- 可能需要一个用于“分布式配置管理”的配置中心；
- 可能进行“服务追踪”，知道我的请求从哪里来，到哪里去；
- 可能需要“集群监控”；
项目上线后发现，我们需要好多服务器，每次在集群中增加服务器时，都感觉心疼；

#### 压测30秒

##### 压测前的内存占用

![](2020-05-20_请给SprintBoot多一些内存/1.png)
如图，内存占用304M。

##### 压测时的内存占用

![](2020-05-20_请给SprintBoot多一些内存/2.png)
如图，内存占用1520M（1.5G），CPU上升到321%

##### 概览

![](2020-05-20_请给SprintBoot多一些内存/3.png)

##### 总结

一个SprintBoot的简单应用，最少1G内存，一个业务点比较少的微服务编译后的JAR会大约50M；而SprintCloud引入的组件会相对多一些，消耗的资源也会相对更多一些。

启动时间大约10秒左右: `Started Application in 10.153 seconds (JVM running for 10.915)`


## JAVA系响应式编程的工具包Vert.x

#### 介绍

背靠Eclipse的[Eclipse Vert.x](https://vertx.io/)是一个用于在JVM上构建响应式应用程序的工具包。定位上与SprintBoot不冲突，甚至可以将Vert.x结合SprintBoot使用。众多Vert.x模块提供了大量微服务的组件，在很多人眼里是一种微服务架构的选择。

华为微服务框架[Apache ServiceComb](http://servicecomb.apache.org/cn/)就是以Vert.x为底层框架实现的，在"基准测试网站TechEmpower"中，Vert.x的表现也十分亮眼。

#### 压测30秒

##### 压测前的内存占用
![](2020-05-20_请给SprintBoot多一些内存/4.png)
如图，内存占用65M。

##### 压测时的内存占用
![](2020-05-20_请给SprintBoot多一些内存/5.png)
如图，内存占139M，CPU占2.1%，给人的感觉似乎并没有进行压测。

##### 概览

![](2020-05-20_请给SprintBoot多一些内存/6.png)

##### 总结

Vert.x单个服务打包完成后大约7M左右的JAR，不依赖Tomcat、Jetty之类的容器，直接在JVM上跑。

Vert.x消耗的资源很低，感觉一个1核2G的服务器已经能够部署许多个Vert.x服务。除去编码方面的问题，真心符合小项目和小模块。git市场上已经出现了基于Vert.x实现的开源网关- [VX-API-Gateway帮助文档](https://duhua.gitee.io/vx-api-gateway-doc/)
对多语言支持，很适合小型项目快速上线。

启动时间不到1秒：`Started Vert.x in 0.274 seconds (JVM running for 0.274)`

## JAVA系其他微服务框架

### SparkJava

- jar比较小，大约10M
- 占内存小，大约30~60MB；
- 性能还可以，与SprintBoot相仿；

### Micronaut

- Grails团队新宠；
- 可以用 Java、Groovy 和 Kotlin 编写的基于微服务的应用程序；
- 相比SprintBoot已经比较全面；
- 性能较优，编码方式与SprintBoot比较类似；
- 启动时间和内存消耗方面比其他框架更高效；
- 多语言；
- 依赖注入；
- 内置多种云本地功能；
- 很新，刚发布1.0.0

### Javalin

- 上手极为容易；
- 灵活，可以兼容同步和异步两种编程思路；
- JAR小，4～5M；
- 多语言；
- 有KOA的影子；
- 只有大约2000行源代码，源代码足够简单，可以理解和修复；
- 符合当今趋势；
- 多语言；
- 嵌入式服务器Jetty；

### Quarkus

- 启动快；
- JAR小，大约10M；
- 文档很少；

原文：https://juejin.im/post/5c89f266f265da2d8763b5f9