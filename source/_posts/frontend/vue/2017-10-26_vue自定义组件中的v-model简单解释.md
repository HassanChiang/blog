---

title: vue自定义组件中的v-model简单解释（vue单页面组件传值）
date: 2019-10-25
description:
{: id="20201220214147-euen6ot"}

tags:
{: id="20201220214147-vb9ftqp"}

- {: id="20201220214147-5v34net"}JavaScript
- {: id="20201220214147-5cgses3"}Vue
{: id="20201220214147-cv02x0q"}

nav:
{: id="20201220214147-gkelrc2"}

- {: id="20201220214147-1j00b5w"}前端
{: id="20201220214147-lsa6nnj"}

categories:
{: id="20201220214147-a2uyeho"}

- {: id="20201220214147-029k5an"}VUE
{: id="20201220214147-i90i5to"}

image: images/vue.png
{: id="20201220214147-r8qyf3e"}

---

> 在使用iview框架的时候，经常会看到组件用v-model双向绑定数据，与传统步骤父组件通过props传值子组件，子组件发送$emit来修改值相比，这种方式避免操作子组件的同时再操作父组件，显得子组件的封装效果更好。所以，个人认为，我们自己封装组件也应该有这样的思维，父组件通过slot或者props传值，由子组件完成一些效果，再抛出必要的事件让父组件接受，这样组件的可复用性就很强，有利于多次使用。
> {: id="20201220214147-fd5q7c2"}
{: id="20201220214147-hblwilm"}

## v-model指令是什么?
{: id="20201220214147-bs34cjg"}

刚刚提到，iview通过v-model双向绑定数据，所以首先我们要明白v-model在这个过程中做了什么。有vue基础的同学应该知道，v-model本质是一个语法糖，在v-bind和v-on的整合。表单元素比如input，v-bind绑定一个值，就把data数据传给了value，同时再通过v-on监听input事件，当表单数据改变的时候，也会把值传给data数据，代码如下
{: id="20201220214147-tfbxagh"}

```
<input type='text' v-model='msg'>

// 相当于

<input type='text' :value=msg @input='msg =$event.target.value'>

```
{: id="20201220214147-s8q58iu"}

## vue2.2新增model API
{: id="20201220214147-zbbxm91"}

虽说新增，实际上vue3.0都已经发布了，这其实算个比较旧特性，官网是这么写的
{: id="20201220214147-r886yth"}

```
允许一个自定义组件在使用 v-model 时定制 prop 和 event。默认情况下，一个组件上的 v-model 会把 value 用作 prop 且把 input 用作 event，但是一些输入类型比如单选框和复选框按钮可能想使用 value prop 来达到不同的目的。使用 model 选项可以回避这些情况产生的冲突。

```
{: id="20201220214147-t6ldwat"}

这句话比较长，咱们来一步步理解，首先是第一句
{: id="20201220214147-w0zyzt0"}

> 1. {: id="20201220214147-zx0budp"}允许一个自定义组件在使用v-model时定制prop和event
> {: id="20201220214147-rmid03v"}
{: id="20201220214147-75zi2ka"}

一般说来，`v-model`用在表单元素上进行数据的双向绑定，自定义组件通常通过父子组件传值绑定数据
{: id="20201220214147-gygigp4"}

> 1. {: id="20201220214147-pxlb52s"}默认情况下，一个组件上的`v-model`会把value用作prop且把input用作event
> {: id="20201220214147-bwb0e2w"}
{: id="20201220214147-s42fvst"}

前边说了，`v-model`是`v-bind`和`v-on`的语法糖，那么这里`v-model`就完成两个步骤
{: id="20201220214147-amjyi7b"}

举一个栗子
{: id="20201220214147-zn36h11"}

比如
{: id="20201220214147-fvx7q3x"}

```
// 父组件
<Child v-model='iptValue'></Child>

// 子组件Vue.components('Child',{
        model: {
            prop: ipt,
            evnet: change    
        }
        props: {
            ipt: Number
        }
        template: `<input type='number' :value='ipt' @change='$emit("change",parseInt($event.target.value))'>`
})

```
{: id="20201220214147-dbznvac"}

这里父组件中的v-model相当于
{: id="20201220214147-0e1n6np"}

```
<Child:value='iptValue' @change='value => iptValue = value'></Child>
```
{: id="20201220214147-zfc2cz1"}

用文字解释下上面的代码
{: id="20201220214147-ct28zfl"}

前面说了，父子组件传值通过prop和$emit，第一步父组件把iptValue通过prop传给了子组件，但要注意，我这里的子组件给prop取了一个别名叫做`ipt`作为区分,所以子组件的prop对象中的键为我取的别名`ipt`。第二步，当子组件input值改变的时候，子组件监听了一个onchange方法，注意我这里也给$emit中的事件取了一个别名，只不过这个别名和原来的名字一样change，input值改变emit提交change事件并把新值传给父组件，又又又要注意，$emit的荷载都是字符串....
{: id="20201220214147-2u31f4v"}

然后就跟上面代码一样
{: id="20201220214147-cq1wpw8"}

父组件执行`value => iptValue = value`语句，这样就完成了父子组件数据的双向绑定
{: id="20201220214147-4esecos"}

个人觉得`v-model`用在自定义组件最大的好处是提高了组件的封装性，父组件不必要另外写一个接受子组件发送给来的$emit方法
{: id="20201220214147-8ncprhr"}

> 1. {: id="20201220214147-jxeubcz"}最后是第三句话，`但是一些输入类型比如单选框和复选框按钮可能想使用 value prop 来达到不同的目的`
> {: id="20201220214147-e5d7o02"}
{: id="20201220214147-b1pfamo"}

其实这很容易理解，因为`value`字符串在input中是有意义的，取别名有利于区分，不太重要啦这一小部分...
{: id="20201220214147-hvbivcq"}

## 结束
{: id="20201220214147-hwe1ppv"}

那么以上就是个人对于自定义组件`v-model`的一点心得，文章有疑问或错误的地方还请指出，感谢阅读
{: id="20201220214147-s2ax60i"}

原文：https://www.cnblogs.com/youma/p/11386428.html
{: id="20201220214147-7up175j"}


{: id="20201220214147-iibsu88" type="doc"}
