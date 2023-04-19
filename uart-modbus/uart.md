# C#

```tex
BaudRate : 9600
BreakState : False
BytesToWrite : 0
BytesToRead : 0
CDHolding : False
CtsHolding : False
DataBits : 8
DiscardNull : False
DsrHolding : False
DtrEnable : False
Encoding : System.Text.ASCIIEncoding+ASCIIEncodingSealed
Handshake : None
IsOpen : True
NewLine :

Parity : None
ParityReplace : 63
PortName : COM1
ReadBufferSize : 4096
ReadTimeout : -1
ReceivedBytesThreshold : 1
RtsEnable : False
StopBits : One
WriteBufferSize : 2048
WriteTimeout : -1
Site :
Container :
```

# 如何判断主机的串口的COM号



# 如何判断是直连线还是交叉线？



# 选择直连线还是交叉线？

> “长在外设身上”的DB9的2，3引脚实际上是收还是发取决于电子工程师把MCU的收线焊接在2上还是3上。若MCU的收线焊接在2上，则2是RX，3是TX，否则2是TX，3是RX。
>
> 串口连接线两端的DB9的2和3一定是与“长在外设身上”的DB9的2和3相连(2-2,3-3)，具体是发还是收，取决于“长在外设身上”的DB9的2和3是发还是收。如果外设DB9的2是发，则连接线直接与外设连接的一端的2一定是发，如果连接线是直连线则另外一端的2也是发，否则是收。



**RS232-DB9引脚功能定义**

| 引脚编号(pin) |     中文说明     |      英文说明       |
| :-----------: | :--------------: | :-----------------: |
|       1       | 数据载波检测 DCD | Data Carrier Detect |
|       2       | 串口数据输入 RXD |    Receive Data     |
|       3       | 串口数据输出 TXD |    Transmit Data    |
|       4       | 数据终端就绪 DTR | Data Terminal Ready |
|       5       |     地线 GND     |                     |
|       6       | 数据发送就绪 DSR |   Data Send Ready   |
|       7       | 发送数据请求 RTS |   Request to Send   |
|       8       |   清除发送 CTS   |    Clear to Send    |
|       9       |   铃声指示 RI    |                     |

**引脚分类**

- 数据： 2、3

* 硬流控：1、4、6、7、8

- 地线：5

- 其他：9

随着历史的发展，现在绝大多数带有串口通信接口的外设，只使用2、3、5这3根针脚，不使用其他引脚。

**下面是公母头9根引脚的排布和编号详情**

![image-20230420005546387](D:\OneDrive\Notebook\asserts\image-20230420005546387.png)

长在外设身上的DB9可以分成串行收发器和带9针的外壳两个部分。

![image-20230420015148798](D:\OneDrive\Notebook\asserts\image-20230420015148798.png)

按照DB9每个编号的引脚功能定义，把串行收发器相应功能的导线焊接到外壳的针脚上，即可做成标准的RS232-DB9接口。

如果将公母头对插，会1-1，2-2，3-3，4-4，5-5，6-6，7-7，8-8，9-9。但是公母头的2都是RX(收),3都是TX(发)，这显然不行。所以会使用一根(2-3，3-2)的交叉串口线连接PC和外设。

连接情况如下：

外设DB9->交叉串口线端口DB9->交叉串口线端口DB9->PCDB9

即，2RX->2RX->3RX->3TX.

**SUMMAY**

- 原来一根串口线已经连接好PC和外设并且通信正常，但是后面需要再买一根串口线延长原来的串口线，显然要买直连线。即，延长线要是直连线。
- 如果外设是标准串口（2-RX,3-TX），那么要买交叉线。但是有些外设的DB9并没有遵守定义，电子工程师故意把MCU的收数据导线焊到3上，那么这就是非标准DB9，这种情况我们要买直连接线。所以具体要用什么线，最好问下外设的技术支持。电子设备行业有个不成文的惯例，如果外设留的是公头接口，就是标准串口，与PC连接用交叉，如果留的是母头接口，会故意把MCU接反,那么这种情况用直连。口诀: 公头外设用交叉，母头外设用直连。

<img src="D:\OneDrive\Notebook\asserts\image-20230420020041706.png" alt="image-20230420020041706" style="zoom:50%;" />

<img src="D:\OneDrive\Notebook\asserts\image-20230420020124970.png" alt="image-20230420020124970" style="zoom:50%;" />











































之前IBM-PC定义此DB9能连接鼠标，打印机，调制解调器





 一般地，我们把这个串口叫作UART(Universal Asynchronous Receiver and Transmitter 通用异步收发器)。





软件 上，已经可以选项配置是否支持硬件流控，是否检查DSR、DCD、RI等输入信号。





一个有趣的现象是，早 期的操作系统DOS和ROM BIOS提供的通信例程只支持RS232串口标准，即使是实现简单的字节收发这种非RS232应用，竟然也要先检测DSR、DCD、CTS等信号是否有 效，如果不满足条件，将不会发送数据到TXD上。解决这个问题的方法有两种：1、旁路系统提供的API函数，自己直接操纵硬件实现非RS232的操 作；2、短接接头里某些RS232控制信号线，使系统通信例程误以为是RS232设备，使非RS232的设备满足RS232规范的子集要求。
————————————————
版权声明：本文为CSDN博主「笑对生活_展望未来」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/zeng622peng/article/details/5553404











RES485广泛应用的原因：

接口简单，组网方便，远距离传输。

![image-20230420005921857](D:\OneDrive\Notebook\asserts\image-20230420005921857.png)

![image-20230420010054689](D:\OneDrive\Notebook\asserts\image-20230420010054689.png)

串口通信的校验位通常会被省略，原因：奇偶校验本身不是可靠的，优点鸡肋。校验位会增加无效bit占用率。每个数据帧都要处理校验会浪费时间。一般会在上层协议接收N个字节组成的完整应用层协议帧统一使用更为靠谱的校验方法如CRC统一校验对N个字节进行一次性校验，既可靠效率又高。

![image-20230420011105600](D:\OneDrive\Notebook\asserts\image-20230420011105600.png)















![image-20230419195535935](D:\OneDrive\Notebook\asserts\image-20230419195535935.png)

![image-20230419195611777](D:\OneDrive\Notebook\asserts\image-20230419195611777.png)

![image-20230419195716714](D:\OneDrive\Notebook\asserts\image-20230419195716714.png)

