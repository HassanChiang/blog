----
title: 【笔记】深入理解计算机系统 01 - 计算机系统漫游
date: 2021-07-14
description: 

tags:
- 读书笔记
- 深入理解计算机系统

nav:
- 深入理解计算机系统

categories:
- 计算机系统

----
说明： 为了方便定位笔记对应的原书位置，笔记内容中段落的标号与原书章节号保持一致！

#### 1.1 

文件分类： 文本文件、二进制文件

#### 1.2 

``` c
#include <stdio.h>

int main(){
    printf("Hello, world\n");
    return 0;
}
```

gcc 编译4阶段:

```
hello.c(文本) -> 预处理器(cpp) ->
hello.i(文本) -> 编译器(ccl) -> 
hello.s(文本) -> 汇编器(as) -> 
hello.o(二进制) + prntf.o(二进制) -> 连接器(ld) -> 
可执行文件：hello(二进制)
```

旁注：[GNU 是什么，和 Linux 是什么关系？](https://www.zhihu.com/question/319783573/answer/656033035)

#### 1.4.1 

总线，传送定长字节块，也叫字（word）；字不同于字节(Byte)；字中的字节数（字长）是一个基本的系统参数，大多数机器字长为4字节（32位）或8字节（64位）。

