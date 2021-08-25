//
//  String+Extensions.swift
//  DostupnoUA
//
//  Created by Anton on 31.10.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Foundation

extension String {
    
    var isEmptyOrWhitespace: Bool {
        let string = trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        return string.isEmpty
    }
    
    func isValidEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return self.matches(regex)
    }
    
    func isValidPhone() -> Bool {
        let regex = "^((\\+)|(00))[0-9]{12}$"
        return self.matches(regex)
    }
    
//    func isValidPhone() -> Bool {
//        do {
//            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
//            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
//            if let res = matches.first {
//                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
//            } else { return false }
//        } catch {
//            return false
//        }
//
//    }
    
    func isValidPassword() -> (lenght: Bool, oneUppercase: Bool, oneDigit: Bool) {
        let minLenght: Int = 8
        
        let lenght = self.count >= minLenght
        var atLeastOneUppercase = false
        var atLeastOneDigit = false
        let atLeastOneUppercaseRegex = "[A-Z, А-Я]+"//"[A-Z]" 
        let atLeastOneDigitRegex = "[0-9]"
        
        //        let oneUppercasePredicate = NSPredicate(format: "SELF MATCHES %@", atLeastOneUppercaseRegex)
        //        atLeastOneUppercase = oneUppercasePredicate.evaluate(with: password)
        
        atLeastOneUppercase = self.matches(atLeastOneUppercaseRegex)
        atLeastOneDigit = self.matches(atLeastOneDigitRegex)
        return (lenght, atLeastOneUppercase, atLeastOneDigit)
    }
    
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    func toDouble() -> Double? {
        return Double(self)
    }
}

extension String {
    var htmlDecoded: String {
        let decoded = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil).string
        
        return decoded ?? self
    }
}
