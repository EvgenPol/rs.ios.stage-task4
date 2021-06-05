import Foundation

public extension Int {
    
    var roman: String? {
        guard self >= 1 && self <= 3999 else {
           return nil
        }
        var intToString = self.description
        var roman = ""
        while intToString.count != 0 {
            switch intToString.first {
            case "1":
                switch intToString.count {
                case 1: roman += "I"
                case 2: roman += "X"
                case 3: roman += "C"
                default: roman += "M"
                }
                intToString.removeFirst()
            case "2":
                switch intToString.count {
                case 1: roman += "II"
                case 2: roman += "XX"
                case 3: roman += "CC"
                default: roman += "MM"
                }
                intToString.removeFirst()
            case "3":
                switch intToString.count {
                case 1: roman += "III"
                case 2: roman += "XXX"
                case 3: roman += "CCC"
                default: roman += "MMM"
                }
                intToString.removeFirst()
            case "4":
                switch intToString.count {
                case 1: roman += "IV"
                case 2: roman += "XL"
                default: roman += "CD"
                }
                intToString.removeFirst()
            case "5":
                switch intToString.count {
                case 1: roman += "V"
                case 2: roman += "L"
                default: roman += "D"
                }
                intToString.removeFirst()
            case "6":
                switch intToString.count {
                case 1: roman += "VI"
                case 2: roman += "LX"
                default: roman += "DC"
                }
                intToString.removeFirst()
            case "7":
                switch intToString.count {
                case 1: roman += "VII"
                case 2: roman += "LXX"
                default: roman += "DCC"
                }
                intToString.removeFirst()
            case "8":
                switch intToString.count {
                case 1: roman += "VIII"
                case 2: roman += "LXXX"
                default: roman += "DCCC"
                }
                intToString.removeFirst()
            case "9":
                switch intToString.count {
                case 1: roman += "IX"
                case 2: roman += "XC"
                default: roman += "CM"
                }
                intToString.removeFirst()
            default:
                intToString.removeFirst()
            }
        }
        return roman
    }
}
