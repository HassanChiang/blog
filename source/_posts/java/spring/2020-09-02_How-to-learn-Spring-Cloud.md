---

title: How to learn Spring Cloud – the practical way
date: 2020-09-02
description:
{: id="20201220214147-7jb4b12"}

tags:
{: id="20201220214147-dalid6j"}

- {: id="20201220214147-ooqtc4q"}Java
- {: id="20201220214147-57l81xc"}Spring
- {: id="20201220214147-do2dy94"}Spring Cloud
{: id="20201220214147-rsszg6n"}

nav:
{: id="20201220214147-g84wquh"}

- {: id="20201220214147-wslfjki"}Spring
{: id="20201220214147-ru1i6hi"}

categories:
{: id="20201220214147-655jlnu"}

- {: id="20201220214147-3uahcd2"}Spring Cloud
{: id="20201220214147-yitu12d"}

image: images/java/spring-framework.png
{: id="20201220214147-22gsyfa"}

---

I have recently spoken at a meetup about [Practical Choreography with Spring Cloud Stream](https://www.e4developer.com/2018/02/20/practical-choreography-with-spring-cloud-presentation/). It was a great event where I was asked many questions after the talk. One question got me thinking: *“What book about Spring Cloud do you recommend?” *which as it turns out boils down to *“How do you learn Spring Cloud?”.* I heard that question posed a few times before in different ways. Here, I will give you my answer on what I think is the best way of learning Spring Cloud.
{: id="20201220214147-6je4vsk"}

With Spring Cloud being probably the hottest framework on JVM for integrating microservices, the interest in it is growing. Most people interested in the microservices are already familiar with Spring Boot. If you haven’t heard of it before, check out my [Spring Boot introduction](https://www.e4developer.com/2018/01/16/microservices-toolbox-spring-boot/) blog post, and definitely see the [official site](https://projects.spring.io/spring-boot/)– it has some very good *Getting Started Guides*.
{: id="20201220214147-wajkss6"}

With that out of the way, let’s look at learning Spring Cloud!
{: id="20201220214147-w1isuv6"}

### Understand the Scope
{: id="20201220214147-stperhw"}

The first thing to do when trying to learn something so big and diverse is understanding the scope. Learning Spring Cloud can mean many things. First of all, the Spring Cloud currently contains:
{: id="20201220214147-yb1zu0p"}

- {: id="20201220214147-mqs24oj"}Spring Cloud Config
- {: id="20201220214147-ur7td17"}Spring Cloud Netflix
- {: id="20201220214147-eljd9rj"}Spring Cloud Bus
- {: id="20201220214147-tpmdafa"}Spring Cloud for Cloud Foundry
- {: id="20201220214147-9o38q9o"}Spring Cloud Cloud Foundry Service Broker
- {: id="20201220214147-vqa0dz2"}Spring Cloud Cluster
- {: id="20201220214147-7h4nzx8"}Spring Cloud Consul
- {: id="20201220214147-7mfoejt"}Spring Cloud Security
- {: id="20201220214147-siukdtv"}Spring Cloud Sleuth
- {: id="20201220214147-6j3qp07"}Spring Cloud Data Flow
- {: id="20201220214147-h8nijzd"}Spring Cloud Stream
- {: id="20201220214147-mx2gq1g"}Spring Cloud Stream App Starters
- {: id="20201220214147-z1rzque"}Spring Cloud Task
- {: id="20201220214147-1jf4jq3"}Spring Cloud Task App Starters
- {: id="20201220214147-go4gtif"}Spring Cloud Zookeeper
- {: id="20201220214147-82m4lim"}Spring Cloud for Amazon Web Services
- {: id="20201220214147-8zcto2g"}Spring Cloud Connectors
- {: id="20201220214147-sa8nj5j"}Spring Cloud Starters
- {: id="20201220214147-n1k8p86"}Spring Cloud CLI
- {: id="20201220214147-ng2x3vz"}Spring Cloud Contract
- {: id="20201220214147-e4fqsq0"}Spring Cloud Gateway
{: id="20201220214147-gu66csj"}

Wow! This is a lot to take in! Clearly, the number of different projects here means that you can’t learn it by simply going through them one by one with a hope of understanding or mastering Spring Cloud by the end of it.
{: id="20201220214147-ufb5l19"}

So, what is the best strategy for learning such an extensive framework (or a [microservice blueprint](https://www.e4developer.com/2018/01/22/spring-cloud-blueprint-for-successful-microservices/), as I describe it in another article)? I think the most sensible ways of learning is understanding what you would like to use Spring Cloud for. Setting yourself a learning goal.
{: id="20201220214147-9nwpgqo"}

### Goal Oriented Learning
{: id="20201220214147-6vnjs6j"}

What kind of learning goals are we talking about here? Let me give you a few ideas:
{: id="20201220214147-eiwi9w2"}

- {: id="20201220214147-9m13i31"}Set up communication between microservices based on Spring Cloud Stream
- {: id="20201220214147-6rcpoyo"}Build microservices that use configuration provided by Spring Cloud Config
- {: id="20201220214147-lj0c2np"}Build a small microservices system based on Orchestration- what is needed and how to use it
- {: id="20201220214147-k6sihsi"}Test microservices with Spring Cloud Contract
- {: id="20201220214147-0f6xkma"}Use Spring Cloud Data Flow to take data from one place, modify it and store it in Elastic Search
{: id="20201220214147-ct7tz5s"}

If you are interested in learning some parts of Spring Cloud, think of an absolutely tiny project and build it! Once you have done it, you know that you understood at least the basics and you validated it by having something working. I will quote Stephen R. Covey here (author of  *“The 7 Habits of Highly Effective People”*):
{: id="20201220214147-t5fdya7"}

> “to learn and not to do is really not to learn. To know and not to do is really not to know.”
> {: id="20201220214147-flrnx5k"}
{: id="20201220214147-0u9q92t"}

With topics as complex and broad as Spring Cloud, this quote rings very true!
{: id="20201220214147-a5fhh9e"}

### Study
{: id="20201220214147-q6vp188"}

You picked your goal and you want to get started. What resources can help you? I will give you a few ideas here, but remember- the goal is to learn only as much as necessary in order to achieve your goal. Don’t learn much more just yet, as you may end up overwhelmed and move further away from completing your goal. There will be time to learn more in depth. Let’s assume that your goal is *Using Spring Cloud Config correctly* in your personal project. Here are the resources I recommend:
{: id="20201220214147-ttz9p7e"}

- {: id="20201220214147-ah929mp"}Official [Spring Cloud Config Quickstart](https://cloud.spring.io/spring-cloud-config/#quick-start) to get a basic idea
- {: id="20201220214147-y3wlf58"}If you enjoy books and want to learn more Spring Cloud in the future – [Spring Microservices in Action](https://www.manning.com/books/spring-microservices-in-action) is a great reference. Don’t read it all yet! Check out the chapters on Spring Cloud Configuration and read as much as necessary to know what to do.
- {: id="20201220214147-nvn1219"}If you use Pluralsight, then check out [Java Microservices with Spring Cloud: Developing Services](https://app.pluralsight.com/library/courses/java-microservices-spring-cloud-developing-services) – a very good introduction! Again, start with the chapters on Spring Cloud Config.
- {: id="20201220214147-b3qtbvx"}You can google the topic and find articles like [Quick Intro to Spring Cloud Configuration](http://www.baeldung.com/spring-cloud-configuration)
- {: id="20201220214147-uj4hjl2"}You can even find [YouTube videos about Spring Cloud Config](https://www.youtube.com/watch?v=b2ih5RCuxTM)
{: id="20201220214147-ttn4uy0"}

I really want to make a point here. There is a huge amount of resources out there, free or paid of very high quality. You can spend weeks just reviewing them, but this is a mistake. Chose what works for you and get moving towards your goal!
{: id="20201220214147-6q6a3kk"}

### Do something – achieve your goal
{: id="20201220214147-f3w6n7y"}

Once you identified the resources you need, get on with your goal! If your goal was to learn about Spring Cloud Config- set up the server, get the clients connecting and experiment with it.
{: id="20201220214147-lh5z9rt"}

You should have enough information to complete your simple task. If you find that something is not working- great! That shows that you need to revisit the resources and correct your understanding.
{: id="20201220214147-ft61ze0"}

If you completed your goal, but you want to experiment more with the tech- go for it! You have something working and playing with it is much more fun than reading dry tech documentation.
{: id="20201220214147-59cxc7n"}

By playing with the technology you start to notice nuances and develop a deeper understanding. Understanding that will not be easily acquired by reading countless articles, as most things would just fly over your head.
{: id="20201220214147-3bz77a7"}

### Study Again
{: id="20201220214147-zr8ujwp"}

Once you completed your goal and played a little with the tech you should have a much better idea what you are dealing with. Now is the time to go deep! Read all you can around the area that you explored. See what you could have done differently, how it is used and what are the best practices.
{: id="20201220214147-hmwm1up"}

Now, all the reading you will do will make much more sense and will be more memorable. Suddenly dry documentation turns into fascinating discoveries of what you could have done better. And the best of all- if something sounds really great- you have your test-bed to try it.
{: id="20201220214147-6ntditt"}

### Teach
{: id="20201220214147-5n5bh11"}

Teaching others really helps with memorizing and understanding the subject. This is one of the reasons why I am writing this blog. You not only get a chance of sharing your knowledge but also learn yourself by teaching.
{: id="20201220214147-5brf5se"}

If blogging is not your thing, you can talk to your colleagues or friends about what you have been tinkering with. You may be confronted with questions or perspectives that you did not consider before- great! Another chance to make the learning more complete.
{: id="20201220214147-qfmnegv"}

One thing to remember is- don’t be afraid to teach. Even if what you have just learned seems basic to you- it was not so basic before you started learning it! If you were in this position, then so must be countless others!
{: id="20201220214147-sd76r0b"}

There is a value to the unique way you can explain the subject in your own way. Especially given your practical experience gained from the goal that you achieved.
{: id="20201220214147-rrscy1z"}

### Staying up to Date
{: id="20201220214147-ljt6zcb"}

Spring Cloud is constantly changing and growing. If your ultimate goal is becoming an expert in this ecosystem, then you need to think about ways of staying up to date.
{: id="20201220214147-n5afm8b"}

One thing that is pretty much a must is working with it. If you are not lucky enough to use it on your day job- make sure that you use it in your spare time. You could be building a personal project making use of the tech or simply tinker with it and try different things. What matters is that you actually get that hands-on experience.
{: id="20201220214147-xnr7dqh"}

The second part of staying fresh is knowing whats coming and reading other people experiences. Some of the sources I really enjoy following are:
{: id="20201220214147-iwwqcdl"}

- {: id="20201220214147-nlzzkvw"}The [Spring.io](https://spring.io/blog) blog with a very good newsletter
- {: id="20201220214147-ekb3sef"}[Baeldung](http://www.baeldung.com/) – an amazing source of Spring related articles and a weekly newsletter
- {: id="20201220214147-ufcr9ed"}[InfoQ Microservices](https://www.infoq.com/microservices/) – huge and very active website maintained by multiple authors
- {: id="20201220214147-0w8gg8s"}Using Twitter to stay up to date and see what people are reading. I share plenty of articles on that topic with my [@bartoszjd](https://twitter.com/bartoszjd) account.
{: id="20201220214147-pnamdj2"}

These are just some of the sources that I follow. There are countless others. The point is to choose some that you enjoy reading and keep an eye for exciting stuff.
{: id="20201220214147-cowodp6"}

### Conclusion
{: id="20201220214147-9lgdm1f"}

Spring Cloud is a huge and fascinating set of tools for building microservices. It can’t be learned as a “single thing”. Using different goals is the best way of approaching this learning.
{: id="20201220214147-m1t9qvy"}

The idea presented here can be used for learning any technical concept. I found it extremely beneficial for myself and used it with success. I really recommend checking out SimpleProgrammer’s [Learning to learn](https://simpleprogrammer.com/learning-to-learn/) article which describes very similar idea for learning new technologies or frameworks.
{: id="20201220214147-cnp9t4s"}

Happy learning!
{: id="20201220214147-bblab52"}

原文：https://www.e4developer.com/2018/03/06/how-to-learn-spring-cloud-the-practical-way/
{: id="20201220214147-hus1px7"}


{: id="20201220214147-lrhbpud" type="doc"}
