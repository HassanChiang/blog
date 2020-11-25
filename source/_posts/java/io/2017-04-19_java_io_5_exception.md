----
title: Java IO(5) 异常处理
date: 2017-04-19
description: 

tags:
- Exception
- IO
- Java

nav:
- Java

categories:
- Java IO

image: images/java/basic/java_logo.png

----
传统的写法：

    InputStream input = null;
    try {
        input = new FileInputStream("c:\\data\\input-text.txt");

        int data = input.read();
        while (data != -1) {
            //do something with data...
            doSomethingWithData(data);

            data = input.read();
        }
    } catch (IOException e) {
        //do something with e... log, perhaps rethrow etc.
    } finally {
        try {
            if (input != null) input.close();
        } catch (IOException e) {
            //do something, or ignore.
        }
    }

使用模板方法：

    public abstract class InputStreamProcessingTemplate {

        public void process(String fileName) {
            IOException processException = null;
            InputStream input = null;
            try {
                input = new FileInputStream(fileName);

                doProcess(input);
            } catch (IOException e) {
                processException = e;
            } finally {
                if (input != null) {
                    try {
                        input.close();
                    } catch (IOException e) {
                        if (processException != null) {
                            throw new MyException(processException, e,
                                    "Error message..." +
                                            fileName);
                        } else {
                            throw new MyException(e,
                                    "Error closing InputStream for file " +
                                            fileName;
                        }
                    }
                }
                if (processException != null) {
                    throw new MyException(processException,
                            "Error processing InputStream for file " +
                                    fileName;
                }
            }

            //override this method in a subclass, to process the stream.

        public abstract void doProcess(InputStream input) throws IOException;
    }
    
    //调用
    new InputStreamProcessingTemplate(){
        public void doProcess(InputStream input) throws IOException{
            int inChar = input.read();
            while(inChar !- -1){
                //do something with the chars...
            }
        }
    }.process("someFile.txt");

使用接口实现：

    public interface InputStreamProcessor {
        public void process(InputStream input) throws IOException;
    }


    public class InputStreamProcessingTemplate {

        public void process(String fileName, InputStreamProcessor processor){
            IOException processException = null;
            InputStream input = null;
            try{
                input = new FileInputStream(fileName);

                processor.process(input);
            } catch (IOException e) {
                processException = e;
            } finally {
               if(input != null){
                  try {
                     input.close();
                  } catch(IOException e){
                     if(processException != null){
                        throw new MyException(processException, e,
                          "Error message..." +
                          fileName;
                     } else {
                        throw new MyException(e,
                            "Error closing InputStream for file " +
                            fileName);
                     }
                  }
               }
               if(processException != null){
                  throw new MyException(processException,
                    "Error processing InputStream for file " +
                        fileName;
            }
        }
    }

    new InputStreamProcessingTemplate()
        .process("someFile.txt", new InputStreamProcessor(){
            public void process(InputStream input) throws IOException{
                int inChar = input.read();
                while(inChar !- -1){
                    //do something with the chars...
                }
            }
        });

改成静态方法：

    public class InputStreamProcessingTemplate {

        public static void process(String fileName,
        InputStreamProcessor processor){
            IOException processException = null;
            InputStream input = null;
            try{
                input = new FileInputStream(fileName);

                processor.process(input);
            } catch (IOException e) {
                processException = e;
            } finally {
               if(input != null){
                  try {
                     input.close();
                  } catch(IOException e){
                     if(processException != null){
                        throw new MyException(processException, e,
                          "Error message..." +
                          fileName);
                     } else {
                        throw new MyException(e,
                            "Error closing InputStream for file " +
                            fileName;
                     }
                  }
               }
               if(processException != null){
                  throw new MyException(processException,
                    "Error processing InputStream for file " +
                        fileName;
            }
        }
    }

    InputStreamProcessingTemplate.process("someFile.txt",
        new InputStreamProcessor(){
            public void process(InputStream input) throws IOException{
                int inChar = input.read();
                while(inChar !- -1){
                    //do something with the chars...
                }
            }
        });