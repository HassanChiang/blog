----
title: TCP协议中的seq/ack序号是如何变化的？
date: 2017-12-13
description: 

tags:
- 网络术语
- 概念

nav:
- 计算机网络

categories:
- TCP/IP

image: images/linux.png

----
这里提供了截取出来的一次client端和server端TCP包的交互过程。建议将图单独放到一台设备、或者打印出来查看，以便不断核对下述内容。

![](2017-12-14_TCP协议中的seq_ack序号是如何变化的？/1.png) 

图：TCP数据包交换过程

再开始分析之前，还需要论述一下seq、ack表示什么意思，应该以什么样的角度去理解这两个序列号。

- **sequence number**：表示的是我方（发送方）这边，这个packet的数据部分的第一位应该在整个data stream中所在的位置。（注意这里使用的是“应该”。因为对于没有数据的传输，如ACK，虽然它有一个seq，但是这次传输在整个data stream中是不占位置的。所以下一个实际有数据的传输，会依旧从上一次发送ACK的数据包的seq开始）
- **acknowledge number**：表示的是期望的对方（接收方）的下一次sequence number是多少。
- 注意，SYN/FIN的传输虽然没有data，但是会让下一次传输的packet seq增加一，但是，ACK的传输，不会让下一次的传输packet加一。

上面这几条原则第一次读会有些抽象，可以先继续往下读分析过程，再回过头来查看这个三个原则。

1、

> - seq：client端第一次发送packet，即：first-way handshake。所以按照上面的准则，它的数据应该从第一个开始，也即是第0位开始，所以seq为0。
> - ack：而server端之前并未发送过数据，所以期望的是server端回传时的packet的seq应该从第一个开始，即是第0位开始，所以ack为0。

2、

> - seq：server端第一次发送packet，即：second-way handshake。所以，这个packet的seq为0。
> - ack：由于在【no.1】中接收到的是client端的SYN数据包，且它的seq为0，所以client端会让它自己的seq增加1。由此可预计（expect），client端的下一次packet传输时，它的seq是1（0增加1）。所以，ACK为1。

3、

> - seq：third-way handshake。上一次发送时为【no.1】，【no.1】中seq为0且为SYN数据包，所以这一次的seq为1（0增加1）。
> - ack：上次接收到时为【no.2】，【no.2】中seq为0，且为SYN数据包（虽然在flag上同时设定为SYN/ACK，但只要flag是SYN，就会驱使seq加一），所以可预计，server端下一次seq为1（0增加1）。

4、

> - seq：上一次发送时为【no.1】，【no.1】中seq为0且为SYN数据包，所以这一次的seq为1（0增加1）。
> - ack：上次接收到时为【no.2】，【no.2】中seq为0，且为SYN数据包，所以可预计，server端下一次seq为1（0增加1）。

5、

> - seq：上一次发送时为【no.2】，【no.2】中seq为0，且为SYN数据包，所以这一次的seq为1（0增加1）。
> - ack：上一次接收时为【no.4】，【no.4】中的seq为1，数据包的长度为725，所以可以预计，下一次client端的seq为726（1+725）。

6、

> - seq：上一次发送时为【no.5】，【no.5】中seq为1，但【no.5】为ACK数据包，所以数据长度为0且不会驱使seq加1，所以这一次的seq为1（1+0）。
> - ack：上一次接收时为【no.4】，【no.4】中的seq为1，数据包的长度为725，所以可以预计，下一次client端的seq为726（1+725）。

7、

> - seq：上一次发送时为【no.4】，【no.4】中seq为1，数据包长度为725，所以这一次的seq为726（1+725）。
> - ack：上一次接收时为【no.6】，【no.6】中seq为1，且数据长度为1448，所以可以预计，下一次server端的seq为1449（1+1448）。

8、

> - seq：上一次发送时为【no.6】，【no.6】中seq为1，数据包长度为1448，所以这一次的seq为1449（1+1448）。
> - ack：上一次接收时为【no.7】，【no.7】中seq为726，数据包为ACK、即数据为0，所以可以预计，下一次client端的seq为726（726+0）。

9、

> - seq：上一次发送时为【no.7】，【no.7】中seq为726，数据包为ACK、即长度为0， 所以这一次seq为726（726+0）。
> - ack：上一次接收时为【no.8】，【no.8】中seq为1449，数据包长度为1448，所以可以预计，下一次server端的seq为2897（1449+1448）。

10、

> - seq：上一次发送时为【no.8】，【no.8】中seq为1449，且数据包长度为1448，所以这一次seq为2897（1449+1448）。
> - ack：上一次接收时为【no.9】，【no.9】中seq为726，数据包为ACK、即数据为0，所以可以预计，下一次client端的seq为726（726+0）。

剩下的7个packet可以留作练习题自己分析。可以看到的是，从【no.7】开始，client端这边就只负责做响应，发送ACK数据包，而并没有实际的数据发送到server端。所以，从【no.7】开始，所有的ACK数据包的seq都是相同的726，因为ACK不像SYN/FIN可以让seq增加，所以发送再多的ACK包都只能让seq原地踏步。

### 丢包验证

由此可以看到，无论对于client端还是server端，这一次刚收到的对方的packet的seq，一定要和最后一次发送时的packet的ack相等。

因为最后一次发送时的packet的ack，是对下一次接收的packet的seq做的预测。如果两者不等，则表明中途有数据包丢失了！