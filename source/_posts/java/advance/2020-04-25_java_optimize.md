----
title: 接口性能优化思路
date: 2020-04-25
description: 

tags:
- 性能优化
- Java

nav:
- Java

categories:
- Java 进阶

image: images/java/basic/java_logo.png

----
#### 1. 数据库查询是否有问题，是不是慢查？索引？数据量？

#### 2. 中间件：缓存，命中率？

#### 3. 代码：过长，多层循环？

#### 4. 多线程并发

* 开多少线程

* 如何控制线程数量

* 线程安全问题

* Executors 慎用，内部无界队列；