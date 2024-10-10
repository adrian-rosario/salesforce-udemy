public class Fitness {

    
    public Decimal calculateBmi(Decimal bodyWeightInKg, Decimal bodyHeightInMeter){

        if(bodyWeightInKg <= 0 || bodyHeightInMeter <= 0){
            
            System.debug('positive numbers only, please');
            
            return 0;
        }
        
        return bodyWeightInKg / (bodyHeightInMeter*bodyHeightInMeter);       
    }
    
    public Decimal calculatePace(Decimal distanceInKm, Decimal timeInMinutes){
        
        if(distanceInKm <= 0 || timeInMinutes <= 0){
            System.debug('positive numbers only, please');            
            return 0;
        }
    
        Decimal hr = timeInMinutes/60;

        return distanceInKm / hr;
    }    
    
    public String testReturn(){
        return 'hello from method';
    }
    
    public Fitness(){
        System.debug('constructor called');
    }

 // adding comment from vscode   
}