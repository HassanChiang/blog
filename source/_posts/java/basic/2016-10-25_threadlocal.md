----
title: ThreadLocal 笔记
date: 2016-10-25 11:29:24
description: 

tags:
- ThreadLocal
- Java线程
- Java

nav:
- Java

categories:
-  Java 基础

image: images/java/basic/java_logo.png

----

**作用**

ThreadLocal 不是用来解决共享对象访问的多线程访问问题，而是用于解决不同线程保持各自独立的一个对象。
典型的问题就是：当一个单例 A 持有某个属性对象 a.b 时，如果 a.b 在多个方法里面使用，就有可能造成线程不安全，如果把 b 定义成 ThreadLocal<B> b 就可以避免以上问题。

**实现**

一、ThreadLocal

实例方法：
```
public void set(T value) {
    Thread t = Thread.currentThread();
    ThreadLocalMap map = getMap(t);
    if (map != null)
        map.set(this, value);
    else
        createMap(t, value);
}
ThreadLocalMap getMap(Thread t) {
    return t.threadLocals;
}
void createMap(Thread t, T firstValue) {
    t.threadLocals = new ThreadLocalMap(this, firstValue);
}
public T get() {
    Thread t = Thread.currentThread();
    ThreadLocalMap map = getMap(t);
    if (map != null) {
        ThreadLocalMap.Entry e = map.getEntry(this);
        if (e != null)
            return (T)e.value;
    }
    return setInitialValue();
}
```
set() 方法逻辑：
获取当前线程对应的 ThreadLocalMap map;
如果存在直接 map.set;
否则 new ThreadLocalMap 给线程使用。

由此可知，每个线程都有一个自己的 ThreadLocal.ThreadLocalMap 对象。

get() 方法逻辑：
获取当前线程对应的 ThreadLocalMap map;
如果存在，且当前 ThreadLocal 实例对应的值不为空，返回 map 拿到的值；
否则，设置前 ThreadLocal 实例默认值并返回。

二、ThreadLocalMap

ThreadLocalMap 构造函数：
```
private static final int INITIAL_CAPACITY = 16;
ThreadLocalMap(ThreadLocal firstKey, Object firstValue) {
    table = new Entry[INITIAL_CAPACITY];
    int i = firstKey.threadLocalHashCode & (INITIAL_CAPACITY - 1);
    table[i] = new Entry(firstKey, firstValue);
    size = 1;
    setThreshold(INITIAL_CAPACITY);
}
```
第一点：INITIAL_CAPACITY 必须是 2 的 N 次幂，默认值为 16。

为什么是 2 的 N 次幂值？

ThreadLocalMap 类保存着一个 table 每一个 ThreadLocal 有自己的 threadLocalHashCode 值

从 ThreadLocalMap table 里存 / 取值的时候会通过 threadLocalHashCode 值计算出一个 i，再通过 table[i] 得到 ThreadLocal 的值。
如构造函数代码所示：
```
int i = firstKey.threadLocalHashCode & (INITIAL_CAPACITY - 1);
```
这是计算方法，这个过程实际上是一个取模的过程。

举个例子

十进制取模：26 % 16 = 10

二进制取模：
```
  00011010 
& 00001111
= 00001010
= 10
```
所以，十进制的取模对于二进制，只需要使用公式 M & (C-1) 即可，这种与操作对于 CPU 运算效率很高。当然，一个大前提就是 C-1 的值转换为二进制时，低位部分要求全是 1 才行。所以要求 C 必须是 2 的 N 次幂。

第二点：threadLocalHashCode

看一下 ThreadLocal 这部分的代码：
```
/**
 * ThreadLocals rely on per-thread linear-probe hash maps attached
 * to each thread (Thread.threadLocals and
 * inheritableThreadLocals).  The ThreadLocal objects act as keys,
 * searched via threadLocalHashCode.  This is a custom hash code
 * (useful only within ThreadLocalMaps) that eliminates collisions
 * in the common case where consecutively constructed ThreadLocals
 * are used by the same threads, while remaining well-behaved in
 * less common cases.
 */
private final int threadLocalHashCode = nextHashCode();
/**
 * The next hash code to be given out. Updated atomically. Starts at
 * zero.
 */
private static AtomicInteger nextHashCode = new AtomicInteger();
/**
 * The difference between successively generated hash codes - turns
 * implicit sequential thread-local IDs into near-optimally spread
 * multiplicative hash values for power-of-two-sized tables.
 */
private static final int HASH_INCREMENT = 0x61c88647;
/**
 * Returns the next hash code.
 */
private static int nextHashCode() {
    return nextHashCode.getAndAdd(HASH_INCREMENT);
}
```
可以看出来，ThreadLocal 第一次 set 值的时候，threadLocalHashCode 得到的是 0，之后每次得到的数都是加了 0x61c88647。这算一个 16 进制表示的数，转换成十进制是：1640531527。

为什么是这个数？

本屌暂时还没搞懂~

简单的总结一下 ThreadLocal：

1、每一个 ThreadLocal 实例有一个自己的 threadLocalHashCode；
2、每一个 Thread 有一个自己的 ThreadLocalMap threadLocals， threadLocals 的 key 是 ThreadLocal 实例，value 是 ThreadLocal 真是的实际保存的对象实例。
3、ThreadLocalMap 使用 table 数组保存每一个 Entry（key-value）。
4、ThreadLocalMap 计算 ThreadLocal 对应 table[i] 的 i 使用 threadLocalHashCode 取模获得。