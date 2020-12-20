---

title: 解决 Linux 下 chrome 无法播放 flash 问题
date: 2017-11-30
description:
{: id="20201220214147-hgusfnv"}

tags:
{: id="20201220214147-m9rs7yy"}

- {: id="20201220214147-0mkczp3"}deb
- {: id="20201220214147-9kxg6s9"}chrome
{: id="20201220214147-i1sbgil"}

nav:
{: id="20201220214147-96iz8qg"}

- {: id="20201220214147-ub27sm7"}Linux
{: id="20201220214147-ex2otdj"}

categories:
{: id="20201220214147-0ulfntn"}

- {: id="20201220214147-gwxcwob"}其他
{: id="20201220214147-htmdtlg"}

image: images/linux.png
{: id="20201220214147-fdcjozu"}

---

chrome 54 以上版本没有自带 flash，在播放 flash 视频时 chrome 会下载 swf 文件。如果在 chrome://plugins 启用了 flash 插件，则会显示 flash out of date。
{: id="20201220214147-maqammg"}

需要让 chrome 安装 flash 插件。在地址栏输入 chrome://components，然后点击 Adobe Flash Player 下面的 Check for update，chrome 会下载安装 flash 插件。下载插件需要代理，但 chrome 不会使用代理插件（例如 SwithyOmega）提供的代理，应该用外部程序代理。我直接用路由器的 shadowsocks 了。
{: id="20201220214147-pa5uxgr"}

此时如果启用了 flash 插件，则会卡在 Checking for status。需要先到 chrome://plugins 禁用 flash 插件。
{: id="20201220214147-dn5l258"}

安装完毕显示 Component updated 后，在地址栏输入 chrome://plugins，点击页面右侧的 Details，点击 Adobe Flash Player 项中 PPAPI 下面的 Enable，然后勾选 “Always allowed to run”，启用 flash。
{: id="20201220214147-23wi4mc"}


{: id="20201220214147-zcmcj0w" type="doc"}
