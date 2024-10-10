public class SplitThePizza {

    
    public void calculate(String personName, Integer personAmount){
        
        final Integer oneSlice = 8;
        final Integer slices = 7;
        final Integer lotsOfSlices = 6;
      
        Integer personTotal = personAmount == 1 ? personAmount * oneSlice : (personAmount <=3 ? personAmount * slices : personAmount * lotsOfSlices);
        
        System.debug(personName + ' owes $' + personTotal + ' for ' + personAmount + ' slices' );
    }
}