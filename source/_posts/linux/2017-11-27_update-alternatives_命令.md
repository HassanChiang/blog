----
title: update-alternatives 命令
date: 2017-11-25
description: 

tags:
- 符号链接

nav:
- Linux

categories:
- 其他

image: images/linux.png

----
update-alternatives 是符号链接管理工具。用于分组管理命令的链接和优先级。

update-alternatives 以链接组进行管理，每一个链接组（link group）都有两种不同的模式：自动模式和手动模式，任一给定时刻一个组都是而且只能是其中的一种模式。

如果一个组处于自动模式，当包被安装或删除时，备选方案系统会自己决定是否和如何来更新相应链接（links）。

如果处于手动模式，备选方案系统会保留原先管理员所做的选择并且避免改变链接（除非发生 broken）。

当第一次被安装到系统时链接组被分配为自动模式；如果之后系统管理员对模式的设置做出更改，这个组会被自动转换为手动模式。

--display name

显示链接组的信息。信息包括链接组的模式（自动或手动）；链接的指针（链到了那一个文件）；优先级是多少；当前最优版本等。

--install link name path priority [--slave slink sname spath] …

其中 link 为系统中功能相同软件的公共链接目录，比如 / usr/bin/java(需绝对目录)；

name 为命令链接符名称，如 java；

path 为你所要使用新命令、新软件的所在目录；

priority 为优先级，当命令链接已存在时，需高于当前值，因为当 alternative 为自动模式时, 系统默认启用 priority 高的链接;

--slave 为从 alternative。

例如：
```
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk8/bin/java 300
```
install 默认都为 auto 模式，因为大多数情况下 update-alternatives 命令都被 postinst (configure) or prerm (install) 调用的，如果将其更改成手动的话安装脚本将不会更新它了。

--config name

当使用 --config 选项时，update-alternatives 会列出所有链接组的主链接名，当前被选择的组会以 * 号标出。可以在提示下对链接指向做出改变，不过这会将模式变为手动。如果想恢复自动模式，你可以使用 --auto 选项，或者 --config 重新选择标为自动的组。

例如：
```
$ sudo update-alternatives --config editor
There are 4 choices for the alternative editor (providing /usr/bin/editor).
  Selection    Path                Priority   Status
------------------------------------------------------------
* 0            /bin/nano            40        auto mode
  1            /bin/ed             -100       manual mode
  2            /bin/nano            40        manual mode
  3            /usr/bin/vim.basic   30        manual mode
  4            /usr/bin/vim.tiny    10        manual mode
Press enter to keep the current choice[*], or type selection number:
--auto name
```
重新使 name 链接组为自动模式。

--remove name path

删除 name 链接组里的 path 对应的符号链接