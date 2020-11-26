----
title: Spring Boot 排坑
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
###  **1**

![](./2020-05-20_SpringBoot排坑/1.png) 

2.0.3 有内存暂用 不释放的问题，小版本升级到2.0.5就可以解决；

###  **2**

SpringBoot 2.2.x 版本有CPU增高的bug；
2.2.1-2.2.5 版本是会造成频繁的拿锁与解锁 ；
2.2.6 版本 cpu会持续增高 
建议选择： 2.1 版本；

###  **3**

SpringBoot 自动依赖 mysql-connector-java 5.1.47 (有坑)，改成强制依赖 5.1.46解决；相关问题：
https://bugs.mysql.com/bug.php?id=92089
https://github.com/spring-projects/spring-boot/issues/14638