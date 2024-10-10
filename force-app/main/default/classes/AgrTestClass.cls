public class AgrTestClass {

    String greeting = '==== Hello from our custom test class!!';
    
    public void sayHello() {
        Datetime myNow = System.now();
        String datetimeESTStr = myNow.format('yyyy-MM-dd\'T\'HH:mm:ssZ', 'EST');
        System.debug(greeting + '\n' + datetimeESTStr);
    }
}