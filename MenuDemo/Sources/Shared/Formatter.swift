import Foundation

struct Formatter {
    
    static let priceFormatter: NumberFormatter = {
       
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        
        return numberFormatter
        
    }()
    
}
