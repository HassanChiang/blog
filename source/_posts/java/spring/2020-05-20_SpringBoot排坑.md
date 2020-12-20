---

title: Spring Boot 排坑
date: 2020-05-20
description:
{: id="20201220214147-lsxkasu"}

tags:
{: id="20201220214147-ckr1f52"}

- {: id="20201220214147-5wmv502"}Java
- {: id="20201220214147-uivc26g"}Spring
- {: id="20201220214147-k54qcu1"}Spring Boot
{: id="20201220214147-fqdcjju"}

nav:
{: id="20201220214147-pnwqjwq"}

- {: id="20201220214147-poyss9x"}Spring
{: id="20201220214147-vmoc4ax"}

categories:
{: id="20201220214147-4y6zm7l"}

- {: id="20201220214147-q9afsy3"}Spring Boot
{: id="20201220214147-oxoc1mo"}

image: images/java/spring-framework.png
{: id="20201220214147-1bkqpc9"}

---

### **1**
{: id="20201220214147-imis52y"}

![](./2020-05-20_SpringBoot排坑/1.png)
{: id="20201220214147-l5sv87t"}

2.0.3 有内存暂用 不释放的问题，小版本升级到2.0.5就可以解决；
{: id="20201220214147-bimqd6k"}

### **2**
{: id="20201220214147-geqhjpj"}

SpringBoot 2.2.x 版本有CPU增高的bug；
2.2.1-2.2.5 版本是会造成频繁的拿锁与解锁 ；
2.2.6 版本 cpu会持续增高
建议选择： 2.1 版本；
{: id="20201220214147-213ksku"}

### **3**
{: id="20201220214147-yu5cx3o"}

SpringBoot 自动依赖 mysql-connector-java 5.1.47 (有坑)，改成强制依赖 5.1.46解决；相关问题：
https://bugs.mysql.com/bug.php?id=92089
https://github.com/spring-projects/spring-boot/issues/14638
{: id="20201220214147-1682j4g"}


{: id="20201220214147-f5p5pkl" type="doc"}
