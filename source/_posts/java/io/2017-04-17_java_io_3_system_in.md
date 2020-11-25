----
title: Java IO(3)  System.in , System.out,  and System.error
date: 2017-04-17
description: 

tags:
- IO
- Java

nav:
- Java

categories:
- Java IO

image: images/java/io.png

----
 System.out, System.in 和 System.err 在源码里的定义是：

    public final static InputStream in = null;
    public final static PrintStream out = null;
    public final static PrintStream err = null;

System. in 用于控制台标准输入；
System.out 用于控制台标准输出；
System.error 用于控制台标准错误输出（有些 IDE 执行程序时，会显示红色字体，比如 Eclipse）。

System.out + System.err 使用例子:

	try {
	  InputStream input = new FileInputStream("c:\\data\\...");
	  System.out.println("File opened...");

	} catch (IOException e){
	  System.err.println("File opening failed:");
	  e.printStackTrace();
	}

System. in , System.out,  and System.error 可以使用  System.setIn(), System.setOut() 或 System.setErr() 改变标准输出，比如：

    OutputStream output = new FileOutputStream("c:\\data\\system.out.txt");
    PrintStream printOut = new PrintStream(output);
    System.setOut(printOut);

这样，System.out 将输出到指定的文件。

注意：
in， out 和 error 使用了 final 修饰，所以像 “System.out = myOut” 这样直接赋值是编译不通过的，但是可以通过 setXXX 重新赋值是因为 System 里面的 setXXX 是通过 native 方法实现的，具体可以参考源码以及链接：http://stackoverflow.com/questions/5951464/java-final-system-out-system-in-and-system-err 。