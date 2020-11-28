----
title: Learn Gradle - 2 基本的构建脚本介绍
date: 2017-10-27 
description: 

tags:
- 包管理
- Gradle
- Java

nav:
- 工具

categories:
- Gradle

image: images/gradle.png

----

## 1、项目和任务

Gradle 构建脚本包括两个最基本的概念，就是项目（projects）和任务（tasks）。

项目是指我们的构建产物（比如jar包）或实施产物（比如web application等）。**Gradle构建脚本包含一个或多个项目。**

任务是指不可分的最小工作单元，执行构建工作（比如编译一些类文件、创建jar文件、生成javadoc以及发布架构文档到仓库等）。**一个项目包含一个或多个任务。**

## 2、Hello World！！

下面我们学习一个简单的hello world例子来简单认识一下Gradle构建脚本。

新建文件：build.gradle 

添加内容：

``` bash
task hello {
    doLast {
        println 'Hello world!'
    }
}
```

使用命令行进入build.gradle所在目录，执行：gradle hello ，输出：

<!--more-->

``` bash
:hello
Hello world!
 
BUILD SUCCESSFUL
```

在这个例子中build.gradle 文件就是一个构建脚本（严格的说，这是一个构建配置脚本），这个脚本定义了一个项目以及项目包含的任务。

Gradle是领域驱动设计的构建工具，在它的实现当中，Project接口对应上面的project概念，Task接口对应上面的task概念，实际上除此之外还有一个重要的领域对象，即Action，对应的是task里面具体的某一个操作。一个project由多个task组成，一个task也是由多个action组成。

当执行gradle hello的时候，Gradle就会去调用这个hello task来执行给定操作(Action)。这个操作其实就是一个用Groovy代码写的闭包，代码中的task是Project类里的一个方法，通过调用这里的task方法创建了一个Task对象，并在对象的doLast方法中传入 println 'Hello world!' 这个闭包。这个闭包就是一个Action。

Task是Gradle里定义的一个接口，表示上述概念中的task。它定义了一系列的诸如doLast, doFirst等抽象方法，具体可以看gradle api里org.gradle.api.Task的文档。


## 3、使用快捷键定义任务

doLast还有另外一种简单的写法：

``` bash
task hello << {
    println 'Hello world!'
}
```

执行gradle hello 命令，输出结果与之前的相同。也就是我们把像doLast这样的代码，直接简化为<<这个符号了。这其实是Gradle利用了Groovy的操作符重载的特性，把左位移操作符实现为将action加到task的最后，相当于调用doLast方法。看Gradle的api文档里对doLast()和leftShift()这两个方法的介绍，可知它们的作用是一样的，所以在这里，<<左移操作符即doLast的简写方式。

## 4、脚本即代码

在Gradle的构建脚本中，可以使用Groovy代码以实现更强大的功能。

例1：

``` bash
task upper << {
    String someString = 'mY_nAmE'
    println "Original: " + someString 
    println "Upper case: " + someString.toUpperCase()
}
```

执行gradle upper，输出：

``` bash
:upper
Original: mY_nAmE
Upper case: MY_NAME

BUILD SUCCESSFUL
```

例2：

``` bash
task count << {
    4.times { print "$it " }
}
```

执行gradle count，输出：

``` bash
:count
0 1 2 3
BUILD SUCCESSFUL
```

## 5、任务依赖

1、在脚本中定义任务依赖：

``` bash
task hello << {
    println 'Hello world!'
}
task intro(dependsOn: hello) << {
    println "I'm Gradle"
}
```
执行gradle intro，输出：

``` bash
:hello
Hello world!
:intro
I'm Gradle
 
BUILD SUCCESSFUL
```

2、任务可以依赖尚未出现的任务：

``` bash
task taskX(dependsOn: 'taskY') << {
    println 'taskX'
}
task taskY << {
    println 'taskY'
}
```

本例中任务taskX依赖taskY，但是taskY在taskX之后才定义。执行gradle taskX，输出：

``` bash
:taskY
taskY
:taskX
taskX
 
BUILD SUCCESSFUL
```

## 6、动态任务

我们可以使用Groovy的语法动态创建任务，例如：

``` bash
4.times { counter ->
    task "task$counter" << {
        println "I'm task number $counter"
    }
}
```

执行gradle -q task1，输出：

``` bash
:task1
I'm task number 1
 
BUILD SUCCESSFUL
```

## 7、操纵任务

已经创建的任务可以通过api（例1用到的api是dependsOn ）进行访问。

例1：给一个任务添加依赖

``` bash
4.times { counter ->
    task "task$counter" << {
        println "I'm task number $counter"
    }
}
task0.dependsOn task2, task3
```

执行gradle task0 ，输出

``` bash
:task2
I'm task number 2
:task3
I'm task number 3
:task0
I'm task number 0
 
BUILD SUCCESSFUL
```

例2：给一个任务添加行为

``` bash
task hello << {
    println 'Hello Earth'
}
hello.doFirst {
    println 'Hello Venus'
}
hello.doLast {
    println 'Hello Mars'
}
hello << {
    println 'Hello Jupiter'
}
```

执行gradle hello，输出：

``` bash
:hello
Hello Venus
Hello Earth
Hello Mars
Hello Jupiter
 
BUILD SUCCESSFUL
```

任务先执行了doFirst，再按顺序执行了doLast（"<<"可以理解为doLast的别名，所以相同的api方法将按照配置文件顺序执行）

## 8、自定义属性

``` bash
task myTask {
    ext.myProperty = "myValue"
}
task printTaskProperties << {
    println myTask.myProperty
}
```
执行gradle printTaskProperties，输出：

``` bash
:printTaskProperties
myValue
 
BUILD SUCCESSFUL
```

## 9、默认任务

gradle允许在构建过程中配置一个或多个任务作为默认任务来执行，例如：

``` bash
defaultTasks 'clean', 'run'
 
task clean << {
    println 'Default Cleaning!'
}
 
task run << {
    println 'Default Running!'
}
 
task other << {
    println "I'm not a default task!"
}
```

执行 gradle ，输出：

``` bash
:clean
Default Cleaning!
:run
Default Running!
 
BUILD SUCCESSFUL
```

## 10、DAG（Directed acyclic graph，有向非循环图）配置

Gradle构建的生命周期包含初始化阶段、配置阶段和执行阶段。Gradle使用DAG来记录任务执行的顺序。配置阶段完成后，Gradle就明确了所有需要被执行的任务，这些任务将被存储到taskGraph。Gradle提供了一个钩子来使用这个（taskGraph）信息。下面这个例子我们将判断taskGraph是否包含release任务来确定项目发布的版本号。

``` bash
task distribution << {
    println "We build the zip with version=$version"}
 
task release(dependsOn: 'distribution') << {
    println 'We release now'}
 
gradle.taskGraph.whenReady {taskGraph ->    
    if (taskGraph.hasTask(release)) {
        version = '1.0'
    } else {
        version = '1.0-SNAPSHOT'
    }
}
```

执行 gradle distribution ，输出：

``` bash
:distribution
We build the zip with version=1.0-SNAPSHOT
 
BUILD SUCCESSFUL
```

执行gradle release ，输出：

``` bash
:distribution
We build the zip with version=1.0
:release
We release now
 
BUILD SUCCESSFUL
```