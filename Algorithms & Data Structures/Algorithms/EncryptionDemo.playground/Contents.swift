import UIKit

var alphabet: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "h", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]


func encrypt(input: String, intensity: Int) -> String{
    
    var encryptedArray = [Any]()
    
    for (encryptIndex, value) in input.enumerated(){
        
        let characterValue = value
        var foundCharacter: Character = "a"
        
        
        for (charIndex, alpha) in alphabet.enumerated(){
            
            func getIntensity() -> Int{
                var newEncryptValue = 0
                var encryptValue = charIndex + intensity
                
                if encryptValue > alphabet.count{
                    encryptValue = (encryptValue - 26) + intensity
                }
                return newEncryptValue
            }
            
        
            
            if characterValue == alpha{
                print(charIndex)
                //encrypt input
                let intensityValue = getIntensity()
                
                encryptedArray.append(alphabet[intensityValue])
                
            }else{
                encryptedArray.append(alphabet[encryptIndex])
            }
 
            
        }
        print(encryptedArray)
    }
    return "\(encryptedArray)"
    
}

encrypt(input: "ya mama", intensity: 2)
