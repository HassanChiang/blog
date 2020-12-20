----
title: 【译】Spring Boot 从 classpath 加载文件
date: 2019-12-28
description: 

tags:
- 文件加载
- Spring
- Java
- Spring Boot

nav:
- Spring

categories:
- Spring Boot

image: images/java/spring-framework.png

----
## 介绍

在创建Spring Boot web应用程序时，有时需要从 `classpath` 加载文件，例如，数据仅作为文件可用的时候。在我的例子中，我使用 `MAXMIND GeoLite2` 数据库进行地理位置检索。因此，我需要加载文件并创建一个 `DatabaseReader` 对象，该对象存储在服务器内存中。
下面您将找到在WAR和JAR中加载文件的解决方案。


## The ResourceLoader

Java本身提供了线程 classLoader 可以用来尝试加载文件，但 Spring 框架提供了更加优雅的方式，比如 ： [ResourceLoader](http://docs.spring.io/spring/docs/current/spring-framework-reference/html/resources.html)。

你只需要在需要的地方注入 ResourceLoader ，然后调用 getResource("some path")  方法即可。


## 从 resource 目录或 classpath 中加载文件 的例子 (WAR)

    @Service("geolocationservice")
    public class GeoLocationServiceImpl implements GeoLocationService {

        private static final Logger LOGGER = LoggerFactory.getLogger(GeoLocationServiceImpl.class);

        private static DatabaseReader reader = null;

        private ResourceLoader resourceLoader;

        @Autowired
        public GeoLocationServiceImpl(ResourceLoader resourceLoader) {
            this.resourceLoader = resourceLoader;
        }

        @PostConstruct
        public void init() {
            try {
                LOGGER.info("GeoLocationServiceImpl: Trying to load GeoLite2-Country database...");

                Resource resource = resourceLoader.getResource("classpath:GeoLite2-Country.mmdb");
                File dbAsFile = resource.getFile();

                // Initialize the reader
                reader = new DatabaseReader
                            .Builder(dbAsFile)
                            .fileMode(Reader.FileMode.MEMORY)
                            .build();

                LOGGER.info("GeoLocationServiceImpl: Database was loaded successfully.");

            } catch (IOException | NullPointerException e) {
                LOGGER.error("Database reader cound not be initialized. ", e);
            }
        }

        @PreDestroy
        public void preDestroy() {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e) {
                    LOGGER.error("Failed to close the reader.");
                }
            }
        }
    }

## 从 Spring Boot JAR 中加载文件的例子

    @Service("geolocationservice")
    public class GeoLocationServiceImpl implements GeoLocationService {

        private static final Logger LOGGER = LoggerFactory.getLogger(GeoLocationServiceImpl.class);

        private static DatabaseReader reader = null;
        private ResourceLoader resourceLoader;

        @Inject
        public GeoLocationServiceImpl(ResourceLoader resourceLoader) {
            this.resourceLoader = resourceLoader;
        }

        @PostConstruct
        public void init() {
            try {
                LOGGER.info("GeoLocationServiceImpl: Trying to load GeoLite2-Country database...");

                Resource resource = resourceLoader.getResource("classpath:GeoLite2-Country.mmdb");
                InputStream dbAsStream = resource.getInputStream(); // <-- this is the difference

                // Initialize the reader
                reader = new DatabaseReader
                            .Builder(dbAsStream)
                            .fileMode(Reader.FileMode.MEMORY)
                            .build();

                LOGGER.info("GeoLocationServiceImpl: Database was loaded successfully.");

            } catch (IOException | NullPointerException e) {
                LOGGER.error("Database reader cound not be initialized. ", e);
            }
        }

        @PreDestroy
        public void preDestroy() {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e) {
                    LOGGER.error("Failed to close the reader.");
                }
            }
        }
    }

英文原文：https://smarterco.de/java-load-file-from-classpath-in-spring-boot/?from=timeline