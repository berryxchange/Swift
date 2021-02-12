import UIKit

extension String {
   var containsSpecialCharacter: Bool {
      let regex = ".*[^A-Za-z0-9].*"
      let testString = NSPredicate(format:"SELF MATCHES %@", regex)
      return testString.evaluate(with: self)
   }
}


print("3r42323".containsSpecialCharacter)
print("!--%332".containsSpecialCharacter)
