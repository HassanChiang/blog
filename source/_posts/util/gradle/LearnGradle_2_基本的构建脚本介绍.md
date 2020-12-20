---

title: Learn Gradle - 2 基本的构建脚本介绍
date: 2017-10-27
description:
{: id="20201220214147-xb74m66"}

tags:
{: id="20201220214147-966g5n1"}

- {: id="20201220214147-b4hqziq"}包管理
- {: id="20201220214147-nes6sms"}Gradle
- {: id="20201220214147-tgdbn9j"}Java
{: id="20201220214147-rzxd67b"}

nav:
{: id="20201220214147-h4izo0m"}

- {: id="20201220214147-b5iucu2"}工具
{: id="20201220214147-pcytrfe"}

categories:
{: id="20201220214147-nj4o3eq"}

- {: id="20201220214147-jsoz3hv"}Gradle
{: id="20201220214147-kls4kdl"}

image: images/gradle.png
{: id="20201220214147-x3a6bzz"}

---

## 1、项目和任务
{: id="20201220214147-m32nj52"}

Gradle 构建脚本包括两个最基本的概念，就是项目（projects）和任务（tasks）。
{: id="20201220214147-vff1t7y"}

项目是指我们的构建产物（比如jar包）或实施产物（比如web application等）。**Gradle构建脚本包含一个或多个项目。**
{: id="20201220214147-azftiv9"}

任务是指不可分的最小工作单元，执行构建工作（比如编译一些类文件、创建jar文件、生成javadoc以及发布架构文档到仓库等）。**一个项目包含一个或多个任务。**
{: id="20201220214147-vqwwh73"}

## 2、Hello World！！
{: id="20201220214147-zhxfc3m"}

下面我们学习一个简单的hello world例子来简单认识一下Gradle构建脚本。
{: id="20201220214147-e09rfyl"}

新建文件：build.gradle
{: id="20201220214147-avf1giv"}

添加内容：
{: id="20201220214147-egnck19"}

```bash
task hello {
    doLast {
        println 'Hello world!'
    }
}
```
{: id="20201220214147-c29ju4j"}

使用命令行进入build.gradle所在目录，执行：gradle hello ，输出：
{: id="20201220214147-eiejci4"}

<!--more-->

```bash
:hello
Hello world!
 
BUILD SUCCESSFUL
```
{: id="20201220214147-87axwsf"}

在这个例子中build.gradle 文件就是一个构建脚本（严格的说，这是一个构建配置脚本），这个脚本定义了一个项目以及项目包含的任务。
{: id="20201220214147-katyh6u"}

Gradle是领域驱动设计的构建工具，在它的实现当中，Project接口对应上面的project概念，Task接口对应上面的task概念，实际上除此之外还有一个重要的领域对象，即Action，对应的是task里面具体的某一个操作。一个project由多个task组成，一个task也是由多个action组成。
{: id="20201220214147-pq8kvol"}

当执行gradle hello的时候，Gradle就会去调用这个hello task来执行给定操作(Action)。这个操作其实就是一个用Groovy代码写的闭包，代码中的task是Project类里的一个方法，通过调用这里的task方法创建了一个Task对象，并在对象的doLast方法中传入 println 'Hello world!' 这个闭包。这个闭包就是一个Action。
{: id="20201220214147-ddwyrlr"}

Task是Gradle里定义的一个接口，表示上述概念中的task。它定义了一系列的诸如doLast, doFirst等抽象方法，具体可以看gradle api里org.gradle.api.Task的文档。
{: id="20201220214147-vz6am34"}

## 3、使用快捷键定义任务
{: id="20201220214147-t7acc7h"}

doLast还有另外一种简单的写法：
{: id="20201220214147-vjh792u"}

```bash
task hello << {
    println 'Hello world!'
}
```
{: id="20201220214147-rox3omn"}

执行gradle hello 命令，输出结果与之前的相同。也就是我们把像doLast这样的代码，直接简化为<<这个符号了。这其实是Gradle利用了Groovy的操作符重载的特性，把左位移操作符实现为将action加到task的最后，相当于调用doLast方法。看Gradle的api文档里对doLast()和leftShift()这两个方法的介绍，可知它们的作用是一样的，所以在这里，<<左移操作符即doLast的简写方式。
{: id="20201220214147-beighc0"}

## 4、脚本即代码
{: id="20201220214147-t24229y"}

在Gradle的构建脚本中，可以使用Groovy代码以实现更强大的功能。
{: id="20201220214147-mp9dgne"}

例1：
{: id="20201220214147-h3j3s5y"}

```bash
task upper << {
    String someString = 'mY_nAmE'
    println "Original: " + someString 
    println "Upper case: " + someString.toUpperCase()
}
```
{: id="20201220214147-mf8hm31"}

执行gradle upper，输出：
{: id="20201220214147-bmwnhle"}

```bash
:upper
Original: mY_nAmE
Upper case: MY_NAME

BUILD SUCCESSFUL
```
{: id="20201220214147-4yqbmhw"}

例2：
{: id="20201220214147-nc6vsea"}

```bash
task count << {
    4.times { print "$it " }
}
```
{: id="20201220214147-gjctl4w"}

执行gradle count，输出：
{: id="20201220214147-psqi6a3"}

```bash
:count
0 1 2 3
BUILD SUCCESSFUL
```
{: id="20201220214147-totig4t"}

## 5、任务依赖
{: id="20201220214147-1tm540s"}

1. {: id="20201220214147-193skcr"}在脚本中定义任务依赖：
{: id="20201220214147-pptw9vg"}

```bash
task hello << {
    println 'Hello world!'
}
task intro(dependsOn: hello) << {
    println "I'm Gradle"
}
```
{: id="20201220214147-qjgn3pq"}

执行gradle intro，输出：
{: id="20201220214147-7fsv8oc"}

```bash
:hello
Hello world!
:intro
I'm Gradle
 
BUILD SUCCESSFUL
```
{: id="20201220214147-o6h3fts"}

2. {: id="20201220214147-4es2rvy"}任务可以依赖尚未出现的任务：
{: id="20201220214147-itgywgb"}

```bash
task taskX(dependsOn: 'taskY') << {
    println 'taskX'
}
task taskY << {
    println 'taskY'
}
```
{: id="20201220214147-mk42jm8"}

本例中任务taskX依赖taskY，但是taskY在taskX之后才定义。执行gradle taskX，输出：
{: id="20201220214147-cxt6zqb"}

```bash
:taskY
taskY
:taskX
taskX
 
BUILD SUCCESSFUL
```
{: id="20201220214147-adstast"}

## 6、动态任务
{: id="20201220214147-3iqlq7p"}

我们可以使用Groovy的语法动态创建任务，例如：
{: id="20201220214147-z64k2ob"}

```bash
4.times { counter ->
    task "task$counter" << {
        println "I'm task number $counter"
    }
}
```
{: id="20201220214147-xsheirk"}

执行gradle -q task1，输出：
{: id="20201220214147-eud5mqr"}

```bash
:task1
I'm task number 1
 
BUILD SUCCESSFUL
```
{: id="20201220214147-o5gnlbr"}

## 7、操纵任务
{: id="20201220214147-w7803ts"}

已经创建的任务可以通过api（例1用到的api是dependsOn ）进行访问。
{: id="20201220214147-8rme2eu"}

例1：给一个任务添加依赖
{: id="20201220214147-ive4e3l"}

```bash
4.times { counter ->
    task "task$counter" << {
        println "I'm task number $counter"
    }
}
task0.dependsOn task2, task3
```
{: id="20201220214147-8m4k917"}

执行gradle task0 ，输出
{: id="20201220214147-g8ye644"}

```bash
:task2
I'm task number 2
:task3
I'm task number 3
:task0
I'm task number 0
 
BUILD SUCCESSFUL
```
{: id="20201220214147-77aqmeb"}

例2：给一个任务添加行为
{: id="20201220214147-ayk6qyd"}

```bash
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
{: id="20201220214147-71ujry8"}

执行gradle hello，输出：
{: id="20201220214147-xpbl8gg"}

```bash
:hello
Hello Venus
Hello Earth
Hello Mars
Hello Jupiter
 
BUILD SUCCESSFUL
```
{: id="20201220214147-947o9yt"}

任务先执行了doFirst，再按顺序执行了doLast（"<<"可以理解为doLast的别名，所以相同的api方法将按照配置文件顺序执行）
{: id="20201220214147-nwij6dj"}

## 8、自定义属性
{: id="20201220214147-04k3yyb"}

```bash
task myTask {
    ext.myProperty = "myValue"
}
task printTaskProperties << {
    println myTask.myProperty
}
```
{: id="20201220214147-61l736f"}

执行gradle printTaskProperties，输出：
{: id="20201220214147-kgx386o"}

```bash
:printTaskProperties
myValue
 
BUILD SUCCESSFUL
```
{: id="20201220214147-rj9awuf"}

## 9、默认任务
{: id="20201220214147-kqq1cnr"}

gradle允许在构建过程中配置一个或多个任务作为默认任务来执行，例如：
{: id="20201220214147-81cvpol"}

```bash
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
{: id="20201220214147-mrtrvjg"}

执行 gradle ，输出：
{: id="20201220214147-75f8vhf"}

```bash
:clean
Default Cleaning!
:run
Default Running!
 
BUILD SUCCESSFUL
```
{: id="20201220214147-axc2zxh"}

## 10、DAG（Directed acyclic graph，有向非循环图）配置
{: id="20201220214147-9oy8fg5"}

Gradle构建的生命周期包含初始化阶段、配置阶段和执行阶段。Gradle使用DAG来记录任务执行的顺序。配置阶段完成后，Gradle就明确了所有需要被执行的任务，这些任务将被存储到taskGraph。Gradle提供了一个钩子来使用这个（taskGraph）信息。下面这个例子我们将判断taskGraph是否包含release任务来确定项目发布的版本号。
{: id="20201220214147-27ebi82"}

```bash
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
{: id="20201220214147-oobbwau"}

执行 gradle distribution ，输出：
{: id="20201220214147-dt6oiny"}

```bash
:distribution
We build the zip with version=1.0-SNAPSHOT
 
BUILD SUCCESSFUL
```
{: id="20201220214147-nu6bu8m"}

执行gradle release ，输出：
{: id="20201220214147-4e05pa0"}

```bash
:distribution
We build the zip with version=1.0
:release
We release now
 
BUILD SUCCESSFUL
```
{: id="20201220214147-k1jskyi"}


{: id="20201220214147-ins1xp0" type="doc"}
