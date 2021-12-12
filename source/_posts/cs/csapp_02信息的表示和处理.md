----
title: 【笔记】深入理解计算机系统 02 - 信息的表示和处理
date: 2021-08-14
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

### 2.1.5 表示代码

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

