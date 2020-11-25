----
title: Java IO(6) InputStream和OutputStream
date: 2017-04-20
description: 

tags:
- Stream
- IO
- Java

nav:
- Java

categories:
- Java IO

image: images/java/basic/java_logo.png

----
# InputStream 
例子：

    InputStream inputstream = new FileInputStream("c:\\data\\input-text.txt");

    int data = inputstream.read();
    while(data != -1) {
      //do something with data...
      doSomethingWithData(data);

      data = inputstream.read();
    }
    inputstream.close();

Java7  try-with-resources 写法：

    try( InputStream inputstream = new FileInputStream("file.txt") ) {
        int data = inputstream.read();
        while(data != -1){
            System.out.print((char) data);
            data = inputstream.read();
        }
    }

### read()

返回 int类型，一个字节值。返回 -1 表示没有读取到字节值，流结束。如下：

    int data = inputstream.read();

字节可以转为字符，像这样：

     char aChar = (char) data;

有些子类实现了可以替代read的方法，比如：DataInputStream ，你可以通过调用：readBoolean() 、 readDouble()…… 来直接读取Java的基础类型数据，而无需读取原生的字节码。

### read(byte[])

两个方法：
> int read(byte[])
int read(byte[], int offset, int length)

通过读到数组的方式来替代 read()，效率会更高。
这两个方法返回读取到的字节个数，同样，返回-1表示结束，没有读取到字节。

read(byte[]) 这个方法会尝试尽可能多的读取byte[]长度的字节个数，放入其中。每次读取数据，从数组的0处开始填充，直到没有数据或数组被填满。

如果未读满数组，其剩余空间将存储上一次读取的数据。所以在循环读取的时，要注意最后一次读取的内容长度，做响应的截取处理。

read(byte[], int offset, int length)这个方法功能类型，只不过每次都指定了读取的数据从数组的offset开始填充，最多填充length个字节数。注意数组越界异常。

### mark() 和 reset()

mark()和 reset() 需要配合使用，mark()做标记，reset() 被调用后，再次read，流将从上次mark()的位置来算重新读取流数据。功能常于解析流数据。

这个接口需要子类实现，如果子类实现了这个功能，需要重写 markSupported() 方法，返回true；否则返回false。


# OutputStream

### write(byte)

例子：

    OutputStream output = new FileOutputStream("c:\\data\\output-text.txt");
    while(hasMoreData()) {
      int data = getMoreData();
      output.write(data);
    }
    output.close();

## write(byte[])


> write(byte[] bytes)
write(byte[] bytes, int offset, int length)

与read参数一致。

### flush()

OutputStream调用write写的数据，可能未写入磁盘，调用该方法，将已经写入到OutputStream的数据刷新到磁盘中。

### close()

例子：

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


异常处理：http://tech.fenxiangz.com/topic/55/java-io-5-%E5%BC%82%E5%B8%B8%E5%A4%84%E7%90%86