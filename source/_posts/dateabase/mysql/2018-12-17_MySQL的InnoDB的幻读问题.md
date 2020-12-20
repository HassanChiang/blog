---

title: MySQL的InnoDB的幻读问题
date: 2018-12-17
description:
{: id="20201220214147-ph167pg"}

tags:
{: id="20201220214147-9klqjsl"}

- {: id="20201220214147-bqgx0db"}MySQL
- {: id="20201220214147-ywjx7ys"}ACID
- {: id="20201220214147-g0nu74d"}幻读
{: id="20201220214147-nceq1uy"}

nav:
{: id="20201220214147-8amr6gp"}

- {: id="20201220214147-sxpfa4l"}数据库
{: id="20201220214147-swlt1s9"}

categories:
{: id="20201220214147-5cb55t3"}

- {: id="20201220214147-6exud1a"}MySQL
{: id="20201220214147-57n9hlv"}

image: images/MySQL.png
{: id="20201220214147-nyyns1o"}

---

[MySQL InnoDB事务的隔离级别](http://dev.mysql.com/doc/refman/5.0/en/set-transaction.html)有四级，默认是“可重复读”（REPEATABLE READ）。
{: id="20201220214147-v5oots4"}

* {: id="20201220214147-006fceo"}未提交读（READ UNCOMMITTED）。另一个事务修改了数据，但尚未提交，而本事务中的SELECT会读到这些未被提交的数据（脏读）。
* {: id="20201220214147-kcd81ca"}提交读（READ COMMITTED）。本事务读取到的是最新的数据（其他事务提交后的）。问题是，在同一个事务里，前后两次相同的SELECT会读到不同的结果（不重复读）。
* {: id="20201220214147-ogkmg07"}可重复读（REPEATABLE READ）。在同一个事务里，SELECT的结果是事务开始时时间点的状态，因此，同样的SELECT操作读到的结果会是一致的。但是，会有幻读现象（稍后解释）。
* {: id="20201220214147-8yk7xmi"}串行化（SERIALIZABLE）。读操作会隐式获取共享锁，可以保证不同事务间的互斥。
{: id="20201220214147-cudidn4"}

四个级别逐渐增强，每个级别解决一个问题。
{: id="20201220214147-canxgzm"}

* {: id="20201220214147-3ujjz2i"}脏读，最容易理解。另一个事务修改了数据，但尚未提交，而本事务中的SELECT会读到这些未被提交的数据。
* {: id="20201220214147-34396ep"}不重复读。解决了脏读后，会遇到，同一个事务执行过程中，另外一个事务提交了新数据，因此本事务先后两次读到的数据结果会不一致。
* {: id="20201220214147-vver7p2"}幻读。解决了不重复读，保证了同一个事务里，查询的结果都是事务开始时的状态（一致性）。但是，如果另一个事务同时提交了新数据，本事务再更新时，就会“惊奇的”发现了这些新数据，貌似之前读到的数据是“鬼影”一样的幻觉。
{: id="20201220214147-2wwr279"}

借鉴并改造了一个搞笑的比喻：
{: id="20201220214147-ew7mdsr"}

* {: id="20201220214147-9l5a8jz"}脏读。假如，中午去食堂打饭吃，看到一个座位被同学小Q占上了，就认为这个座位被占去了，就转身去找其他的座位。不料，这个同学小Q起身走了。事实：该同学小Q只是临时坐了一小下，并未“提交”。
* {: id="20201220214147-rwr6iib"}不重复读。假如，中午去食堂打饭吃，看到一个座位是空的，便屁颠屁颠的去打饭，回来后却发现这个座位却被同学小Q占去了。
* {: id="20201220214147-i44rnq0"}幻读。假如，中午去食堂打饭吃，看到一个座位是空的，便屁颠屁颠的去打饭，回来后，发现这些座位都还是空的（重复读），窃喜。走到跟前刚准备坐下时，却惊现一个恐龙妹，严重影响食欲。仿佛之前看到的空座位是“幻影”一样。
{: id="20201220214147-k0hzxrn"}

---

一些文章写到InnoDB的可重复读避免了“幻读”（phantom read），这个说法并不准确。
{: id="20201220214147-ayu9dia"}

做个试验：(以下所有试验要注意存储引擎和隔离级别)
{: id="20201220214147-szhm19h"}

> mysql> show create table t_bitfly\G;
> CREATE TABLE `t_bitfly` (
> `id` bigint(20) NOT NULL default '0',
> `value` varchar(32) default NULL,
> PRIMARY KEY (`id`)
> ) ENGINE=InnoDB DEFAULT CHARSET=gbk
> {: id="20201220214147-kuhecb7"}
>
> mysql> select @@global.tx_isolation, @@tx_isolation;
> +-----------------------+-----------------+
> | @@global.tx_isolation | @@tx_isolation  |
> +-----------------------+-----------------+
> | REPEATABLE-READ       | REPEATABLE-READ |
> +-----------------------+-----------------+
> {: id="20201220214147-h0uest7"}
{: id="20201220214147-1ys9vx0"}

试验一：
{: id="20201220214147-qm1hxsu"}

> t Session A                                   Session B
> |
> | START TRANSACTION;            START TRANSACTION;
> |
> | SELECT * FROM t_bitfly;
> | empty set
> |                                                             INSERT INTO t_bitfly
> |                                                             VALUES (1, 'a');
> |
> | SELECT * FROM t_bitfly;
> | empty set
> |                                                             COMMIT;
> |
> | SELECT * FROM t_bitfly;
> | empty set
> |
> | INSERT INTO t_bitfly VALUES (1, 'a');
> | ERROR 1062 (23000):
> | Duplicate entry '1' for key 1
> v (shit, 刚刚明明告诉我没有这条记录的)
> {: id="20201220214147-nnngj04"}
{: id="20201220214147-eojmmod"}

如此就出现了幻读，以为表里没有数据，其实数据已经存在了，傻乎乎的提交后，才发现数据冲突了。
{: id="20201220214147-4ab055a"}

试验二：
{: id="20201220214147-sxqtlx6"}

> t Session A                                      Session B
> |
> | START TRANSACTION;              START TRANSACTION;
> |
> | SELECT * FROM t_bitfly;
> | +------+-------+
> | | id   | value |
> | +------+-------+
> | |    1 | a     |
> | +------+-------+
> |                                                            INSERT INTO t_bitfly
> |                                                            VALUES (2, 'b');
> |
> | SELECT * FROM t_bitfly;
> | +------+-------+
> | | id   | value |
> | +------+-------+
> | |    1 | a     |
> | +------+-------+
> |                                                            COMMIT;
> |
> | SELECT * FROM t_bitfly;
> | +------+-------+
> | | id   | value |
> | +------+-------+
> | |    1 | a     |
> | +------+-------+
> |
> | UPDATE t_bitfly SET value='z';
> | Rows matched: 2  Changed: 2  Warnings: 0
> | (怎么多出来一行)
> |
> | SELECT * FROM t_bitfly;
> | +------+-------+
> | | id   | value |
> | +------+-------+
> | |    1 | z     |
> | |    2 | z     |
> | +------+-------+
> |
> v
> {: id="20201220214147-hboz6r0"}
{: id="20201220214147-7hrgmyc"}

本事务中第一次读取出一行，做了一次更新后，另一个事务里提交的数据就出现了。也可以看做是一种幻读。
{: id="20201220214147-dfkvbl4"}

---

那么，InnoDB指出的可以避免幻读是怎么回事呢？
{: id="20201220214147-mjjdar3"}

> [http://dev.mysql.com/doc/refman/5.0/en/innodb-record-level-locks.html](http://dev.mysql.com/doc/refman/5.0/en/innodb-record-level-locks.html)
> {: id="20201220214147-3sthcj1"}
>
> By default, InnoDB operates in REPEATABLE READ transaction isolation level and with the innodb_locks_unsafe_for_binlog system variable disabled. In this case, InnoDB uses next-key locks for searches and index scans, which prevents phantom rows (see Section 13.6.8.5, “Avoiding the Phantom Problem Using Next-Key Locking”).
> {: id="20201220214147-xwavxz5"}
{: id="20201220214147-m0gk6xk"}

准备的理解是，当隔离级别是可重复读，且禁用innodb_locks_unsafe_for_binlog的情况下，在搜索和扫描index的时候使用的next-key locks可以避免幻读。
{: id="20201220214147-cdw2cu8"}

关键点在于，是InnoDB默认对一个普通的查询也会加next-key locks，还是说需要应用自己来加锁呢？如果单看这一句，可能会以为InnoDB对普通的查询也加了锁，如果是，那和序列化（SERIALIZABLE）的区别又在哪里呢？
{: id="20201220214147-zqmsxud"}

MySQL manual里还有一段：
{: id="20201220214147-p674jtk"}

> 13.2.8.5\. Avoiding the Phantom Problem Using Next-Key Locking ([http://dev.mysql.com/doc/refman/5.0/en/innodb-next-key-locking.html](http://dev.mysql.com/doc/refman/5.0/en/innodb-next-key-locking.html))
> {: id="20201220214147-q02gkr8"}
>
> To prevent phantoms, `InnoDB` uses an algorithm called _next-key locking_ that combines index-row locking with gap locking.
> {: id="20201220214147-da3s61y"}
>
> You can use next-key locking to implement a uniqueness check in your application: If you read your data in share mode and do not see a duplicate for a row you are going to insert, then you can safely insert your row and know that the next-key lock set on the successor of your row during the read prevents anyone meanwhile inserting a duplicate for your row. Thus, the next-key locking enables you to “<span style="padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px;">lock</span>” the nonexistence of something in your table.
> {: id="20201220214147-o1fycpv"}
{: id="20201220214147-xfls53j"}

我的理解是说，InnoDB提供了next-key locks，但需要应用程序自己去加锁。manual里提供一个例子：
{: id="20201220214147-0u39md2"}

> SELECT * FROM child WHERE id > 100 FOR UPDATE;
> {: id="20201220214147-595hiwy"}
{: id="20201220214147-m39m59v"}

这样，InnoDB会给id大于100的行（假如child表里有一行id为102），以及100-102，102+的gap都加上锁。
{: id="20201220214147-i0pkwdl"}

可以使用show innodb status来查看是否给表加上了锁。
{: id="20201220214147-6xayj1b"}

再看一个实验，要注意，表t_bitfly里的id为主键字段。实验三：
{: id="20201220214147-f73e8o9"}

> t Session A                                       Session B
> |
> | START TRANSACTION;                START TRANSACTION;
> |
> | SELECT * FROM t_bitfly
> | WHERE id&lt;=1
> | FOR UPDATE;
> | +------+-------+
> | | id   | value |
> | +------+-------+
> | |    1 | a     |
> | +------+-------+
> |                                                           INSERT INTO t_bitfly
> |                                                           VALUES (2, 'b');
> |                                                           Query OK, 1 row affected
> |
> | SELECT * FROM t_bitfly;
> | +------+-------+
> | | id   | value |
> | +------+-------+
> | |    1 | a     |
> | +------+-------+
> |                                                           INSERT INTO t_bitfly
> |                                                           VALUES (0, '0');
> |                                                           (waiting for lock ...
> |                                                           then timeout)
> |                                                           ERROR 1205 (HY000):
> |                                                           Lock wait timeout exceeded;
> |                                                           try restarting transaction
> |
> | SELECT * FROM t_bitfly;
> | +------+-------+
> | | id   | value |
> | +------+-------+
> | |    1 | a     |
> | +------+-------+
> |                                                           COMMIT;
> |
> | SELECT * FROM t_bitfly;
> | +------+-------+
> | | id   | value |
> | +------+-------+
> | |    1 | a     |
> | +------+-------+
> v
> {: id="20201220214147-b3x1vsm"}
{: id="20201220214147-kb4pn4h"}

可以看到，用id<=1加的锁，只锁住了id<=1的范围，可以成功添加id为2的记录，添加id为0的记录时就会等待锁的释放。
{: id="20201220214147-0huth5d"}

MySQL manual里对可重复读里的锁的详细解释：
{: id="20201220214147-1ae4gwh"}

> [http://dev.mysql.com/doc/refman/5.0/en/set-transaction.html#isolevel_repeatable-read](http://dev.mysql.com/doc/refman/5.0/en/set-transaction.html#isolevel_repeatable-read)
> {: id="20201220214147-i25zcko"}
>
> For locking reads ([`SELECT`](http://dev.mysql.com/doc/refman/5.0/en/select.html "12.2.8\. SELECT Syntax") with `FOR UPDATE` or `LOCK IN SHARE MODE`),[`UPDATE`](http://dev.mysql.com/doc/refman/5.0/en/update.html "12.2.11\. UPDATE Syntax"), and [`DELETE`](http://dev.mysql.com/doc/refman/5.0/en/delete.html "12.2.2\. DELETE Syntax") statements, locking depends on whether the statement uses a unique index with a unique search condition, or a range-type search condition. For a unique index with a unique search condition, `InnoDB` locks only the index record found, not the gap before it. For other search conditions, `InnoDB` locks the index range scanned, using gap locks or next-key (gap plus index-record) locks to block insertions by other sessions into the gaps covered by the range.
> {: id="20201220214147-fkqqq8r"}
{: id="20201220214147-9ac65jx"}

---

一致性读和提交读，先看实验，实验四：
{: id="20201220214147-aifsej2"}

> t Session A                                                          Session B
> |
> | START TRANSACTION;                             START TRANSACTION;
> |
> | SELECT * FROM t_bitfly;
> | +----+-------+
> | | id | value |
> | +----+-------+
> | |  1 | a     |
> | +----+-------+
> |                                                                        INSERT INTO t_bitfly
> |                                                                                VALUES (2, 'b');
> |                                                                        COMMIT;
> |
> | SELECT * FROM t_bitfly;
> | +----+-------+
> | | id | value |
> | +----+-------+
> | |  1 | a     |
> | +----+-------+
> |
> | SELECT * FROM t_bitfly LOCK IN SHARE MODE;
> | +----+-------+
> | | id | value |
> | +----+-------+
> | |  1 | a     |
> | |  2 | b     |
> | +----+-------+
> |
> | SELECT * FROM t_bitfly FOR UPDATE;
> | +----+-------+
> | | id | value |
> | +----+-------+
> | |  1 | a     |
> | |  2 | b     |
> | +----+-------+
> |
> | SELECT * FROM t_bitfly;
> | +----+-------+
> | | id | value |
> | +----+-------+
> | |  1 | a     |
> | +----+-------+
> v
> {: id="20201220214147-vnd7r2s"}
{: id="20201220214147-kt4rlvg"}

如果使用普通的读，会得到一致性的结果，如果使用了加锁的读，就会读到“最新的”“提交”读的结果。
{: id="20201220214147-2hws0ig"}

本身，可重复读和提交读是矛盾的。在同一个事务里，如果保证了可重复读，就会看不到其他事务的提交，违背了提交读；如果保证了提交读，就会导致前后两次读到的结果不一致，违背了可重复读。
{: id="20201220214147-nx3rijy"}

可以这么讲，InnoDB提供了这样的机制，在默认的可重复读的隔离级别里，可以使用加锁读去查询最新的数据。
{: id="20201220214147-ax1j52x"}

> [http://dev.mysql.com/doc/refman/5.0/en/innodb-consistent-read.html](http://dev.mysql.com/doc/refman/5.0/en/innodb-consistent-read.html)
> {: id="20201220214147-ud7gvxf"}
>
> If you want to see the “freshest” state of the database, you should use either the READ COMMITTED isolation level or a locking read:
> SELECT * FROM t_bitfly LOCK IN SHARE MODE;
> {: id="20201220214147-l4wra6c"}
{: id="20201220214147-msminmc"}

---

结论：MySQL InnoDB的可重复读并不保证避免幻读，需要应用使用加锁读来保证。而这个加锁度使用到的机制就是next-key locks。
{: id="20201220214147-exs9fj8"}

==================== 结尾 ====================
{: id="20201220214147-om0aim7"}

作者: bitfly. 转载请注明来源或包含本信息. 谢谢
链接: http://blog.bitfly.cn/post/mysql-innodb-phantom-read/
{: id="20201220214147-qd4pu97"}


{: id="20201220214147-hl8yx4z" type="doc"}
