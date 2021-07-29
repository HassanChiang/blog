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

## 1.1 

文件分类： `文本文件`、`二进制文件`

## 1.2 

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

### 1.4.1 

总线，传送定长字节块，也叫`字`（word）；字不同于字节(Byte)；字中的字节数（字长）是一个基本的系统参数，大多数机器字长为4字节（32位）或8字节（64位）。

### 1.7.1

操作系统抽象：`进程`、`虚拟内存`和`文件`。
进程，交错执行，称为`并发运行`。交错执行的机制称为`上下文切换`。
进程`上下文`：操作系统保持跟踪进程运行所需的所有状态信息，包括：PC(程序计数器)、寄存器值和主存内容等。

### 1.7.2

`线程`

### 1.7.3

`虚拟内存`

每个进程看到的内存都是一致的，称为`虚拟地址空间`。
虚拟内存空间由大量准确定义的`区`构成，包括：
* 程序代码和数据
* 堆
* 共享库
* 栈
* 内核虚拟内存

### 1.7.4

### 2.1.5

打印对象的字节表示

``` c
#include <stdio.h>

typedef unsigned char *byte_pointer;

void show_bytes(byte_pointer start, size_t len)
{
    size_t i;
    for (size_t i = 0; i < len; i++)
    {
        printf(" %.2x", start[i]);
    }
    printf("\n");
}

void show_int(int x)
{
    show_bytes((byte_pointer)&x, sizeof(int));
}

void show_float(int x)
{
    show_bytes((byte_pointer)&x, sizeof(float));
}

void show_pointer(void *x)
{
    show_bytes((byte_pointer)&x, sizeof(void *));
}

int main(){
    show_int(0x654321);
    show_float(0x654321);
    float *a, *b;
    show_pointer(a);
    show_pointer(b);
}
```

输出：

```
 21 43 65 00
 21 43 65 00
 d0 99 27 87 ff 7f 00 00
 00 00 00 00 00 00 00 00
```

说明我的机器是小端表示。

