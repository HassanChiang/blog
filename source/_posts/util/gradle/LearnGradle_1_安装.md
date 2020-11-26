----
title: Learn Gradle - 1 安装
date: 2017-10-26 
description: 

tags:
- 包管理
- Gradle
- Java

nav:
- 开发工具

categories:
- Gradle

image: images/gradle.png

----

## 1、下载Gradle 

方式一：http://gradle.org/  使用首页Download链接直接下载最新版。

方式二：http://gradle.org/gradle-download/  在“PREVIOUS RELEASES”（右侧）下方选择一个版本，然后选择完整版“Complete distribution”或者选择不含源码和文档仅包含程序的版本“Binary only distribution”下载。

（这里下载最新版本完整压缩包：gradle-2.5-all.zip）

## 2、安装

解压缩下载的zip文件：gradle-2.5-all.zip 得到目录 gradle-2.5 ，将文件夹移动到合适的位置，如 F:\gradle-2.5，这个文件包含了所有gradle的内容，包括：

``` bash
执行程序（bin、lib）
文档（docs）
源码（src）
例子（samples）
配置环境变量：
```

新增变量名：GRADLE_HOME，变量值：F:\gradle-2.5
在已有Path变量的末尾追加字符串 ”;%GRADLE_HOME%\bin;“（引号内的字符串）

<!--more-->

## 3、测试    

打开cmd，执行命令：gradle -v，输出

``` bash
------------------------------------------------------------
Gradle 2.5
------------------------------------------------------------

Build time:   2015-07-08 07:38:37 UTC
Build number: none
Revision:     093765bccd3ee722ed5310583e5ed140688a8c2b

Groovy:       2.3.10
Ant:          Apache Ant(TM) version 1.9.3 compiled on December 23 2013
JVM:          1.7.0_71 (Oracle Corporation 24.71-b01)
OS:           Windows 8 6.2 x86
```

至此，Gradle安装完毕。