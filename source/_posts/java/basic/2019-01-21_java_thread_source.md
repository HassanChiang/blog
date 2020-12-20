---
title: 从源码的角度再学「Thread」
date: 2019-01-21 09:46:24
description: 

tags:
- 源码
- Java线程
- Java

nav:
- Java

categories:
-  Java 基础

image: images/java/basic/java_logo.png
---
{: id="20201220214147-35pfy1i"}

原创： zhangshaolin **张少林同学**
微信号: zhangshaolin_tonxue
{: id="20201220214147-b5wm1wi"}

功能介绍 分享
{: id="20201220214147-ldpjgm8"}

前言
----
{: id="20201220214147-lnjpnmk"}

`Java`中的线程是使用`Thread`类实现的，`Thread`在初学`Java`的时候就学过了，也在实践中用过，不过一直没从源码的角度去看过它的实现，今天从源码的角度出发，再次学习`Java Thread`，愿此后对`Thread`的实践更加得心应手。
{: id="20201220214147-5wjobqr"}

从注释开始
----------
{: id="20201220214147-i97a62i"}

相信阅读过`JDK`源码的同学都能感受到`JDK`源码中有非常详尽的注释，阅读某个类的源码应当先看看注释对它的介绍，注释原文就不贴了，以下是我对它的总结：
{: id="20201220214147-lsel47v"}

* {: id="20201220214147-bzcrgpv"}`Thread`是程序中执行的线程，`Java`虚拟机允许应用程序同时允许多个执行线程
  {: id="20201220214147-akpfoe0"}
* {: id="20201220214147-nu5hrog"}每个线程都有优先级的概念，具有较高优先级的线程优先于优先级较低的线程执行
  {: id="20201220214147-bvk3b8f"}
* {: id="20201220214147-ijowpwo"}每个线程都可以被设置为守护线程
  {: id="20201220214147-q7qyqk4"}
* {: id="20201220214147-k81m696"}当在某个线程中运行的代码创建一个新的`Thread`对象时，新的线程优先级跟创建线程一致
  {: id="20201220214147-b9ohmxi"}
* {: id="20201220214147-j21jn2p"}当`Java`虚拟机启动的时候都会启动一个叫做`main`的线程，它没有守护线程，`main`线程会继续执行，直到以下情况发送
  {: id="20201220214147-otqc1te"}
* {: id="20201220214147-fbdy6gn"}`Runtime` 类的退出方法`exit`被调用并且安全管理器允许进行退出操作
  {: id="20201220214147-ogvfhzr"}
* {: id="20201220214147-12dyus7"}所有非守护线程均已死亡，或者`run`方法执行结束正常返回结果，或者`run`方法抛出异常
  {: id="20201220214147-vjy4lmc"}
* {: id="20201220214147-5ynh8lu"}创建线程第一种方式：继承`Thread`类，重写`run`方法
  {: id="20201220214147-pzplndo"}
  ```
   1  //定义线程类
   2  class PrimeThread extends Thread {
   3        long minPrime;
   4        PrimeThread(long minPrime) {
   5            this.minPrime = minPrime;
   6        }
   7        public void run() {
   8            // compute primes larger than minPrime
   9            &nbsp;.&nbsp;.&nbsp;.
  10        }
  11    }
  12  //启动线程
  13  PrimeThread p = new PrimeThread(143);
  14  p.start();
  ```
  {: id="20201220214147-rkplhv6"}
* {: id="20201220214147-yw5mieq"}创建线程第二种方式：实现`Runnable`接口，重写`run`方法，因为`Java`的单继承限制，通常使用这种方式创建线程更加灵活
  {: id="20201220214147-qyivdw1"}
  ```
   1  //定义线程
   2   class PrimeRun implements Runnable {
   3        long minPrime;
   4        PrimeRun(long minPrime) {
   5            this.minPrime = minPrime;
   6        }
   7        public void run() {
   8            // compute primes larger than minPrime
   9            &nbsp;.&nbsp;.&nbsp;.
  10        }
  11    }
  12  //启动线程
  13  PrimeRun p = new PrimeRun(143);
  14  new Thread(p).start();
  ```
  {: id="20201220214147-zcszphp"}
* {: id="20201220214147-g48kq2i"}创建线程时可以给线程指定名字，如果没有指定，会自动为它生成名字
  {: id="20201220214147-fddbrt5"}
* {: id="20201220214147-7nzjr56"}除非另有说明，否则将`null`参数传递给`Thread`类中的构造函数或方法将导致抛出 `NullPointerException`
  {: id="20201220214147-hwoidx3"}
{: id="20201220214147-kjk5gla"}

Thread 常用属性
---------------
{: id="20201220214147-b7y0tac"}

阅读一个`Java`类，先从它拥有哪些属性入手：
{: id="20201220214147-9xl1tbp"}

```
	 1  //线程名称，创建线程时可以指定线程的名称
	 2  private volatile String name;
	 3  
	 4  //线程优先级，可以设置线程的优先级
	 5  private int priority;
	 6  
	 7  //可以配置线程是否为守护线程，默认为false
	 8  private boolean daemon = false;
	 9  
	10  //最终执行线程任务的`Runnable`
	11  private Runnable target;
	12  
	13  //描述线程组的类
	14  private ThreadGroup group;
	15  
	16  //此线程的上下文ClassLoader
	17  private ClassLoader contextClassLoader;
	18  
	19  //所有初始化线程的数目，用于自动编号匿名线程，当没有指定线程名称时，会自动为其编号
	20  private static int threadInitNumber;
	21  
	22  //此线程请求的堆栈大小，如果创建者没有指定堆栈大小，则为0。, 虚拟机可以用这个数字做任何喜欢的事情。, 一些虚拟机会忽略它。
	23  private long stackSize;
	24  
	25  //线程id
	26  private long tid;
	27  
	28  //用于生成线程ID
	29  private static long threadSeqNumber;
	30  
	31  //线程状态
	32  private volatile int threadStatus = 0;
	33  
	34  //线程可以拥有的最低优先级
	35  public final static int MIN_PRIORITY = 1;
	36  
	37  //分配给线程的默认优先级。
	38  public final static int NORM_PRIORITY = 5;
	39  
	40  //线程可以拥有的最大优先级
	41  public final static int MAX_PRIORITY = 10;
```
{: id="20201220214147-i3pvykw"}

Thread 构造方法
---------------
{: id="20201220214147-iguo0u8"}

了解了属性之后，看看`Thread`实例是怎么构造的？先预览下它大致有多少个构造方法：
{: id="20201220214147-4uisx2l"}

![a77dcb75-2e68-4785-81f8-a4b242b67382-image.png](/assets/uploads/files/1548122247324-a77dcb75-2e68-4785-81f8-a4b242b67382-image.png)
{: id="20201220214147-gvjobev"}

查看每个构造方法内部源码，发现均调用的是名为`init`的私有方法，再看`init`方法有两个重载，而其核心方法如下：
{: id="20201220214147-onyn57a"}

```
 1   /**
 2     * Initializes a Thread.
 3     *
 4     * @param g                   线程组
 5     * @param target              最终执行任务的 `run()` 方法的对象
 6     * @param name                新线程的名称
 7     * @param stackSize           新线程所需的堆栈大小，或者 0 表示要忽略此参数
 8     * @param acc                 要继承的AccessControlContext，如果为null，则为 AccessController.getContext()
 9     * @param inheritThreadLocals 如果为 true，从构造线程继承可继承的线程局部的初始值
10     */
11    private void init(ThreadGroup g, Runnable target, String name,
12                      long stackSize, AccessControlContext acc,
13                      boolean inheritThreadLocals) {
14        //线程名称为空，直接抛出空指针异常
15        if (name == null) {
16            throw new NullPointerException("name cannot be null");
17        }
18        //初始化当前线程对象的线程名称
19        this.name = name;
20        //获取当前正在执行的线程为父线程
21        Thread parent = currentThread();
22        //获取系统安全管理器
23        SecurityManager security = System.getSecurityManager();
24        //如果线程组为空
25        if (g == null) {
26            //如果安全管理器不为空
27            if (security != null) {
28                //获取SecurityManager中的线程组
29                g = security.getThreadGroup();
30            }
31            //如果获取的线程组还是为空
32            if (g == null) {
33                //则使用父线程的线程组
34                g = parent.getThreadGroup();
35            }
36        }
37
38        //检查安全权限
39        g.checkAccess();
40
41        //使用安全管理器检查是否有权限
42        if (security != null) {
43            if (isCCLOverridden(getClass())) {
44                security.checkPermission(SUBCLASS_IMPLEMENTATION_PERMISSION);
45            }
46        }
47
48        //线程组中标记未启动的线程数+1，这里方法是同步的，防止出现线程安全问题
49        g.addUnstarted();
50
51        //初始化当前线程对象的线程组
52        this.group = g;
53        //初始化当前线程对象的是否守护线程属性，注意到这里初始化时跟父线程一致
54        this.daemon = parent.isDaemon();
55        //初始化当前线程对象的线程优先级属性，注意到这里初始化时跟父线程一致
56        this.priority = parent.getPriority();
57        //这里初始化类加载器
58        if (security == null || isCCLOverridden(parent.getClass()))
59            this.contextClassLoader = parent.getContextClassLoader();
60        else
61            this.contextClassLoader = parent.contextClassLoader;
62        this.inheritedAccessControlContext =
63                acc != null ? acc : AccessController.getContext();
64        //初始化当前线程对象的最终执行任务对象
65        this.target = target;
66        //这里再对线程的优先级字段进行处理
67        setPriority(priority);
68        if (inheritThreadLocals && parent.inheritableThreadLocals != null)
69            this.inheritableThreadLocals =
70                ThreadLocal.createInheritedMap(parent.inheritableThreadLocals);
71        //初始化当前线程对象的堆栈大小
72        this.stackSize = stackSize;
73
74        //初始化当前线程对象的线程ID，该方法是同步的，内部实际上是threadSeqNumber++
75        tid = nextThreadID();
76    }
```
{: id="20201220214147-yhwkmro"}

另一个重载`init`私有方法如下，实际上内部调用的是上述`init`方法：
{: id="20201220214147-ssmeqkf"}

```
1   private void init(ThreadGroup g, Runnable target, String name,
2                      long stackSize) {
3        init(g, target, name, stackSize, null, true);
4   }
```
{: id="20201220214147-29eajrc"}

接下来看看所有构造方法：
{: id="20201220214147-q4pi6hb"}

1. {: id="20201220214147-94en0g3"}空构造方法
   {: id="20201220214147-829xvw6"}

   ```
   1    public Thread() {
   2        init(null, null, "Thread-" + nextThreadNum(), 0);
   3    }
   ```
   {: id="20201220214147-fyc9pqv"}

   内部调用的是`init`第二个重载方法，参数基本都是默认值，线程名称写死为`"Thread-" + nextThreadNum()`格式，`nextThreadNum()`为一个同步方法，内部维护一个静态属性表示线程的初始化数量+1：
   {: id="20201220214147-jzopo72"}

   ```
   1   private static int threadInitNumber;
   2    private static synchronized int nextThreadNum() {
   3        return threadInitNumber++;
   4    }
   ```
   {: id="20201220214147-o7erx1z"}

   与第一个构造方法区别在于可以自定义`Runnable`对象
   {: id="20201220214147-iixjqsi"}
2. {: id="20201220214147-5u5dul3"}自定义执行任务`Runnable`对象的构造方法
   {: id="20201220214147-9ym3z8e"}
   ```
    1    private static int threadInitNumber;
    2    private static synchronized int nextThreadNum() {
    3        return threadInitNumber++;
    4    }
   ```
   {: id="20201220214147-ojqxn67"}
3. {: id="20201220214147-pda9mb1"}自定义执行任务`Runnable`对象和`AccessControlContext`对象的构造方法
   {: id="20201220214147-ianowtw"}
   ```
   1 Thread(Runnable target, AccessControlContext acc) {
   2    init(null, target, "Thread-" + nextThreadNum(), 0, acc, false);
   3 }
   ```
   {: id="20201220214147-2d6ciaa"}
4. {: id="20201220214147-ywoitde"}自定义线程组`ThreadGroup`和执行任务`Runnable`对象的构造方法
   {: id="20201220214147-2sqtoky"}
   ```
   1  public Thread(ThreadGroup group, Runnable target) {
   2    init(group, target, "Thread-" + nextThreadNum(), 0);
   3  }
   ```
   {: id="20201220214147-0iaozce"}
5. {: id="20201220214147-hhauzva"}自定义线程名称`name`的构造方法
   {: id="20201220214147-scei78m"}
   ```
   1  public Thread(String name) {
   2    init(null, null, name, 0);
   3  }
   ```
   {: id="20201220214147-3f7ot4w"}
6. {: id="20201220214147-q22qivj"}自定义线程组`ThreadGroup`和线程名称`name`的构造方法
   {: id="20201220214147-1uz0h2q"}
   ```
   1  public Thread(String name) {
   2     init(null, null, name, 0);
   3  }
   ```
   {: id="20201220214147-8mnsmk0"}
7. {: id="20201220214147-t1qzg2r"}自定义执行任务`Runnable`对象和线程名称`name`的构造方法
   {: id="20201220214147-6tnfm8u"}
   ```
   1  public Thread(Runnable target, String name) {
   2     init(null, target, name, 0);
   3  }
   ```
   {: id="20201220214147-w3vn3ek"}
8. {: id="20201220214147-50mp1zb"}自定义线程组`ThreadGroup`和线程名称`name`和执行任务`Runnable`对象的构造方法
   {: id="20201220214147-u4kbc4v"}
   ```
   1  public Thread(ThreadGroup group, Runnable target, String name) {
   2     init(group, target, name, 0);
   3  }
   ```
   {: id="20201220214147-kkq9mly"}
9. {: id="20201220214147-vgxv9jj"}全部属性都是自定义的构造方法
   {: id="20201220214147-yqaz25l"}
   ```
   1  public Thread(ThreadGroup group, Runnable target, String name,
   2                long stackSize) {
   3     init(group, target, name, stackSize);
   4  }
   ```
   {: id="20201220214147-om0i3qj"}
{: id="20201220214147-ov4v0gy"}

`Thread`提供了非常灵活的重载构造方法，方便开发者自定义各种参数的`Thread`对象。
{: id="20201220214147-3ojp02w"}

常用方法
--------
{: id="20201220214147-kb17bg1"}

这里记录一些比较常见的方法吧，对于`Thread`中存在的一些本地方法，我们暂且不用管它～
{: id="20201220214147-51xbiv2"}

#### 设置线程名称
{: id="20201220214147-gm8gx4i"}

设置线程名称，该方法为同步方法，为了防止出现线程安全问题，可以手动调用`Thread`的实例方法设置名称，也可以在构造`Thread`时在构造方法中传入线程名称，我们通常都是在构造参数时设置
{: id="20201220214147-3wjwex4"}

```
	 1   public final synchronized void setName(String name) {
	 2       　　//检查安全权限
	 3          checkAccess();
	 4       　　//如果形参为空，抛出空指针异常
	 5          if (name == null) {
	 6              throw new NullPointerException("name cannot be null");
	 7          }
	 8        //给当前线程对象设置名称
	 9          this.name = name;
	10          if (threadStatus != 0) {
	11              setNativeName(name);
	12          }
	13      }
```
{: id="20201220214147-09npsvg"}

#### 获取线程名称
{: id="20201220214147-wx74bdo"}

内部直接返回当前线程对象的名称属性
{: id="20201220214147-215ovoz"}

```
	1  public final String getName() {
	2        return name;
	3    }
```
{: id="20201220214147-3ogp31b"}

#### 启动线程
{: id="20201220214147-8oh8o8k"}

```
	 1  public synchronized void start() {
	 2      //如果不是刚创建的线程，抛出异常
	 3      if (threadStatus != 0)
	 4          throw new IllegalThreadStateException();
	 5
	 6      //通知线程组，当前线程即将启动，线程组当前启动线程数+1，未启动线程数-1
	 7      group.add(this);
	 8
	 9      //启动标识
	10      boolean started = false;
	11      try {
	12          //直接调用本地方法启动线程
	13          start0();
	14          //设置启动标识为启动成功
	15          started = true;
	16      } finally {
	17          try {
	18              //如果启动呢失败
	19              if (!started) {
	20                  //线程组内部移除当前启动的线程数量-1，同时启动失败的线程数量+1
	21                  group.threadStartFailed(this);
	22              }
	23          } catch (Throwable ignore) {
	24              /* do nothing. If start0 threw a Throwable then
	25                it will be passed up the call stack */
	26          }
	27      }
	28  }
```
{: id="20201220214147-dbu2un6"}

我们正常的启动线程都是调用`Thread`的`start()`方法，然后`Java`虚拟机内部会去调用`Thred`的`run`方法，可以看到`Thread`类也是实现`Runnable`接口，重写了`run`方法的：
{: id="20201220214147-ru3l5gl"}

```
	1 @Override
	2 public void run() {
	3     //当前执行任务的Runnable对象不为空，则调用其run方法
	4     if (target != null) {
	5         target.run();
	6     }
	7 }
```
{: id="20201220214147-ngtq2hy"}

`Thread`的两种使用方式：
{: id="20201220214147-kt2jmia"}

* {: id="20201220214147-0jbq8xw"}继承`Thread`类，重写`run`方法，那么此时是直接执行`run`方法的逻辑，不会使用`target.run();`
  {: id="20201220214147-idffp4h"}
* {: id="20201220214147-deru4fm"}实现`Runnable`接口，重写`run`方法，因为`Java`的单继承限制，通常使用这种方式创建线程更加灵活，这里真正的执行逻辑就会交给自定义`Runnable`去实现
  {: id="20201220214147-ne7ibmz"}
{: id="20201220214147-lbo5fkl"}

#### 设置守护线程
{: id="20201220214147-2mh2x45"}

本质操作是设置`daemon`属性
{: id="20201220214147-c9toib0"}

```
	 1  public final void setDaemon(boolean on) {
	 2      //检查是否有安全权限
	 3      checkAccess();
	 4      //本地方法，测试此线程是否存活。, 如果一个线程已经启动并且尚未死亡，则该线程处于活动状态
	 5      if (isAlive()) {
	 6          //如果线程先启动后再设置守护线程，将抛出异常
	 7          throw new IllegalThreadStateException();
	 8      }
	 9      //设置当前守护线程属性
	10      daemon = on;
	11  }
```
{: id="20201220214147-1tbdeto"}

#### 判断线程是否为守护线程
{: id="20201220214147-xe5yfxj"}

```
	1 public final boolean isDaemon() {
	2     //直接返回当前对象的守护线程属性
	3     return daemon;
	4 }
```
{: id="20201220214147-b6s25tf"}

#### 线程状态
{: id="20201220214147-rars5jk"}

先来个线程状态图：
{: id="20201220214147-neu4m4z"}

![java_thread_source_1.png](./2019-01-21_java_thread_source/java_thread_source_1.png)
{: id="20201220214147-z33znva"}

获取线程状态：
{: id="20201220214147-heequwi"}

```
	1 public State getState() {
	2     //由虚拟机实现，获取当前线程的状态
	3     return sun.misc.VM.toThreadState(threadStatus);
	4 }
```
{: id="20201220214147-f1s4pcj"}

线程状态主要由内部枚举类`State`组成：
{: id="20201220214147-gbgl2f0"}

```
	 1  public enum State {
	 2
	 3     NEW,
	 4
	 5
	 6     RUNNABLE,
	 7
	 8
	 9     BLOCKED,
	10
	11
	12     WAITING,
	13
	14
	15     TIMED_WAITING,
	16
	17
	18     TERMINATED;
	19 }
```
{: id="20201220214147-q3iy1nt"}

* {: id="20201220214147-hpis15t"}NEW：刚刚创建，尚未启动的线程处于此状态
  {: id="20201220214147-oomoz1k"}
* {: id="20201220214147-zzvnvfj"}RUNNABLE：在Java虚拟机中执行的线程处于此状态
  {: id="20201220214147-ds506g4"}
* {: id="20201220214147-arbfogt"}BLOCKED：被阻塞等待监视器锁的线程处于此状态，比如线程在执行过程中遇到`synchronized`同步块，就会进入此状态，此时线程暂停执行，直到获得请求的锁
  {: id="20201220214147-t2x0fuo"}
* {: id="20201220214147-zy9mk78"}WAITING：无限期等待另一个线程执行特定操作的线程处于此状态
  {: id="20201220214147-cp2c77z"}
* {: id="20201220214147-2hwfqmc"}通过 wait() 方法等待的线程在等待 notify() 方法
  {: id="20201220214147-jbe3rhl"}
* {: id="20201220214147-j35091b"}通过 join() 方法等待的线程则会等待目标线程的终止
  {: id="20201220214147-8m17akq"}
* {: id="20201220214147-fxrt2wd"}TIMED_WAITING：正在等待另一个线程执行动作，直到指定等待时间的线程处于此状态
  {: id="20201220214147-lorketb"}
* {: id="20201220214147-tt56qct"}通过 wait() 方法，携带超时时间，等待的线程在等待 notify() 方法
  {: id="20201220214147-i9lf69i"}
* {: id="20201220214147-8i8tni4"}通过 join() 方法，携带超时时间，等待的线程则会等待目标线程的终止
  {: id="20201220214147-1txvmtr"}
* {: id="20201220214147-0ol57uy"}TERMINATED：已退出的线程处于此状态，此时线程无法再回到 RUNNABLE 状态
  {: id="20201220214147-c953i5m"}
{: id="20201220214147-qhzmfmg"}

#### 线程休眠
{: id="20201220214147-m3uh01s"}

这是一个静态的本地方法，使当前执行的线程休眠暂停执行 `millis` 毫秒，当休眠被中断时会抛出`InterruptedException`中断异常
{: id="20201220214147-xv5w0s1"}

```
	 1 /**
	 2  * Causes the currently executing thread to sleep (temporarily cease
	 3  * execution) for the specified number of milliseconds, subject to
	 4  * the precision and accuracy of system timers and schedulers. The thread
	 5  * does not lose ownership of any monitors.
	 6  *
	 7  * @param  millis
	 8  *         the length of time to sleep in milliseconds
	 9  *
	10  * @throws  IllegalArgumentException
	11  *          if the value of {@code millis} is negative
	12  *
	13  * @throws  InterruptedException
	14  *          if any thread has interrupted the current thread. The
	15  *          <i>interrupted status</i> of the current thread is
	16  *          cleared when this exception is thrown.
	17  */
	18 public static native void sleep(long millis) throws InterruptedException;
```
{: id="20201220214147-lj0natr"}

#### 检查线程是否存活
{: id="20201220214147-e1c3ry2"}

本地方法，测试此线程是否存活。 如果一个线程已经启动并且尚未死亡，则该线程处于活动状态。
{: id="20201220214147-80y0svh"}

```
	1  /**
	2   * Tests if this thread is alive. A thread is alive if it has
	3   * been started and has not yet died.
	4   *
	5   * @return  <code>true</code> if this thread is alive;
	6   *          <code>false</code> otherwise.
	7   */
	8  public final native boolean isAlive();
```
{: id="20201220214147-r7x4l08"}

#### 线程优先级
{: id="20201220214147-i934u9a"}

* {: id="20201220214147-g9pb78m"}设置线程优先级
  {: id="20201220214147-2vs54mr"}

  ```
   1  /**
   2   * Changes the priority of this thread.
   3   * <p>
   4   * First the <code>checkAccess</code> method of this thread is called
   5   * with no arguments. This may result in throwing a
   6   * <code>SecurityException</code>.
   7   * <p>
   8   * Otherwise, the priority of this thread is set to the smaller of
   9   * the specified <code>newPriority</code> and the maximum permitted
  10   * priority of the thread's thread group.
  11   *
  12   * @param newPriority priority to set this thread to
  13   * @exception  IllegalArgumentException  If the priority is not in the
  14   *               range <code>MIN_PRIORITY</code> to
  15   *               <code>MAX_PRIORITY</code>.
  16   * @exception  SecurityException  if the current thread cannot modify
  17   *               this thread.
  18   * @see        #getPriority
  19   * @see        #checkAccess()
  20   * @see        #getThreadGroup()
  21   * @see        #MAX_PRIORITY
  22   * @see        #MIN_PRIORITY
  23   * @see        ThreadGroup#getMaxPriority()
  24   */
  25  public final void setPriority(int newPriority) {
  26      //线程组
  27      ThreadGroup g;
  28      //检查安全权限
  29      checkAccess();
  30      //检查优先级形参范围
  31      if (newPriority > MAX_PRIORITY || newPriority < MIN_PRIORITY) {
  32          throw new IllegalArgumentException();
  33      }
  34      if((g = getThreadGroup()) != null) {
  35          //如果优先级形参大于线程组最大线程最大优先级
  36          if (newPriority > g.getMaxPriority()) {
  37              //则使用线程组的优先级数据
  38              newPriority = g.getMaxPriority();
  39          }
  40          //调用本地设置线程优先级方法
  41          setPriority0(priority = newPriority);
  42      }
  43  }
  ```
  {: id="20201220214147-yfolep0"}
{: id="20201220214147-up8l405"}

#### 线程中断
{: id="20201220214147-3ub4yio"}

有一个`stop()`实例方法可以强制终止线程，不过这个方法因为太过于暴力，已经被标记为过时方法，不建议程序员再使用，因为**强制终止线程**会导致数据不一致的问题。
{: id="20201220214147-f8zj7i8"}

这里关于线程中断的方法涉及三个：
{: id="20201220214147-g6hb1ae"}

```
	1 //实例方法，通知线程中断，设置标志位
	2 public void interrupt(){}
	3 //静态方法，检查当前线程的中断状态，同时会清除当前线程的中断标志位状态
	4 public static boolean interrupted(){}
	5 //实例方法，检查当前线程是否被中断，其实是检查中断标志位
	6 public boolean isInterrupted(){}
```
{: id="20201220214147-ie77llj"}

**interrupt() 方法解析**
{: id="20201220214147-twv3skm"}

```
	 1  /**
	 2   * Interrupts this thread.
	 3   *
	 4   * <p> Unless the current thread is interrupting itself, which is
	 5   * always permitted, the {@link #checkAccess() checkAccess} method
	 6   * of this thread is invoked, which may cause a {@link
	 7   * SecurityException} to be thrown.
	 8   *
	 9   * <p> If this thread is blocked in an invocation of the {@link
	10   * Object#wait() wait()}, {@link Object#wait(long) wait(long)}, or {@link
	11   * Object#wait(long, int) wait(long, int)} methods of the {@link Object}
	12   * class, or of the {@link #join()}, {@link #join(long)}, {@link
	13   * #join(long, int)}, {@link #sleep(long)}, or {@link #sleep(long, int)},
	14   * methods of this class, then its interrupt status will be cleared and it
	15   * will receive an {@link InterruptedException}.
	16   *
	17   * <p> If this thread is blocked in an I/O operation upon an {@link
	18   * java.nio.channels.InterruptibleChannel InterruptibleChannel}
	19   * then the channel will be closed, the thread's interrupt
	20   * status will be set, and the thread will receive a {@link
	21   * java.nio.channels.ClosedByInterruptException}.
	22   *
	23   * <p> If this thread is blocked in a {@link java.nio.channels.Selector}
	24   * then the thread's interrupt status will be set and it will return
	25   * immediately from the selection operation, possibly with a non-zero
	26   * value, just as if the selector's {@link
	27   * java.nio.channels.Selector#wakeup wakeup} method were invoked.
	28   *
	29   * <p> If none of the previous conditions hold then this thread's interrupt
	30   * status will be set. </p>
	31   *
	32   * <p> Interrupting a thread that is not alive need not have any effect.
	33   *
	34   * @throws  SecurityException
	35   *          if the current thread cannot modify this thread
	36   *
	37   * @revised 6.0
	38   * @spec JSR-51
	39   */
	40  public void interrupt() {
	41      //检查是否是自身调用
	42      if (this != Thread.currentThread())
	43          //检查安全权限,这可能导致抛出{@link * SecurityException}。
	44          checkAccess();
	45
	46      //同步代码块
	47      synchronized (blockerLock) {
	48          Interruptible b = blocker;
	49          //检查是否是阻塞线程调用
	50          if (b != null) {
	51              //设置线程中断标志位
	52              interrupt0(); 
	53              //此时抛出异常，将中断标志位设置为false,此时我们正常会捕获该异常，重新设置中断标志位
	54              b.interrupt(this);
	55              return;
	56          }
	57      }
	58      //如无意外，则正常设置中断标志位
	59      interrupt0();
	60  }
```
{: id="20201220214147-suo133n"}

* {: id="20201220214147-71ec3sp"}线程中断方法不会使线程立即退出，而是给线程发送一个通知，告知目标线程，有人希望你退出啦～
  {: id="20201220214147-i37als1"}
* {: id="20201220214147-opbqgz3"}只能由自身调用，否则可能会抛出 `SecurityException`
  {: id="20201220214147-478m89p"}
* {: id="20201220214147-a7ou9xx"}调用中断方法是由目标线程自己决定是否中断，而如果同时调用了`wait`,`join`,`sleep`等方法，会使当前线程进入阻塞状态，此时有可能发生`InterruptedException`异常
  {: id="20201220214147-i8zgxot"}
* {: id="20201220214147-j85tb8g"}被阻塞的线程再调用中断方法是不合理的
  {: id="20201220214147-txldr6z"}
* {: id="20201220214147-9fp554i"}中断不活动的线程不会产生任何影响
  {: id="20201220214147-fm8ta85"}
{: id="20201220214147-5rhi5vs"}

检查线程是否被中断:
{: id="20201220214147-44n7isb"}

```
	 1  /**
	 2   * Tests whether this thread has been interrupted.  The <i>interrupted
	 3   * status</i> of the thread is unaffected by this method.
	 4
	 5   测试此线程是否已被中断。, 线程的<i>中断*状态</ i>不受此方法的影响。
	 6   *
	 7   * <p>A thread interruption ignored because a thread was not alive
	 8   * at the time of the interrupt will be reflected by this method
	 9   * returning false.
	10   *
	11   * @return  <code>true</code> if this thread has been interrupted;
	12   *          <code>false</code> otherwise.
	13   * @see     #interrupted()
	14   * @revised 6.0
	15   */
	16  public boolean isInterrupted() {
	17      return isInterrupted(false);
	18  }
```
{: id="20201220214147-czx5a25"}

静态方法,会清空当前线程的中断标志位：
{: id="20201220214147-in31cu1"}

```
	 1   /**
	 2     *测试当前线程是否已被中断。, 此方法清除线程的* <i>中断状态</ i>。, 换句话说，如果要连续两次调用此方法，则* second调用将返回false（除非当前线程再次被中断，在第一次调用已清除其中断的*状态   之后且在第二次调用已检查之前）, 它）
	 3     *
	 4     * <p>A thread interruption ignored because a thread was not alive
	 5     * at the time of the interrupt will be reflected by this method
	 6     * returning false.
	 7     *
	 8     * @return  <code>true</code> if the current thread has been interrupted;
	 9     *          <code>false</code> otherwise.
	10     * @see #isInterrupted()
	11     * @revised 6.0
	12     */
	13    public static boolean interrupted() {
	14        return currentThread().isInterrupted(true);
	15    }
```
{: id="20201220214147-cw4k6h0"}

总结
----
{: id="20201220214147-oq69nhs"}

记录自己阅读`Thread`类源码的一些思考，不过对于其中用到的很多本地方法只能望而却步，还有一些代码没有看明白，暂且先这样吧，如果有不足之处，请留言告知我，谢谢！后续会在实践中对`Thread`做出更多总结记录。
{: id="20201220214147-uzd1irl"}


{: id="20201220214147-jzyafuo" type="doc"}
