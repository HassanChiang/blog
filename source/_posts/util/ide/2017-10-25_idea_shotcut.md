----
title: IntelliJ 各种快捷键
date: 2017-10-25 11:29:24
description: 

tags:
- Idea
- JavaIDE
- Java

nav:
- 工具

categories:
- IDE

image: images/idea_logo.png

----

工欲善其事必先利其器，花一点时间，记录一下 Intellij 各种快捷键。


**窗口交互**

Alt + 1 显示 Project 窗口 ☆☆☆
Alt + 2 显示 Favorite 窗口
Alt + 3 显示 Find 窗口
Alt + 5 显示 Debug 窗口
…..

具体看显示窗口的标签标注 1 类似的就是快捷键值了

Ctrl + Shift + F12 最大化编辑窗口与上次视图进行切换

Alt + Home 定位到导航目录，然后可以使用上下左右建进行文件目录导航

Esc 焦点进入编辑器

**代码补全**

Ctrl + Space 基本补全

Ctrl + Shift + Space 智能补全

Alt + / 按照最近的关键字补全

Ctrl + Shift + Enter 补全代码结构，包括缺失的小括号、中括号、大括号以及必要的结构

**编辑器常用**

Ctrl + Shift + Up 和 Ctrl + Shift + Down 移动选中的代码行 ☆☆☆

Ctrl + D 复制选中的代码行 ☆☆☆☆

Ctrl + Y 删除选中的代码行 ☆☆☆☆

Ctrl + / 按行注释代码或取消注释代码 ☆☆☆☆☆

Ctrl + Shift + / 按块注释代码或取消注释代码 ☆☆☆☆☆

Ctrl + F 或 Alt + F3 在当前打开文件查找 ☆☆☆☆☆

Ctrl + R 在当前打开文件查找并替换

Alt + Right 和 Alt + Left 导航打开的编辑器窗口 ☆☆☆☆

Ctrl + Alt + Left 和 Ctrl + Alt + Right 导航焦点 ☆☆☆☆☆

Ctrl + - （中横线，减号） 收起代码块

Ctrl + - （加号，等于号） 展开代码块

Alt + Insert 打开代码生成菜单

Ctrl + Alt + T 打开代码包围菜单，可以快速将代码使用 if ，try catch 等语法进行围绕

Ctrl + W 选中代码块，试几次就知道啥意思了

Alt + J 和 Alt + Shift + J 向下或向上查找选中的关键字 ☆☆☆☆

**导航**

Ctrl + E 打开最近文件菜单 ☆☆☆

Ctrl + N 类搜索，这个功能应该非常常用了，使用频率很高，模糊搜索非常好用 ☆☆☆☆☆

Ctrl + Shift + N 文件搜索，搜索资源文件常用到 ☆☆☆☆☆

Ctrl + Shift + Alt + N 符号搜索，搜索方法和变量名的时候会用到

**查看结构**

Ctrl + F12 查看文件结构，类，JSP，XML，Properties 文件等都可以查看 ☆☆☆☆☆

Alt + F1 选择文件在什么窗口打开，选项很多，可以自己看看。 Alt + F1 然后 C ，使用本地 Explorer 打开还挺好用的 ☆☆☆☆

Ctrl + Q 查看 Java doc

Ctrl + Shift + I 查看定义

Ctrl + Alt + F7 查看调用方，这个我比较不习惯，喜欢用 Alt + F7，在 Find 窗口上查看 ☆☆☆☆☆

Ctrl + Alt + B 查看实现，非常常用 ☆☆☆☆☆

Ctrl + U 查看接口

**重构**

Shift + F6 重命名 ☆☆☆☆☆

Ctrl + Alt + V 重构成变量，一般就是要给方法的返回值，赋值给一个变量

Ctrl + Alt + F 重构成成员变量 和 V 类似

Ctrl + Alt + C 重构成常量

Ctrl + Alt + M 重构成一个方法，这个还挺常用的 ☆☆☆☆

Ctrl + Alt + N 选择多行代码，重构成一行代码，这个应该不常用，影响代码可读性

F5 复制

F6 移动

Ctrl + Shift + Alt + T 打开重构菜单

代码格式

Ctrl + Alt + I 默认使用空格缩进

Ctrl + Alt + L 格式化，呵呵，这个和 QQ 冲突了

Ctrl + Alt + L 代码导入（import）

**版本控制**

Alt + 9 or Shift + Alt + 9 上面已经提到过，打开版本控制窗口

Alt + Back Quote 这个说是打开 CVS 操作菜单，but，我的 IDE 没有反应

Ctrl + K 提交代码

Ctrl + T 更新代码

Ctrl + Shift + K push 代码 GIT 用的吧？我这 SVN 没有发现有什么功能

**编译**

Ctrl + F9

Debug

Ctrl + F8 打断点

F7 进入下一步

Shift + F7 智能进入下一步

F8 结束这一步

Shift + F8 结束当前方法，返回

…

在面板上可以查看其他快捷键的使用

完。