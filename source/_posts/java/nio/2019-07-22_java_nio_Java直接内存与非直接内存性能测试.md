---

title: Java直接内存与非直接内存性能测试
date: 2019-07-22
description:
{: id="20201220214147-kxbdmp2"}

tags:
{: id="20201220214147-2zqzkax"}

- {: id="20201220214147-xbab5o3"}直接内存
- {: id="20201220214147-p300vej"}非直接内存
- {: id="20201220214147-89m1pyx"}堆内存
- {: id="20201220214147-mw1i3mh"}NIO
- {: id="20201220214147-ebo0xnx"}Java
{: id="20201220214147-wnxnfjl"}

nav:
{: id="20201220214147-1to2ama"}

- {: id="20201220214147-673re79"}Java
{: id="20201220214147-ctvx7dy"}

categories:
{: id="20201220214147-sddmllk"}

- {: id="20201220214147-0frzzp8"}Java NIO
{: id="20201220214147-a8zixj0"}

image: images/java/io.png
{: id="20201220214147-134udrf"}

---

## 什么是直接内存与非直接内存
{: id="20201220214147-7oojzvg"}

根据官方文档的描述：
{: id="20201220214147-e6depha"}

> A byte bufferis either direct or non-direct. Given a direct byte buffer, the Java virtual machine will make a best effort to perform native I/O operations directly upon it. That is, it will attempt to avoid copying the buffer's content to (or from) an intermediate buffer before (orafter) each invocation of one of the underlying operating system's native I/O operations.
> {: id="20201220214147-594jfna"}
{: id="20201220214147-90dw9zc"}

`byte byffer`可以是两种类型，一种是基于直接内存（也就是非堆内存）；另一种是非直接内存（也就是堆内存）。
{: id="20201220214147-n69h2ke"}

对于直接内存来说，JVM将会在IO操作上具有更高的性能，因为它直接作用于本地系统的IO操作。而非直接内存，也就是堆内存中的数据，如果要作IO操作，会先复制到直接内存，再利用本地IO处理。
{: id="20201220214147-ypgqgy2"}

从数据流的角度，非直接内存是下面这样的作用链：
{: id="20201220214147-7ph3832"}

```
本地IO-->直接内存-->非直接内存-->直接内存-->本地IO
```
{: id="20201220214147-fxxtr0h"}

而直接内存是：
{: id="20201220214147-rroo816"}

```
本地IO-->直接内存-->本地IO
```
{: id="20201220214147-af6qmko"}

很明显，再做IO处理时，比如网络发送大量数据时，直接内存会具有更高的效率。
{: id="20201220214147-1e1lvca"}

> A direct byte buffer may be created by invoking the allocateDirect factory method of this class. The buffers returned by this method typically have somewhat higher allocation and deallocation costs than non-direct buffers. The contents of direct buffers may reside outside of the normal garbage-collected heap, and so their impact upon the memory footprint of an application might not be obvious. It is therefore recommended that direct buffers be allocated primarily for large, long-lived buffers that are subject to the underlying system's native I/O operations. In general it is best to allocate direct buffers only when they yield a measureable gain in program performance.
> {: id="20201220214147-mi3sa2n"}
{: id="20201220214147-9q1uj3r"}

但是，不要高兴的太早。文档中也说了，直接内存使用allocateDirect创建，但是它比申请普通的堆内存需要耗费更高的性能。不过，这部分的数据是在JVM之外的，因此它不会占用应用的内存。
{: id="20201220214147-x0kpu04"}

所以呢，当你有很大的数据要缓存，并且它的生命周期又很长，那么就比较适合使用直接内存。只是一般来说，如果不是能带来很明显的性能提升，还是推荐直接使用堆内存。
{: id="20201220214147-bmyuuk3"}

关于直接内存需要注意的，就是上面两点了，其他的关于视图啊、作用链啊，都是使用上的问题了。如果有兴趣，可以[参考官方API ( 进去后搜索ByteBuffer，就能看到！)](http://docs.oracle.com/javase/8/docs/api/)，里面有少量的描述！重要的一些用法，还得自己摸索。
{: id="20201220214147-z4f9ar1"}

## 使用场景
{: id="20201220214147-8ylw9st"}

通过上面的官方文档，与一些资料的搜索。可以总结下，直接内存的使用场景：
{: id="20201220214147-jv5x2h2"}

- {: id="20201220214147-2l22rxk"}1 有很大的数据需要存储，它的生命周期又很长
- {: id="20201220214147-vs75uer"}2 适合频繁的IO操作，比如网络并发场景
{: id="20201220214147-h6ovd5b"}

## 申请分配地址速度比较
{: id="20201220214147-55uu6qi"}

下面用一段简单的代码，测试下申请内存空间的速度：
{: id="20201220214147-98do807"}

```
inttime = 10000000;
Date begin = newDate();
for(int i=0;i<time;i++){
    ByteBuffer buffer = ByteBuffer.allocate(2);
}
Dateend = newDate();
System.out.println(end.getTime()-begin.getTime());
begin = newDate();
for(int i=0;i<time;i++){
    ByteBuffer buffer = ByteBuffer.allocateDirect(2);
}
end = newDate();
System.out.println(end.getTime()-begin.getTime());
```
{: id="20201220214147-4c5ehhq"}

得到的测试结果如下：
{: id="20201220214147-ebywt45"}

![](./2019-07-22_java_nio_Java直接内存与非直接内存性能测试/1.png)
{: id="20201220214147-3p4cyhv"}

在数据量提升时，直接内存相比于非直接内存的申请 有十分十分十分明显的性能问题！
{: id="20201220214147-c33a67a"}

## 读写速度比较
{: id="20201220214147-04b6me7"}

然后在写段代码，测试下读写的速度：
{: id="20201220214147-aej6zng"}

```
inttime = 1000;
Date begin = newDate();
ByteBuffer buffer = ByteBuffer.allocate(2*time);
for(int i=0;i<time;i++){
    buffer.putChar('a');
}
buffer.flip();
for(int i=0;i<time;i++){
    buffer.getChar();
}
Dateend = newDate();
System.out.println(end.getTime()-begin.getTime());
begin = newDate();
ByteBuffer buffer2 = ByteBuffer.allocateDirect(2*time);
for(int i=0;i<time;i++){
    buffer2.putChar('a');
}
buffer2.flip();
for(int i=0;i<time;i++){
    buffer2.getChar();
}
end = newDate();
System.out.println(end.getTime()-begin.getTime());
```
{: id="20201220214147-9g5fosy"}

测试的结果如下：
{: id="20201220214147-625x4is"}

![](./2019-07-22_java_nio_Java直接内存与非直接内存性能测试/2.png)
{: id="20201220214147-apqovma"}

可以看到直接内存在直接的IO操作上，还是有明显的差异的！
{: id="20201220214147-4hed9g4"}

作者：[xingoo](http://www.cnblogs.com/xing901022)
{: id="20201220214147-dg5210t"}

出处：http://www.cnblogs.com/xing901022
{: id="20201220214147-vhd7j27"}


{: id="20201220214147-r4gzrzd" type="doc"}
