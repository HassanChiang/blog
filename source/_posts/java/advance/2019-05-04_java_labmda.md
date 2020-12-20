---

title: Java8新特性学习-函数式编程
date: 2019-05-04
description:
{: id="20201220214147-0sw342n"}

tags:
{: id="20201220214147-qvqk6o3"}

- {: id="20201220214147-ry22sxg"}函数式编程
- {: id="20201220214147-baufrau"}lambda
- {: id="20201220214147-pujvsip"}Java
{: id="20201220214147-1ghaf7f"}

nav:
{: id="20201220214147-0r81a0h"}

- {: id="20201220214147-ei1ok3n"}Java
{: id="20201220214147-s28i13c"}

categories:
{: id="20201220214147-1m6yxt4"}

- {: id="20201220214147-rafg5vo"}Java 进阶
{: id="20201220214147-zzxxwzc"}

image: images/java/basic/java_logo.png
{: id="20201220214147-syt8s3a"}

---

Java8 新引入函数式编程方式，大大的提高了编码效率。本文将对涉及的对象等进行统一的学习及记录。内容包括：Stream/Function/Optional/Consumer。
{: id="20201220214147-bjep7iz"}

首先需要清楚一个概念：函数式接口；它指的是有且只有一个未实现的方法的接口，一般通过 FunctionalInterface 这个注解来表明某个接口是一个函数式接口。函数式接口是 Java 支持函数式编程的基础。
{: id="20201220214147-dbf4pko"}

本文目录：
{: id="20201220214147-ugppdyf"}

- {: id="20201220214147-ssog827"}[1 Java8 函数式编程语法入门](#1-java8-函数式编程语法入门)
  {: id="20201220214147-heoq8mf"}
- {: id="20201220214147-ga5jyb6"}[2 Java 函数式接口](#2-java-函数式接口)
  {: id="20201220214147-2m31srl"}
- {: id="20201220214147-vgsmwfb"}[2.1 Consumer](#2-1-consumer)
  {: id="20201220214147-hqay1kv"}
- {: id="20201220214147-avgtpg4"}[2.2 Function](#2-2-function)
  {: id="20201220214147-jzl5aoq"}
- {: id="20201220214147-kex138z"}[2.3 Predicate](#2-3-predicate)
  {: id="20201220214147-84mxogw"}
- {: id="20201220214147-xvt06ze"}[3 函数式编程接口的使用](#3-函数式编程接口的使用)
  {: id="20201220214147-w1icead"}
- {: id="20201220214147-b7h6cf6"}[3.1 Stream](#3-1-stream)
  {: id="20201220214147-aajqwf0"}
- {: id="20201220214147-ne69hj1"}[3.1.1 Stream 对象的创建](#3-1-1-stream-对象的创建)
  {: id="20201220214147-vty1ux6"}
- {: id="20201220214147-khooy8s"}[3.1.2 Stream 对象的使用](#3-1-2-stream-对象的使用)
  {: id="20201220214147-xk1jsh2"}
- {: id="20201220214147-ay028vo"}[3.1.2.1 filter](#3-1-2-1-filter)
  {: id="20201220214147-kcfpck2"}
- {: id="20201220214147-fjeak86"}[3.1.2.2 map](#3-1-2-2-map)
  {: id="20201220214147-ndnopfc"}
- {: id="20201220214147-dnz15za"}[3.1.2.3 flatMap](#3-1-2-3-flatmap)
  {: id="20201220214147-cs84kxs"}
- {: id="20201220214147-oc9l44b"}[3.1.2.4 takeWhile](#3-1-2-4-takewhile)
  {: id="20201220214147-oq77lur"}
- {: id="20201220214147-la7g9d3"}[3.1.2.5 dropWhile](#3-1-2-5-dropwhile)
  {: id="20201220214147-jox17j2"}
- {: id="20201220214147-zbihc22"}[3.1.2.6 reduce 与 collect](#3-1-2-6-reduce-与-collect)
  {: id="20201220214147-j99qqay"}
- {: id="20201220214147-7ddp1iz"}[3.2 Optional](#3-2-optional)
  {: id="20201220214147-box05hk"}
- {: id="20201220214147-irweida"}[3.2.1 Optional 对象创建](#3-2-1-optional对象创建)
  {: id="20201220214147-sazuu4l"}
- {: id="20201220214147-ktfdmh4"}[3.2.1.1 empty](#3-2-1-1-empty)
  {: id="20201220214147-p3ryqti"}
- {: id="20201220214147-6k2tg21"}[3.2.1.2 of](#3-2-1-2-of)
  {: id="20201220214147-e4k11qj"}
- {: id="20201220214147-dfeovpd"}[3.2.1.3 ofNullable](#3-2-1-3-ofnullable)
  {: id="20201220214147-xhilwvs"}
- {: id="20201220214147-za92ikn"}[3.2.2 方法](#3-2-2-方法)
  {: id="20201220214147-jaz00uq"}
- {: id="20201220214147-vvc0txm"}[3.2.3 使用场景](#3-2-3-使用场景)
  {: id="20201220214147-g23eoxi"}
- {: id="20201220214147-dd79jb0"}[3.2.3.1 判断结果不为空后使用](#3-2-3-1-判断结果不为空后使用)
  {: id="20201220214147-czvg4sd"}
- {: id="20201220214147-0nvofc6"}[3.2.3.2 变量为空时提供默认值](#3-2-3-2-变量为空时提供默认值)
  {: id="20201220214147-5eh6qjv"}
- {: id="20201220214147-eo1o63l"}[3.2.3.3 变量为空时抛出异常,否则使用](#3-2-3-3-变量为空时抛出异常-否则使用)
  {: id="20201220214147-udddbsl"}
{: id="20201220214147-8baee8z"}

# 1 Java8 函数式编程语法入门
{: id="20201220214147-0re85ji"}

Java8 中函数式编程语法能够精简代码。
{: id="20201220214147-5ds833k"}

使用 Consumer 作为示例，它是一个函数式接口，包含一个抽象方法 accept，这个方法只有输入而无输出。
{: id="20201220214147-dst75nc"}

现在我们要定义一个 Consumer 对象，传统的方式是这样定义的：
{: id="20201220214147-wgqveta"}

```
Consumer c = new Consumer() {
    @Overridepublicvoidaccept(Object o) {
        System.out.println(o);
    }
};
```
{: id="20201220214147-x19ckvn"}

而在 Java8 中，针对函数式编程接口，可以这样定义：
{: id="20201220214147-knm2xau"}

```
Consumer c = (o) -> {
    System.out.println(o);
};  
```
{: id="20201220214147-inqa4l9"}

上面已说明，函数式编程接口都只有一个抽象方法，因此在采用这种写法时，编译器会将这段函数编译后当作该抽象方法的实现。
{: id="20201220214147-67sqysa"}

如果接口有多个抽象方法，编译器就不知道这段函数应该是实现哪个方法的了。
{: id="20201220214147-z937ka2"}

因此，= 后面的函数体我们就可以看成是 accept 函数的实现。
{: id="20201220214147-mtlnh7x"}

- {: id="20201220214147-yih5mv6"}输入：->前面的部分，即被 () 包围的部分。此处只有一个输入参数，实际上输入是可以有多个的，如两个参数时写法：(a, b); 当然也可以没有输入，此时直接就可以是()。
- {: id="20201220214147-odhir77"}函数体：->后面的部分，即被 {} 包围的部分；可以是一段代码。
- {: id="20201220214147-p97h4i2"}输出：函数式编程可以没有返回值，也可以有返回值。如果有返回值时，需要代码段的最后一句通过 return 的方式返回对应的值。
{: id="20201220214147-lhn6dd4"}

当函数体中只有一个语句时，可以去掉 {} 进一步简化：
{: id="20201220214147-4sya2oj"}

```
Consumer c = (o) -> System.out.println(o);
```
{: id="20201220214147-kw46ro7"}

然而这还不是最简的，由于此处只是进行打印，调用了 System.out 中的 println 静态方法对输入参数直接进行打印，因此可以简化成以下写法：
{: id="20201220214147-2ti8tk6"}

```
Consumer c = System.out::println;
```
{: id="20201220214147-bhp9f1q"}

它表示的意思就是针对输入的参数将其调用 System.out 中的静态方法 println 进行打印。
{: id="20201220214147-lw0tusn"}

到这一步就可以感受到函数式编程的强大能力。
{: id="20201220214147-rq1en9h"}

通过最后一段代码，我们可以简单的理解函数式编程，Consumer 接口直接就可以当成一个函数了，这个函数接收一个输入参数，然后针对这个输入进行处理；当然其本质上仍旧是一个对象，但我们已经省去了诸如老方式中的对象定义过程，直接使用一段代码来给函数式接口对象赋值。
{: id="20201220214147-ex8szd5"}

而且最为关键的是，这个函数式对象因为本质上仍旧是一个对象，因此可以做为其它方法的参数或者返回值，可以与原有的代码实现无缝集成！
{: id="20201220214147-fit8b5g"}

下面对 Java 中的几个预先定义的函数式接口及其经常使用的类进行分析学习。
{: id="20201220214147-ga5r0mp"}

# 2 Java 函数式接口
{: id="20201220214147-s1d18zl"}

## 2.1 Consumer
{: id="20201220214147-po9frpj"}

Consumer 是一个函数式编程接口； 顾名思义，Consumer 的意思就是消费，即针对某个东西我们来使用它，因此它包含有一个有输入而无输出的 accept 接口方法；
{: id="20201220214147-flliw9i"}

除 accept 方法，它还包含有 andThen 这个方法；
{: id="20201220214147-cwk7por"}

其定义如下：
{: id="20201220214147-c3lhe9l"}

```
default Consumer<T> andThen(Consumer<? super T> after) {
    Objects.requireNonNull(after);
    return (T t) -> { accept(t); after.accept(t); };
}
```
{: id="20201220214147-4v8va35"}

可见这个方法就是指定在调用当前 Consumer 后是否还要调用其它的 Consumer；
{: id="20201220214147-vfd2c9s"}

使用示例：
{: id="20201220214147-mxm52r6"}

```
publicstaticvoidconsumerTest() {
    Consumer f = System.out::println;
    Consumer f2 = n -> System.out.println(n + "-F2");

    //执行完F后再执行F2的Accept方法
    f.andThen(f2).accept("test");

    //连续执行F的Accept方法
    f.andThen(f).andThen(f).andThen(f).accept("test1");
}
```
{: id="20201220214147-g1n18fr"}

## 2.2 Function
{: id="20201220214147-fg2o5er"}

Function 也是一个函数式编程接口；它代表的含义是 “函数”，而函数经常是有输入输出的，因此它含有一个 apply 方法，包含一个输入与一个输出；
{: id="20201220214147-ytlipe2"}

除 apply 方法外，它还有 compose 与 andThen 及 indentity 三个方法，其使用见下述示例；
{: id="20201220214147-y9q7jtz"}

```
/**
 * Function测试
 */publicstaticvoidfunctionTest() {
    Function<Integer, Integer> f = s -> s++;
    Function<Integer, Integer> g = s -> s * 2;

    /**
     * 下面表示在执行F时，先执行G，并且执行F时使用G的输出当作输入。
     * 相当于以下代码：
     * Integer a = g.apply(1);
     * System.out.println(f.apply(a));
     */
    System.out.println(f.compose(g).apply(1));

    /**
     * 表示执行F的Apply后使用其返回的值当作输入再执行G的Apply；
     * 相当于以下代码
     * Integer a = f.apply(1);
     * System.out.println(g.apply(a));
     */
    System.out.println(f.andThen(g).apply(1));

    /**
     * identity方法会返回一个不进行任何处理的Function，即输出与输入值相等； 
     */
    System.out.println(Function.identity().apply("a"));
}
```
{: id="20201220214147-w2fd0qn"}

## 2.3 Predicate
{: id="20201220214147-limkw1d"}

Predicate 为函数式接口，predicate 的中文意思是 “断定”，即判断的意思，判断某个东西是否满足某种条件； 因此它包含 test 方法，根据输入值来做逻辑判断，其结果为 True 或者 False。
{: id="20201220214147-8v0wkrq"}

它的使用方法示例如下：
{: id="20201220214147-89c5xz1"}

```
/**
 * Predicate测试
 */privatestaticvoidpredicateTest() {
    Predicate<String> p = o -> o.equals("test");
    Predicate<String> g = o -> o.startsWith("t");

    /**
     * negate: 用于对原来的Predicate做取反处理；
     * 如当调用p.test("test")为True时，调用p.negate().test("test")就会是False；
     */
    Assert.assertFalse(p.negate().test("test"));

    /**
     * and: 针对同一输入值，多个Predicate均返回True时返回True，否则返回False；
     */
    Assert.assertTrue(p.and(g).test("test"));

    /**
     * or: 针对同一输入值，多个Predicate只要有一个返回True则返回True，否则返回False
     */
    Assert.assertTrue(p.or(g).test("ta"));
}
```
{: id="20201220214147-w1j9hrv"}

# 3 函数式编程接口的使用
{: id="20201220214147-ykq5e46"}

通过 Stream 以及 Optional 两个类，可以进一步利用函数式接口来简化代码。
{: id="20201220214147-v5gc7us"}

## 3.1 Stream
{: id="20201220214147-w4hlfuw"}

Stream 可以对多个元素进行一系列的操作，也可以支持对某些操作进行并发处理。
{: id="20201220214147-4loif5c"}

### 3.1.1 Stream 对象的创建
{: id="20201220214147-bi2heky"}

Stream 对象的创建途径有以下几种
{: id="20201220214147-6vk89jk"}

a. 创建空的 Stream 对象
{: id="20201220214147-zamw1ww"}

```
Stream stream = Stream.empty();
```
{: id="20201220214147-jzzcocu"}

b. 通过集合类中的 stream 或者 parallelStream 方法创建；
{: id="20201220214147-awqo0ob"}

```
List<String> list = Arrays.asList("a", "b", "c", "d");
Stream listStream = list.stream();                   //获取串行的Stream对象
Stream parallelListStream = list.parallelStream();   //获取并行的Stream对象  
```
{: id="20201220214147-9d6rau5"}

c. 通过 Stream 中的 of 方法创建：
{: id="20201220214147-7zkqd8r"}

```
Stream s = Stream.of("test");
Stream s1 = Stream.of("a", "b", "c", "d");
```
{: id="20201220214147-0s57jsq"}

d. 通过 Stream 中的 iterate 方法创建：
{: id="20201220214147-e0rl0ta"}

iterate 方法有两个不同参数的方法：
{: id="20201220214147-imm8kr9"}

```
publicstatic<T> Stream<T> iterate(final T seed, final UnaryOperator<T> f);  
publicstatic<T> Stream<T> iterate(T seed, Predicate<? super T> hasNext, UnaryOperator<T> next)
```
{: id="20201220214147-c5ntz4v"}

其中第一个方法将会返回一个无限有序值的 Stream 对象：它的第一个元素是 seed，第二个元素是 f.apply(seed); 第 N 个元素是 f.apply(n-1 个元素的值)；生成无限值的方法实际上与 Stream 的中间方法类似，在遇到中止方法前一般是不真正的执行的。因此无限值的这个方法一般与 limit 等方法一起使用，来获取前多少个元素。
{: id="20201220214147-slgt8up"}

当然获取前多少个元素也可以使用第二个方法。
{: id="20201220214147-hc7k76f"}

第二个方法与第一个方法生成元素的方式类似，不同的是它返回的是一个有限值的 Stream；中止条件是由 hasNext 来断定的。
{: id="20201220214147-pcb86mq"}

第二种方法的使用示例如下：
{: id="20201220214147-44g06dv"}

```
/**
 * 本示例表示从1开始组装一个序列，第一个是1，第二个是1+1即2，第三个是2+1即3..，直接10时中止；
 * 也可简化成以下形式：
 *        Stream.iterate(1,
 *        n -> n <= 10,
 *        n -> n+1).forEach(System.out::println);
 * 写成以下方式是为简化理解
 */
Stream.iterate(1,
        new Predicate<Integer>() {
            @Overridepublicbooleantest(Integer integer) {
                return integer <= 10;
            }
        },
    new UnaryOperator<Integer>() {
        @Overridepublic Integer apply(Integer integer) {
            return integer+1;
        }
}).forEach(System.out::println);
```
{: id="20201220214147-4pjxzg4"}

e. 通过 Stream 中的 generate 方法创建
{: id="20201220214147-esjwa0y"}

与 iterate 中创建无限元素的 Stream 类似，不过它的每个元素与前一元素无关，且生成的是一个无序的队列。也就是说每一个元素都可以随机生成。因此一般用来创建常量的 Stream 以及随机的 Stream 等。
{: id="20201220214147-flf2hg6"}

示例如下：
{: id="20201220214147-qzo1qal"}

```
/**
 * 随机生成10个Double元素的Stream并将其打印
 */
Stream.generate(new Supplier<Double>() {
    @Overridepublic Double get() {
        return Math.random();
    }
}).limit(10).forEach(System.out::println);

//上述写法可以简化成以下写法：
Stream.generate(() -> Math.random()).limit(10).forEach(System.out::println);
```
{: id="20201220214147-nuoylyd"}

f. 通过 Stream 中的 concat 方法连接两个 Stream 对象生成新的 Stream 对象
{: id="20201220214147-3sy7oy0"}

这个比较好理解不再赘述。
{: id="20201220214147-1j30hyr"}

### 3.1.2 Stream 对象的使用
{: id="20201220214147-sk1x2np"}

Stream 对象提供多个非常有用的方法，这些方法可以分成两类：
{: id="20201220214147-8b04zlz"}

中间操作：将原始的 Stream 转换成另外一个 Stream；如 filter 返回的是过滤后的 Stream。
{: id="20201220214147-j5op3ha"}

终端操作：产生的是一个结果或者其它的复合操作；如 count 或者 forEach 操作。
{: id="20201220214147-9hu9jq6"}

其清单如下所示，方法的具体说明及使用示例见后文。
{: id="20201220214147-518wjpa"}

所有中间操作
{: id="20201220214147-1kuvfal"}

方法说明sequential返回一个相等的串行的 Stream 对象，如果原 Stream 对象已经是串行就可能会返回原对象parallel返回一个相等的并行的 Stream 对象，如果原 Stream 对象已经是并行的就会返回原对象unordered返回一个不关心顺序的 Stream 对象，如果原对象已经是这类型的对象就会返回原对象onClose返回一个相等的 Steam 对象，同时新的 Stream 对象在执行 Close 方法时会调用传入的 Runnable 对象close关闭 Stream 对象filter元素过滤：对 Stream 对象按指定的 Predicate 进行过滤，返回的 Stream 对象中仅包含未被过滤的元素map元素一对一转换：使用传入的 Function 对象对 Stream 中的所有元素进行处理，返回的 Stream 对象中的元素为原元素处理后的结果mapToInt元素一对一转换：将原 Stream 中的使用传入的 IntFunction 加工后返回一个 IntStream 对象flatMap元素一对多转换：对原 Stream 中的所有元素进行操作，每个元素会有一个或者多个结果，然后将返回的所有元素组合成一个统一的 Stream 并返回；distinct去重：返回一个去重后的 Stream 对象sorted排序：返回排序后的 Stream 对象peek使用传入的 Consumer 对象对所有元素进行消费后，返回一个新的包含所有原来元素的 Stream 对象limit获取有限个元素组成新的 Stream 对象返回skip抛弃前指定个元素后使用剩下的元素组成新的 Stream 返回takeWhile如果 Stream 是有序的（Ordered），那么返回最长命中序列（符合传入的 Predicate 的最长命中序列）组成的 Stream；如果是无序的，那么返回的是所有符合传入的 Predicate 的元素序列组成的 Stream。dropWhile与 takeWhile 相反，如果是有序的，返回除最长命中序列外的所有元素组成的 Stream；如果是无序的，返回所有未命中的元素组成的 Stream。
{: id="20201220214147-gy1ieas"}

所有终端操作
{: id="20201220214147-79xzaxu"}

方法说明iterator返回 Stream 中所有对象的迭代器;spliterator返回对所有对象进行的 spliterator 对象forEach对所有元素进行迭代处理，无返回值forEachOrdered按 Stream 的 Encounter 所决定的序列进行迭代处理，无返回值toArray返回所有元素的数组reduce使用一个初始化的值，与 Stream 中的元素一一做传入的二合运算后返回最终的值。每与一个元素做运算后的结果，再与下一个元素做运算。它不保证会按序列执行整个过程。collect根据传入参数做相关汇聚计算min返回所有元素中最小值的 Optional 对象；如果 Stream 中无任何元素，那么返回的 Optional 对象为 Emptymax与 Min 相反count所有元素个数anyMatch只要其中有一个元素满足传入的 Predicate 时返回 True，否则返回 FalseallMatch所有元素均满足传入的 Predicate 时返回 True，否则 FalsenoneMatch所有元素均不满足传入的 Predicate 时返回 True，否则 FalsefindFirst返回第一个元素的 Optioanl 对象；如果无元素返回的是空的 Optional； 如果 Stream 是无序的，那么任何元素都可能被返回。findAny返回任意一个元素的 Optional 对象，如果无元素返回的是空的 Optioanl。isParallel判断是否当前 Stream 对象是并行的
{: id="20201220214147-m979qat"}

下面就几个比较常用的方法举例说明其用法：
{: id="20201220214147-pwn0z5k"}

#### 3.1.2.1 filter
{: id="20201220214147-gnmi2h6"}

用于对 Stream 中的元素进行过滤，返回一个过滤后的 Stream
{: id="20201220214147-8i0fao2"}

其方法定义如下：
{: id="20201220214147-1799dsw"}

```
Stream<T> filter(Predicate<? super T> predicate);
```
{: id="20201220214147-1aas7ry"}

使用示例：
{: id="20201220214147-5pbfvec"}

```
Stream<String> s = Stream.of("test", "t1", "t2", "teeeee", "aaaa");
//查找所有包含t的元素并进行打印
s.filter(n -> n.contains("t")).forEach(System.out::println);
```
{: id="20201220214147-a47m6c1"}

#### 3.1.2.2 map
{: id="20201220214147-57jhib6"}

元素一对一转换。
{: id="20201220214147-dxozqvi"}

它接收一个 Funcation 参数，用其对 Stream 中的所有元素进行处理，返回的 Stream 对象中的元素为 Function 对原元素处理后的结果
{: id="20201220214147-dshhv3z"}

其方法定义如下：
{: id="20201220214147-rpi5cgf"}

```
<R> Stream<R> map(Function<? super T, ? extends R> mapper);
```
{: id="20201220214147-2igv0ic"}

示例，假设我们要将一个 String 类型的 Stream 对象中的每个元素添加相同的后缀. txt，如 a 变成 a.txt，其写法如下：
{: id="20201220214147-vuld9je"}

```
Stream<String> s = Stream.of("test", "t1", "t2", "teeeee", "aaaa");
s.map(n -> n.concat(".txt")).forEach(System.out::println);
```
{: id="20201220214147-rrz11x3"}

#### 3.1.2.3 flatMap
{: id="20201220214147-7cv3wax"}

元素一对多转换：对原 Stream 中的所有元素使用传入的 Function 进行处理，每个元素经过处理后生成一个多个元素的 Stream 对象，然后将返回的所有 Stream 对象中的所有元素组合成一个统一的 Stream 并返回；
{: id="20201220214147-hd9rzgy"}

方法定义如下：
{: id="20201220214147-d226uk4"}

```
<R> Stream<R> flatMap(Function<? super T, ? extends Stream<? extends R>> mapper);
```
{: id="20201220214147-vfqo4z3"}

示例，假设要对一个 String 类型的 Stream 进行处理，将每一个元素的拆分成单个字母，并打印：
{: id="20201220214147-tmi4e1s"}

```
Stream<String> s = Stream.of("test", "t1", "t2", "teeeee", "aaaa");
s.flatMap(n -> Stream.of(n.split(""))).forEach(System.out::println);
```
{: id="20201220214147-a14s9zo"}

#### 3.1.2.4 takeWhile
{: id="20201220214147-a9i0fzz"}

方法定义如下：
{: id="20201220214147-1qylayy"}

```
default Stream<T> takeWhile(Predicate<? super T> predicate)
```
{: id="20201220214147-ih0301k"}

如果 Stream 是有序的（Ordered），那么返回最长命中序列（符合传入的 Predicate 的最长命中序列）组成的 Stream；如果是无序的，那么返回的是所有符合传入的 Predicate 的元素序列组成的 Stream。
{: id="20201220214147-r0wicv8"}

与 Filter 有点类似，不同的地方就在当 Stream 是有序时，返回的只是最长命中序列。
{: id="20201220214147-1h1t7gy"}

如以下示例，通过 takeWhile 查找”test”, “t1”, “t2”, “teeeee”, “aaaa”, “taaa” 这几个元素中包含 t 的最长命中序列：
{: id="20201220214147-d99bar4"}

```
Stream<String> s = Stream.of("test", "t1", "t2", "teeeee", "aaaa", "taaa");
//以下结果将打印： "test", "t1", "t2", "teeeee"，最后的那个taaa不会进行打印 
s.takeWhile(n -> n.contains("t")).forEach(System.out::println);
```
{: id="20201220214147-efgwfko"}

#### 3.1.2.5 dropWhile
{: id="20201220214147-yq5tiqx"}

与 takeWhile 相反，如果是有序的，返回除最长命中序列外的所有元素组成的 Stream；如果是无序的，返回所有未命中的元素组成的 Stream; 其定义如下：
{: id="20201220214147-rryh10n"}

```
default Stream<T> dropWhile(Predicate<? super T> predicate)
```
{: id="20201220214147-wj8rdpd"}

如以下示例，通过 dropWhile 删除”test”, “t1”, “t2”, “teeeee”, “aaaa”, “taaa” 这几个元素中包含 t 的最长命中序列：
{: id="20201220214147-zj1wg4l"}

```
Stream<String> s = Stream.of("test", "t1", "t2", "teeeee", "aaaa", "taaa");
//以下结果将打印："aaaa", "taaa" 　
s.dropWhile(n -> n.contains("t")).forEach(System.out::println);
```
{: id="20201220214147-fvtjnq3"}

#### 3.1.2.6 reduce 与 collect
{: id="20201220214147-hodsz3y"}

关于 reduce 与 collect 由于功能较为复杂，在后续将进行单独分析与学习，此处暂不涉及。
{: id="20201220214147-8gw5pw7"}

## 3.2 Optional
{: id="20201220214147-gjfpfoi"}

用于简化 Java 中对空值的判断处理，以防止出现各种空指针异常。
{: id="20201220214147-5r80rqz"}

Optional 实际上是对一个变量进行封装，它包含有一个属性 value，实际上就是这个变量的值。
{: id="20201220214147-vjzxnwk"}

### 3.2.1 Optional 对象创建
{: id="20201220214147-zhjfzgw"}

它的构造函数都是 private 类型的，因此要初始化一个 Optional 的对象无法通过其构造函数进行创建。它提供了一系列的静态方法用于构建 Optional 对象:
{: id="20201220214147-x7mn8sm"}

#### 3.2.1.1 empty
{: id="20201220214147-1kr0r06"}

用于创建一个空的 Optional 对象；其 value 属性为 Null。
{: id="20201220214147-f83se2c"}

如：
{: id="20201220214147-ba3ut0p"}

```
Optional o = Optional.empty();
```
{: id="20201220214147-d32ray3"}

#### 3.2.1.2 of
{: id="20201220214147-v28doxl"}

根据传入的值构建一个 Optional 对象;
{: id="20201220214147-d36kt2w"}

传入的值必须是非空值，否则如果传入的值为空值，则会抛出空指针异常。
{: id="20201220214147-1tmry10"}

使用：
{: id="20201220214147-m5808de"}

```
o = Optional.of("test"); 
```
{: id="20201220214147-igvg46q"}

#### 3.2.1.3 ofNullable
{: id="20201220214147-6jjpz1k"}

根据传入值构建一个 Optional 对象
{: id="20201220214147-hr9n8vv"}

传入的值可以是空值，如果传入的值是空值，则与 empty 返回的结果是一样的。
{: id="20201220214147-kt40skj"}

### 3.2.2 方法
{: id="20201220214147-5a8uan5"}

Optional 包含以下方法：
{: id="20201220214147-nnkcyyz"}

方法名说明get获取 Value 的值，如果 Value 值是空值，则会抛出 NoSuchElementException 异常；因此返回的 Value 值无需再做空值判断，只要没有抛出异常，都会是非空值。isPresentValue 是否为空值的判断；ifPresent当 Value 不为空时，执行传入的 Consumer；ifPresentOrElseValue 不为空时，执行传入的 Consumer；否则执行传入的 Runnable 对象；filter当 Value 为空或者传入的 Predicate 对象调用 test(value) 返回 False 时，返回 Empty 对象；否则返回当前的 Optional 对象map一对一转换：当 Value 为空时返回 Empty 对象，否则返回传入的 Function 执行 apply(value) 后的结果组装的 Optional 对象；flatMap一对多转换：当 Value 为空时返回 Empty 对象，否则传入的 Function 执行 apply(value) 后返回的结果（其返回结果直接是 Optional 对象）or如果 Value 不为空，则返回当前的 Optional 对象；否则，返回传入的 Supplier 生成的 Optional 对象；stream如果 Value 为空，返回 Stream 对象的 Empty 值；否则返回 Stream.of(value) 的 Stream 对象；orElseValue 不为空则返回 Value，否则返回传入的值；orElseGetValue 不为空则返回 Value，否则返回传入的 Supplier 生成的值；orElseThrowValue 不为空则返回 Value，否则抛出 Supplier 中生成的异常对象；
{: id="20201220214147-dv94uxr"}

### 3.2.3 使用场景
{: id="20201220214147-ppfr1q9"}

常用的使用场景如下：
{: id="20201220214147-7rnidmc"}

#### 3.2.3.1 判断结果不为空后使用
{: id="20201220214147-4may9wp"}

如某个函数可能会返回空值，以往的做法：
{: id="20201220214147-jlytpq9"}

```
String s = test();
if (null != s) {
    System.out.println(s);
}
```
{: id="20201220214147-2nwub9u"}

现在的写法就可以是：
{: id="20201220214147-gsx3z0l"}

```
Optional<String> s = Optional.ofNullable(test());
s.ifPresent(System.out::println);
```
{: id="20201220214147-x45zcdi"}

乍一看代码复杂度上差不多甚至是略有提升；那为什么要这么做呢？
{: id="20201220214147-vf14vfp"}

一般情况下，我们在使用某一个函数返回值时，要做的第一步就是去分析这个函数是否会返回空值；如果没有进行分析或者分析的结果出现偏差，导致函数会抛出空值而没有做检测，那么就会相应的抛出空指针异常！
{: id="20201220214147-ihzxt2r"}

而有了 Optional 后，在我们不确定时就可以不用去做这个检测了，所有的检测 Optional 对象都帮忙我们完成，我们要做的就是按上述方式去处理。
{: id="20201220214147-xeqc40p"}

#### 3.2.3.2 变量为空时提供默认值
{: id="20201220214147-al0vr0x"}

如要判断某个变量为空时使用提供的值，然后再针对这个变量做某种运算；
{: id="20201220214147-6druvnk"}

以往做法：
{: id="20201220214147-raanjpo"}

```
if (null == s) {
    s = "test";
}
System.out.println(s);
```
{: id="20201220214147-yqd2gnq"}

现在的做法：
{: id="20201220214147-u9l4jlg"}

```
Optional<String> o = Optional.ofNullable(s);
System.out.println(o.orElse("test"));
```
{: id="20201220214147-giy8czg"}

#### 3.2.3.3 变量为空时抛出异常，否则使用
{: id="20201220214147-2lp380j"}

以往写法：
{: id="20201220214147-rbjztoh"}

```
if (null == s) {
    thrownew Exception("test");
}
System.out.println(s);
```
{: id="20201220214147-iixwu2z"}

现在写法：
{: id="20201220214147-mcmcr47"}

```
Optional<String> o = Optional.ofNullable(s);
System.out.println(o.orElseThrow(()->new Exception("test")));
```
{: id="20201220214147-kz41jk0"}

其它场景待补充。
{: id="20201220214147-9ob2r53"}

原文：https://blog.csdn.net/icarusliu/article/details/79495534
{: id="20201220214147-4ey3po5"}


{: id="20201220214147-sjdmyyv" type="doc"}
