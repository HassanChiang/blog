---

title: MySQL 中的 Character Set 与 Collation
date: 2020-09-12
description:
{: id="20201220214147-tn0obke"}

tags:
{: id="20201220214147-490e80i"}

- {: id="20201220214147-0wun9xx"}MySQL
- {: id="20201220214147-t9i3fu7"}字符集
- {: id="20201220214147-d6vslpx"}Collation
{: id="20201220214147-oezsq84"}

nav:
{: id="20201220214147-ueykp7s"}

- {: id="20201220214147-fvl3jya"}数据库
{: id="20201220214147-cupq19x"}

categories:
{: id="20201220214147-ppehy9b"}

- {: id="20201220214147-jtfl376"}MySQL
{: id="20201220214147-x8umjq6"}

image: images/MySQL.png
{: id="20201220214147-b2pw1us"}

---

## 背景
{: id="20201220214147-lcph26k"}

MySQL 应该算是目前最流行的数据库之一，经常建库建表的同学应该对 Character Set 和 Collation 这两个词不陌生。
{: id="20201220214147-ucir8ci"}

虽然一直有接触，但我还是挺云里雾里的。直到前些天特地做了功课，才敢说有个比较清晰的了解，所以就有了这篇文章。
{: id="20201220214147-ngzdnv5"}

## Character Set 与 Collation
{: id="20201220214147-z05jkw9"}

简单地说，Character Set 是字符集，而 Collation 是比对方法，是两个不同维度的概念。
{: id="20201220214147-0p0gafx"}

我们经常看到的 utf8、gbk、ascii 都是相互独立的字符集，即对 [Unicode](https://link.zhihu.com/?target=https%3A//zh.wikipedia.org/wiki/Unicode) 的一套编码。看到一个比较有趣的解释，摘抄过来。
{: id="20201220214147-mawlap9"}

> 打个比方，你眼前有一个苹果，苹果在英文里称之为「Apple」，在中文里称之为「苹果」。苹果这个实体的概念就是 Unicode，而 utf8 之类的可以认为是不同语言对苹果的不同称谓，本质上都是描述苹果这个实体。
> {: id="20201220214147-72bgirt"}
{: id="20201220214147-aujdunv"}

每套字符集有一系列与之对应的比对方法，比如 utf8 字符集对应 utf8_general_ci、utf8_unicode_ci 等比对方法，不同的比对方法下得到的搜索结果、排序结果不尽相同。
{: id="20201220214147-wntcafv"}

## utf8 与 utf8mb4
{: id="20201220214147-r0lfu29"}

抛开数据库，标准的 UTF-8 字符集编码是可以用 1 ~ 4 个字节去编码 21 位字符，这几乎包含了世界上所有能看见的语言。
{: id="20201220214147-9e7f3mz"}

然而 MySQL 中实现的 utf8 最长只使用了 3 个字节，也就是只支持到了 Unicode 中的 [基本多文本平面](https://link.zhihu.com/?target=https%3A//zh.wikipedia.org/wiki/Unicode%25E5%25AD%2597%25E7%25AC%25A6%25E5%25B9%25B3%25E9%259D%25A2%25E6%2598%25A0%25E5%25B0%2584)。任何不在基本多文本平面的 Unicode 字符，都无法使用 MySQL 的 utf8 字符集存储。包括 Emoji 表情、一些不常用的汉字，以及任何新增的 Unicode 字符等等。
{: id="20201220214147-2ghimfx"}

为了解决这个问题，MySQL 在 5.5.3 之后增加了 `utf8mb4` 字符编码，mb4 即 most bytes 4。简单说 utf8mb4 是 utf8 的超集并完全兼容 utf8，能够用四个字节存储更多的字符。[官方手册](https://link.zhihu.com/?target=https%3A//dev.mysql.com/doc/refman/5.6/en/charset-unicode-utf8mb4.html) 中也有提到 utf8mb4 的解释，我摘抄部分过来。
{: id="20201220214147-9bqif86"}

> The `utfmb4` character set has these characteristics:
> {: id="20201220214147-0pkkgaw"}
{: id="20201220214147-5xjvkld"}

- {: id="20201220214147-1u90uqm"}Supports BMP and supplementary characters.
- {: id="20201220214147-ldcdslk"}Requires a maximum of four bytes per multibyte character.
{: id="20201220214147-f6d535z"}

`utf8mb4` contrasts with the `utf8mb3` character set, which supports only BMP characters and uses a maximum of three bytes per character:
{: id="20201220214147-b20vmzu"}

- {: id="20201220214147-c1nugas"}For a BMP character, `utf8mb4` and `utf8mb3` have identical storage characteristics: same code values, same encoding, same length.
- {: id="20201220214147-lmn1kib"}For a supplementary character, `utf8mb4` requires four bytes to store it, whereas `utf8mb3` cannot store the character at all. When converting `utf8mb3` columns to `utf8mb4`, you need not worry about converting supplementary characters because there will be none.
{: id="20201220214147-ezgp3bh"}

## utf8mb4_general_ci 与 utf8mb4_unicode_ci
{: id="20201220214147-43kh0bm"}

utf8mb4 对应的比对方法中，常用的有 `utf8mb4_general_ci` 和 `utf8mb4_unicode_ci`。关于这两个的区别，可以看下 StackOverflow 上有一个相关的热门讨论：[What’s the difference between utf8_general_ci and utf8_unicode_ci](https://link.zhihu.com/?target=https%3A//stackoverflow.com/questions/766809/whats-the-difference-between-utf8-general-ci-and-utf8-unicode-ci)，这边引用一下 [Sean’s Notes](https://link.zhihu.com/?target=http%3A//seanlook.com/) 的翻译：
{: id="20201220214147-fwh2xa5"}

主要从排序准确性和性能两方面看：
{: id="20201220214147-mdmp21e"}

- {: id="20201220214147-ogaqwg8"}准确性
  {: id="20201220214147-ys33jae"}
- {: id="20201220214147-1ky0eja"}`utf8mb4_unicode_ci` 基于标准的 Unicode 来排序和比较，能够在各种语言之间精确排序。
  {: id="20201220214147-25kh4mj"}
- {: id="20201220214147-w426u30"}`utf8mb4_general_ci` 没有实现 Unicode 排序规则，在遇到某些特殊语言或字符时，排序结果可能不是所期望的。
  {: id="20201220214147-ph3rfdl"}
- {: id="20201220214147-ntc5bfq"}但是在绝大多数情况下，这种特殊字符的顺序可能不需要那么精确。比如 `*_unicode_ci` 把 `ß`、`Œ` 当成 `ss` 和 `OE` 来看，而 `*_general_ci` 会把它们当成 `s`、`e`，再如 `ÀÁÅåāă` 各自都与 `A` 相等。
  {: id="20201220214147-k8xlnm2"}
- {: id="20201220214147-gtecw2s"}性能
  {: id="20201220214147-31w6gcr"}
- {: id="20201220214147-wmrirbt"}`utf8mb4_general_ci` 在比较和排序的时候更快。
  {: id="20201220214147-7njfg0v"}
- {: id="20201220214147-emv7fhq"}`utf8mb4_unicode_ci` 在特殊情况下，Unicode 排序规则为了能够处理特殊字符的情况，实现了略微复杂的排序算法。
  {: id="20201220214147-3pfvlws"}
- {: id="20201220214147-porvnet"}但是在绝大多数情况下，不会发生此类复杂比较。`*_general_ci` 理论上比 `*_unicode_ci` 可能快些，但相比现在的 CPU 来说，它远远不足以成为考虑性能的因素，索引涉及、SQL 设计才是。 我个人推荐是 `utf8mb4_unicode_ci`，将来 8.0 里也极有可能使用变为默认的规则。相比选择哪一种 collation，使用者应该更关心字符集与排序规则在数据库里的统一性。
  {: id="20201220214147-9xxjpf7"}
{: id="20201220214147-3hqii4y"}

## 小结
{: id="20201220214147-r1f4l4m"}

出于兼容性的考虑，对存储空间和性能没有特殊要求的场合下，建议使用 `utf8mb4` 字符集和 `utf8mb4_unicode_ci` 对比方法。
{: id="20201220214147-wfxwa8w"}

原文：https://zhuanlan.zhihu.com/p/64570524
{: id="20201220214147-frc6egi"}


{: id="20201220214147-6zxhqna" type="doc"}
