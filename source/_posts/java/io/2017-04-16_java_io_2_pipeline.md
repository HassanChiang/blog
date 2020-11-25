----
title: Java IO(2) 管道流
date: 2017-04-16
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
Demo:

	import java.io.IOException;
	import java.io.PipedInputStream;
	import java.io.PipedOutputStream;

	public class PipeExample {
	    public static void main(String[] args) throws IOException {
	        final PipedOutputStream output = new PipedOutputStream();
	        final PipedInputStream  input  = new PipedInputStream(output);
	        Thread thread1 = new Thread(new Runnable() {
	            @Override
	            public void run() {
	                try {
	                    output.write("Hello world, pipe!".getBytes());
	                } catch (IOException e) {
	                }
	            }
	        });
	        Thread thread2 = new Thread(new Runnable() {
	            @Override
	            public void run() {
	                try {
	                    int data = input.read();
	                    while(data != -1){
	                        System.out.print((char) data);
	                        data = input.read();
	                    }
	                } catch (IOException e) {
	                }
	            }
	        });
	        thread1.start();
	        thread2.start();
	    }
	}

 PipedOutputStream 和 PipedInputStream ，用于两个线程间通信。可以将管道输出流连接到管道输入流来创建通信管道。管道输出流是管道的发送端。通常，数据由某个线程写入 PipedOutputStream 对象，并由其他线程从连接的 PipedInputStream 读取。不建议对这两个对象尝试使用单个线程，因为这样**可能会造成该线程死锁**。如果某个线程正从连接的管道输入流中读取数据字节，但该线程不再处于活动状态，则该管道被视为处于 **毁坏** 状态。

PipedInputStream 和 PipedOutputStream 都有一个方法 connect()，用于连接另一个输入或输出管道，如果连接一个已连接（connected）的管道流，connect() 将抛出异常：java.io.IOException: Already connected。

PipedInputStream 中实际是用了一个1024字节固定大小的循环缓冲区。写入PipedOutputStream 的数据实际上保存到对应的 PipedInputStream 的内部缓冲区。从 PipedInputStream 执行读操作时，读取的数据实际上来自这个内部缓冲区。如果对应的 PipedInputStream 输入缓冲区已满，任何企图写入 PipedOutputStream 的线程都将被阻塞。而且这个写操作线程将一直阻塞，直至出现读取 PipedInputStream 的操作从缓冲区删除数据。这也就是说往 PipedOutputStream 写数据的线程Send若是和从 PipedInputStream 读数据的线程 Receive 是同一个线程的话，那么一旦Send线程发送数据过多（大于 1024 字节），它就会被阻塞，这就直接导致接受数据的线程阻塞而无法工作（因为是同一个线程嘛），那么这就是一个典型的死锁现象，这也就是为什么 javadoc 中关于这两个类的使用时告诉大家要在不同线程环境下使用的原因了。

同一个 JVM 中，除了管道，还有很多其他的方式用于线程之间数据交换，通常会使用一个对象来进行数据交换。但是，如果需要使用字节数据在线程之间进行交换，使用管道的方式提供了这种可能。