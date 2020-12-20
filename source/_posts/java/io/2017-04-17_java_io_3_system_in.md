---

title: Java IO(3)  System.in , System.out,  and System.error
date: 2017-04-17
description:
{: id="20201220214147-oqqtumr"}

tags:
{: id="20201220214147-r1czu2c"}

- {: id="20201220214147-8jsfrr1"}IO
- {: id="20201220214147-mns6sd0"}Java
{: id="20201220214147-fbvefe0"}

nav:
{: id="20201220214147-22fuatw"}

- {: id="20201220214147-g4m965i"}Java
{: id="20201220214147-8awkr74"}

categories:
{: id="20201220214147-lculvxd"}

- {: id="20201220214147-e55rpus"}Java IO
{: id="20201220214147-60ori70"}

image: images/java/io.png
{: id="20201220214147-m4gh4dp"}

---

System.out, System.in 和 System.err 在源码里的定义是：
{: id="20201220214147-gwisjxr"}

```
public final static InputStream in = null;
public final static PrintStream out = null;
public final static PrintStream err = null;
```
{: id="20201220214147-bzrunre"}

System. in 用于控制台标准输入；
System.out 用于控制台标准输出；
System.error 用于控制台标准错误输出（有些 IDE 执行程序时，会显示红色字体，比如 Eclipse）。
{: id="20201220214147-vsal30v"}

System.out + System.err 使用例子:
{: id="20201220214147-5u0ux8z"}

```
try {
  InputStream input = new FileInputStream("c:\\data\\...");
  System.out.println("File opened...");

} catch (IOException e){
  System.err.println("File opening failed:");
  e.printStackTrace();
}
```
{: id="20201220214147-r3rric0"}

System. in , System.out,  and System.error 可以使用  System.setIn(), System.setOut() 或 System.setErr() 改变标准输出，比如：
{: id="20201220214147-3nsi3lz"}

```
OutputStream output = new FileOutputStream("c:\\data\\system.out.txt");
PrintStream printOut = new PrintStream(output);
System.setOut(printOut);
```
{: id="20201220214147-mxai1mc"}

这样，System.out 将输出到指定的文件。
{: id="20201220214147-jglqp2r"}

注意：
in， out 和 error 使用了 final 修饰，所以像 “System.out = myOut” 这样直接赋值是编译不通过的，但是可以通过 setXXX 重新赋值是因为 System 里面的 setXXX 是通过 native 方法实现的，具体可以参考源码以及链接：http://stackoverflow.com/questions/5951464/java-final-system-out-system-in-and-system-err 。
{: id="20201220214147-aj2d4oh"}


{: id="20201220214147-y5y2whp" type="doc"}
