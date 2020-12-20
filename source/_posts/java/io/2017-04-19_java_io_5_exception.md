---

title: Java IO(5) 异常处理
date: 2017-04-19
description:
{: id="20201220214147-huo0hey"}

tags:
{: id="20201220214147-uooz1tq"}

- {: id="20201220214147-z2d0chj"}Exception
- {: id="20201220214147-z0mj7s6"}IO
- {: id="20201220214147-ncfhr6k"}Java
{: id="20201220214147-0jvz2iw"}

nav:
{: id="20201220214147-kfbhjro"}

- {: id="20201220214147-4rfaki8"}Java
{: id="20201220214147-1q70ork"}

categories:
{: id="20201220214147-gy8u3nh"}

- {: id="20201220214147-c14vuj5"}Java IO
{: id="20201220214147-al05os9"}

image: images/java/io.png
{: id="20201220214147-9ozcdty"}

---

传统的写法：
{: id="20201220214147-kgm70pl"}

```
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
```
{: id="20201220214147-bbzhv9r"}

使用模板方法：
{: id="20201220214147-919azeu"}

```
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
```
{: id="20201220214147-0dseu13"}

使用接口实现：
{: id="20201220214147-c0cv6vx"}

```
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
```
{: id="20201220214147-w82tov8"}

改成静态方法：
{: id="20201220214147-h1z95no"}

```
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
```
{: id="20201220214147-ynao5bg"}


{: id="20201220214147-rvzbt8l" type="doc"}
