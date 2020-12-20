----
title: Java7 里 try-with-resources 分析
date: 2016-11-28 07:59:24
description: 

tags:
- 异常
- Java异常
- Java

nav:
- Java

categories:
-  Java 基础

image: images/java/basic/java_logo.png

----
这个所谓的 try-with-resources，是个语法糖。实际上就是自动调用资源的 close() 函数。

例如：
```
static String readFirstLineFromFile(String path) throws IOException {  
    try (BufferedReader br = new BufferedReader(new FileReader(path))) {  
        return br.readLine();  
    }  
}  
```
可以看到 try 语句多了个括号，而在括号里初始化了一个 BufferedReader。
这种在 try 后面加个括号，再初始化对象的语法就叫 try-with-resources。
实际上，相当于下面的代码（其实略有不同，下面会说明）：
```
static String readFirstLineFromFileWithFinallyBlock(String path) throws IOException {  
    BufferedReader br = new BufferedReader(new FileReader(path));  
    try {  
        return br.readLine();  
    } finally {  
        if (br != null) br.close();  
    }  
}  
```

很容易可以猜想到，这是编绎器自动在 try-with-resources 后面增加了判断对象是否为 null，如果不为 null，则调用 close() 函数的的字节码。

只有实现了 java.lang.AutoCloseable 接口，或者 java.io.Closable（实际上继随自 java.lang.AutoCloseable）接口的对象，才会自动调用其 close() 函数。
有点不同的是 Java.io.Closable 要求一实现者保证 close 函数可以被重复调用。而 AutoCloseable 的 close() 函数则不要求是幂等的。具体可以参考 Javadoc。

下面从编绎器生成的字节码来分析下，try-with-resources 到底是怎样工作的：
```
public class TryStudy implements AutoCloseable{  
    static void test() throws Exception {  
        try(TryStudy tryStudy = new TryStudy()){  
            System.out.println(tryStudy);  
        }  
    }  
    @Override  
    public void close() throws Exception {  
    }  
}  
```
TryStudy 实现了 AutoCloseable 接口，下面来看下 test 函数的字节码：

```
static test()V throws java/lang/Exception   
  TRYCATCHBLOCK L0 L1 L2   
  TRYCATCHBLOCK L3 L4 L4   
 L5  
  LINENUMBER 21 L5  
  ACONST_NULL  
  ASTORE 0  
  ACONST_NULL  
  ASTORE 1  
 L3  
  NEW TryStudy  
  DUP  
  INVOKESPECIAL TryStudy.<init> ()V  
  ASTORE 2  
 L0  
  LINENUMBER 22 L0  
  GETSTATIC java/lang/System.out : Ljava/io/PrintStream;  
  ALOAD 2  
  INVOKEVIRTUAL java/io/PrintStream.println (Ljava/lang/Object;)V  
 L1  
  LINENUMBER 23 L1  
  ALOAD 2  
  IFNULL L6  
  ALOAD 2  
  INVOKEVIRTUAL TryStudy.close ()V  
  GOTO L6  
 L2  
 FRAME FULL [java/lang/Throwable java/lang/Throwable TryStudy] [java/lang/Throwable]  
  ASTORE 0  
  ALOAD 2  
  IFNULL L7  
  ALOAD 2  
  INVOKEVIRTUAL TryStudy.close ()V  
 L7  
 FRAME CHOP 1  
  ALOAD 0  
  ATHROW  
 L4  
 FRAME SAME1 java/lang/Throwable  
  ASTORE 1  
  ALOAD 0  
  IFNONNULL L8  
  ALOAD 1  
  ASTORE 0  
  GOTO L9  
 L8  
 FRAME SAME  
  ALOAD 0  
  ALOAD 1  
  IF_ACMPEQ L9  
  ALOAD 0  
  ALOAD 1  
  INVOKEVIRTUAL java/lang/Throwable.addSuppressed (Ljava/lang/Throwable;)V  
 L9  
 FRAME SAME  
  ALOAD 0  
  ATHROW  
 L6  
  LINENUMBER 24 L6  
 FRAME CHOP 2  
  RETURN  
  LOCALVARIABLE tryStudy LTryStudy; L0 L7 2  
  MAXSTACK = 2  
  MAXLOCALS = 3 
```
从字节码里可以看出，的确是有判断 tryStudy 对象是否为 null，如果不是 null，则调用 close 函数进行资源回收。
再仔细分析，可以发现有一个 Throwable.addSuppressed 的调用，那么这个调用是什么呢？
其实，上面的字节码大概是这个样子的（当然，不完全是这样的，因为汇编的各种灵活的跳转用 Java 是表达不出来的）：
```
static void test() throws Exception {  
    TryStudy tryStudy = null;  
    try{  
        tryStudy = new TryStudy();  
        System.out.println(tryStudy);  
    }catch(Throwable suppressedException) {  
        if (tryStudy != null) {  
            try {  
                tryStudy.close();  
            }catch(Throwable e) {  
                e.addSuppressed(suppressedException);  
                throw e;  
            }  
        }  
        throw suppressedException;  
    }  
}  
```
有点晕是吧，其实很简单。使用了 try-with-resources 语句之后，有可能会出现两个异常，一个是 try 块里的异常，一个是调用 close 函数里抛出的异常。
当然，平时我们写代码时，没有关注到。一般都是再抛出 close 函数里的异常，前面的异常被丢弃了。
如果在调用 close 函数时出现异常，那么前面的异常就被称为 Suppressed Exceptions，因此 Throwable 还有个 addSuppressed 函数可以把它们保存起来，当用户捕捉到 close 里抛出的异常时，就可以调用 Throwable.getSuppressed 函数来取出 close 之前的异常了。

总结：
使用 try-with-resources 的语法可以实现资源的自动回收处理，大大提高了代码的便利性，和 mutil catch 一样，是个好东东。
用编绎器生成的字节码的角度来看，try-with-resources 语法更加高效点。
java.io.Closable 接口要求一实现者保证 close 函数可以被重复调用，而 AutoCloseable 的 close() 函数则不要求是幂等的。
参考：
http://docs.oracle.com/javase/tutorial/essential/exceptions/tryResourceClose.html
http://docs.oracle.com/javase/7/docs/api/java/lang/AutoCloseable.html
http://docs.oracle.com/javase/7/docs/api/java/io/Closeable.html

原文
http://blog.csdn.net/hengyunabc/article/details/18459463