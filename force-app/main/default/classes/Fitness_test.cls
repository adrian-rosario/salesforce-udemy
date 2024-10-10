@isTest
public class Fitness_test {

    @isTest
    public static void calculateTest1(){
    Fitness testInstance = new Fitness();
    Decimal result = testInstance.calculateBmi(65, 1.25);
    System.assertEquals(41.6, result, 'basic test didn\'t pass');        
    }

    @isTest
    public static void calculateTest2(){
    Fitness testInstance2 = new Fitness();
    Decimal result2 = testInstance2.calculateBmi(-65, -1.25);
    System.assertEquals(0, result2, 'negative test didn\'t pass');        
    }    

    @isTest
    public static void calculateTest3(){
    Fitness testInstance3 = new Fitness();
    Decimal result3 = testInstance3.calculatePace(12.5,80);
    System.assertEquals(9.37500000000000000000000000000002, result3, 'pace test didn\'t pass');        
    }

    @isTest
    public static void calculateTest4(){
    Fitness testInstance4 = new Fitness();
    String result4 = testInstance4.testReturn();
    System.assertEquals('hello from method', result4, 'Return test didn\'t pass');        
    }
    
    @isTest
    public static void calculateTest5(){
    Fitness testInstance5 = new Fitness();
    Decimal result5 = testInstance5.calculatePace(-12.5,-80);
    System.assertEquals(0, result5, 'negative number test didn\'t pass');        
    }
}