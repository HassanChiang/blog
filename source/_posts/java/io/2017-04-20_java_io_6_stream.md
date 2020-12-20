---

title: Java IO(6) InputStream和OutputStream
date: 2017-04-20
description:
{: id="20201220214147-nhlkncg"}

tags:
{: id="20201220214147-afqs5pf"}

- {: id="20201220214147-4thvxzn"}Stream
- {: id="20201220214147-0nrhn5r"}IO
- {: id="20201220214147-gycky9o"}Java
{: id="20201220214147-aub5cfs"}

nav:
{: id="20201220214147-thh0ezb"}

- {: id="20201220214147-nmpbmor"}Java
{: id="20201220214147-i6zz284"}

categories:
{: id="20201220214147-jlfwoxl"}

- {: id="20201220214147-pj1c5h3"}Java IO
{: id="20201220214147-rotzspc"}

image: images/java/io.png
{: id="20201220214147-nrt4baj"}

---

# InputStream
{: id="20201220214147-us5527y"}

例子：
{: id="20201220214147-8muu2tx"}

```
InputStream inputstream = new FileInputStream("c:\\data\\input-text.txt");

int data = inputstream.read();
while(data != -1) {
  //do something with data...
  doSomethingWithData(data);

  data = inputstream.read();
}
inputstream.close();
```
{: id="20201220214147-0mkjky6"}

Java7  try-with-resources 写法：
{: id="20201220214147-cg5gzna"}

```
try( InputStream inputstream = new FileInputStream("file.txt") ) {
    int data = inputstream.read();
    while(data != -1){
        System.out.print((char) data);
        data = inputstream.read();
    }
}
```
{: id="20201220214147-gflx8rr"}

### read()
{: id="20201220214147-t0mjsmz"}

返回 int类型，一个字节值。返回 -1 表示没有读取到字节值，流结束。如下：
{: id="20201220214147-54ciohd"}

```
int data = inputstream.read();
```
{: id="20201220214147-mcad73u"}

字节可以转为字符，像这样：
{: id="20201220214147-cgyfgkp"}

```
 char aChar = (char) data;
```
{: id="20201220214147-ongkb3r"}

有些子类实现了可以替代read的方法，比如：DataInputStream ，你可以通过调用：readBoolean() 、 readDouble()…… 来直接读取Java的基础类型数据，而无需读取原生的字节码。
{: id="20201220214147-ydzfawk"}

### read(byte[])
{: id="20201220214147-cn31nku"}

两个方法：
{: id="20201220214147-qe9dfpa"}

> int read(byte[])
> int read(byte[], int offset, int length)
> {: id="20201220214147-8mu29d8"}
{: id="20201220214147-ogxhlo7"}

通过读到数组的方式来替代 read()，效率会更高。
这两个方法返回读取到的字节个数，同样，返回-1表示结束，没有读取到字节。
{: id="20201220214147-cce2ffp"}

read(byte[]) 这个方法会尝试尽可能多的读取byte[]长度的字节个数，放入其中。每次读取数据，从数组的0处开始填充，直到没有数据或数组被填满。
{: id="20201220214147-g9mbjb7"}

如果未读满数组，其剩余空间将存储上一次读取的数据。所以在循环读取的时，要注意最后一次读取的内容长度，做响应的截取处理。
{: id="20201220214147-1evpqjz"}

read(byte[], int offset, int length)这个方法功能类型，只不过每次都指定了读取的数据从数组的offset开始填充，最多填充length个字节数。注意数组越界异常。
{: id="20201220214147-u0tt02v"}

### mark() 和 reset()
{: id="20201220214147-991214g"}

mark()和 reset() 需要配合使用，mark()做标记，reset() 被调用后，再次read，流将从上次mark()的位置来算重新读取流数据。功能常于解析流数据。
{: id="20201220214147-raonbid"}

这个接口需要子类实现，如果子类实现了这个功能，需要重写 markSupported() 方法，返回true；否则返回false。
{: id="20201220214147-lkm9ds4"}

# OutputStream
{: id="20201220214147-9nd00nr"}

### write(byte)
{: id="20201220214147-n7hruew"}

例子：
{: id="20201220214147-x5byict"}

```
OutputStream output = new FileOutputStream("c:\\data\\output-text.txt");
while(hasMoreData()) {
  int data = getMoreData();
  output.write(data);
}
output.close();
```
{: id="20201220214147-tkb748o"}

## write(byte[])
{: id="20201220214147-ogd8fsx"}

> write(byte[] bytes)
> write(byte[] bytes, int offset, int length)
> {: id="20201220214147-pgw435l"}
{: id="20201220214147-eatn6mj"}

与read参数一致。
{: id="20201220214147-5dkvb9p"}

### flush()
{: id="20201220214147-qgvlwpx"}

OutputStream调用write写的数据，可能未写入磁盘，调用该方法，将已经写入到OutputStream的数据刷新到磁盘中。
{: id="20201220214147-9hdtb5n"}

### close()
{: id="20201220214147-srrkhez"}

例子：
{: id="20201220214147-v0ianox"}

```
OutputStream output = null;

try{
  output = new FileOutputStream("c:\\data\\output-text.txt");

  while(hasMoreData()) {
    int data = getMoreData();
    output.write(data);
  }
} finally {
    if(output != null) {
        output.close();
    }
}
```
{: id="20201220214147-zuojdls"}

异常处理：http://tech.fenxiangz.com/topic/55/java-io-5-%E5%BC%82%E5%B8%B8%E5%A4%84%E7%90%86
{: id="20201220214147-ydv5n6l"}


{: id="20201220214147-z3nixez" type="doc"}
