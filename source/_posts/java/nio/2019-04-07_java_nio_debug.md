---

title: Java NIO客户端主动关闭连接，导致服务器空轮询
date: 2019-04-07
description:
{: id="20201220214147-ifx6gxx"}

tags:
{: id="20201220214147-yzlyxxa"}

- {: id="20201220214147-hrg2pwf"}问题
- {: id="20201220214147-qvjcr68"}NIO
- {: id="20201220214147-r1w8g9q"}Java
{: id="20201220214147-skdky3s"}

nav:
{: id="20201220214147-47kk83u"}

- {: id="20201220214147-4rcrcps"}Java
{: id="20201220214147-iipmw49"}

categories:
{: id="20201220214147-q979x82"}

- {: id="20201220214147-4xa4tll"}Java NIO
{: id="20201220214147-ze24yfh"}

image: images/java/io.png
{: id="20201220214147-ky50q3n"}

---

当客户端连接关闭时，服务器select()不会阻塞，然后一直分发读就绪操作，且读到的字节长度都是0，这是什么情况。
{: id="20201220214147-ak1dkxh"}

服务器代码:
{: id="20201220214147-da6gvv8"}

```
try {
    ServerSocketChannel serverChannel = ServerSocketChannel.open();
    serverChannel.bind(new InetSocketAddress(666));
    serverChannel.configureBlocking(false);
    Selector selector = Selector.open();
    serverChannel.register(selector, SelectionKey.OP_ACCEPT);
    while (true) {
        int count = selector.select(); //阻塞
        if (count > 0) {
            Set<SelectionKey> keys = selector.selectedKeys();
            Iterator<SelectionKey> iterator = keys.iterator();
            while (iterator.hasNext()) {
                SelectionKey key = iterator.next();
                iterator.remove();
                if (key.isAcceptable()) {
                    System.out.println("client connect");
                    ServerSocketChannel serverSocketChannel = (ServerSocketChannel) key.channel();
                    SocketChannel sc = serverSocketChannel.accept();
                    sc.configureBlocking(false);
                    sc.register(selector, SelectionKey.OP_READ);
                }
                if (key.isReadable()) {
                    SocketChannel socketChannel = (SocketChannel) key.channel();
                    ByteBuffer buffer = ByteBuffer.allocate(512);
                    socketChannel.read(buffer);
                    buffer.flip();
                    System.out.println("on read size:" + buffer.remaining());
                }
            }
        }
    }
} catch (IOException e) {
    e.printStackTrace();
}
```
{: id="20201220214147-u4r46j2"}

客户端代码：
{: id="20201220214147-at84u17"}

```
public class NIOClientTest{
    public static void main(String[] args) throws UnknownHostException, IOException{
        try {
            Socket socket = new Socket("127.0.0.1",666);
            try(OutputStreamWriter output = new OutputStreamWriter(socket.getOutputStream());){
                output.write(1);
                output.flush();
            }catch (Exception e) {
                e.printStackTrace();
            }
            socket.close();
        } catch (Exception e1) {
            e1.printStackTrace();
        }
    }
}
```
{: id="20201220214147-mtlvatq"}

解决：
{: id="20201220214147-wb016ys"}

---

当客户端主动切断连接的时候，服务端 Socket 的读事件（FD_READ）仍然起作用，也就是说，服务端 Socket 的状态仍然是有东西可读，当然此时读出来的字节肯定是 0。
{: id="20201220214147-ty30q2u"}

socketChannel.read(buffer) 是有返回值的，这种情况下返回值是 -1，所以如果 read 方法返回的是 -1，就可以关闭和这个客户端的连接了。
{: id="20201220214147-qtssdc1"}

SocketChannel.read 的返回值：
![](./2019-04-07_java_nio_debug/1.png)
{: id="20201220214147-neb3uqc"}

这种情况也有可能会抛出 IOException，需要捕获异常并判断。
{: id="20201220214147-j8f31pb"}

---

nio的客户端如果关闭了，服务端还是会收到该channel的读事件，但是数目为0，而且会读到-1，其实-1在网络io中就是socket关闭的含义，在文件时末尾的含义，所以为了避免客户端关闭服务端一直收到读事件，必须检测上一次的读是不是-1，如果是-1，就关闭这个channel。
{: id="20201220214147-ut1puc7"}

```
ByteBuffer buffer = ByteBuffer.allocate(100);
SocketChannel sc = (SocketChannel) key.channel();
StringBuffer buf = new StringBuffer();
int c = 0;
while ((c = sc.read(buffer)) > 0) {
    buf.append(new String(buffer.array()));
}
if (c == -1) {
    System.out.println("断开");
    sc.close();
}
String msg = buf.toString();
System.out.println(msg);
```
{: id="20201220214147-36m32y1"}

---

---


{: id="20201220214147-99cqs4z" type="doc"}
