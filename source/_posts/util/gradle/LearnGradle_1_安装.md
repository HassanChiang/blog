---

title: Learn Gradle - 1 安装
date: 2017-10-26
description:
{: id="20201220214147-sw4xju6"}

tags:
{: id="20201220214147-cdhvxb3"}

- {: id="20201220214147-2rvhmfp"}包管理
- {: id="20201220214147-jmoi7va"}Gradle
- {: id="20201220214147-nrckylw"}Java
{: id="20201220214147-5jh6b1e"}

nav:
{: id="20201220214147-m5a7rm6"}

- {: id="20201220214147-lz2pga3"}工具
{: id="20201220214147-0627vlq"}

categories:
{: id="20201220214147-li4xxkw"}

- {: id="20201220214147-6zzotqq"}Gradle
{: id="20201220214147-ool82vz"}

image: images/gradle.png
{: id="20201220214147-0udw1rt"}

---

## 1、下载Gradle
{: id="20201220214147-s2vgxnc"}

方式一：http://gradle.org/  使用首页Download链接直接下载最新版。
{: id="20201220214147-fuke7do"}

方式二：http://gradle.org/gradle-download/  在“PREVIOUS RELEASES”（右侧）下方选择一个版本，然后选择完整版“Complete distribution”或者选择不含源码和文档仅包含程序的版本“Binary only distribution”下载。
{: id="20201220214147-7bxhyqj"}

（这里下载最新版本完整压缩包：gradle-2.5-all.zip）
{: id="20201220214147-adwvfg0"}

## 2、安装
{: id="20201220214147-t02yfon"}

解压缩下载的zip文件：gradle-2.5-all.zip 得到目录 gradle-2.5 ，将文件夹移动到合适的位置，如 F:\gradle-2.5，这个文件包含了所有gradle的内容，包括：
{: id="20201220214147-mjm8i35"}

```bash
执行程序（bin、lib）
文档（docs）
源码（src）
例子（samples）
配置环境变量：
```
{: id="20201220214147-ss59c29"}

新增变量名：GRADLE_HOME，变量值：F:\gradle-2.5
在已有Path变量的末尾追加字符串 ”;%GRADLE_HOME%\bin;“（引号内的字符串）
{: id="20201220214147-zalatco"}

<!--more-->

## 3、测试
{: id="20201220214147-g08ynov"}

打开cmd，执行命令：gradle -v，输出
{: id="20201220214147-6gdy66y"}

```bash
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
{: id="20201220214147-r2orwyb"}

至此，Gradle安装完毕。
{: id="20201220214147-2lrhfv0"}


{: id="20201220214147-nfgnyvu" type="doc"}
