//
//  Utils.swift
//  BabySelfie
//
//  Created by Juliana Lacerda on 2019-02-25.
//  Copyright © 2019 Juliana Lacerda. All rights reserved.
//

import Foundation

func getFrequenceDesc(_ senderValue: Float) -> String {
    switch Int(senderValue) {
    case 0:
        return NSLocalizedString("freq_day", comment: "")
    case 1:
        return NSLocalizedString("freq_days", comment: "")
    case 2:
        return NSLocalizedString("freq_days", comment: "")
    case 3:
        return NSLocalizedString("freq_days", comment: "")
    case 4:
        return NSLocalizedString("freq_days", comment: "")
    case 5:
        return NSLocalizedString("freq_week", comment: "")
    case 6:
        return NSLocalizedString("freq_weeks", comment: "")
    case 7:
        return NSLocalizedString("freq_weeks", comment: "")
    case 8:
        return NSLocalizedString("freq_weeks", comment: "")
    case 9:
        return NSLocalizedString("freq_weeks", comment: "")
    case 10:
        return NSLocalizedString("freq_weeks", comment: "")
    case 11:
        return NSLocalizedString("freq_weeks", comment: "")
    case 12:
        return NSLocalizedString("freq_weeks", comment: "")
    default:
        return "FAIL"
    }
}

func getFrequenceValue(_ senderValue: Float) -> String {
    switch Int(senderValue) {
    case 0:
        return "0"
    case 1:
        return "2"
    case 2:
        return "3"
    case 3:
        return "4"
    case 4:
        return "5"
    case 5:
        return "1"
    case 6:
        return "2"
    case 7:
        return "3"
    case 8:
        return "4"
    case 9:
        return "5"
    case 10:
        return "6"
    case 11:
        return "7"
    case 12:
        return "8"
    default:
        return "FAIL"
    }
}

func getFrequenceDays(_ frequence: Float) -> Int {
    
    switch Int(frequence) {
    case 0:
        return 1;
    case 1:
        return 2
    case 2:
        return 3
    case 3:
        return 4
    case 4:
        return 5
    case 5:
        return 1*7
    case 6:
        return 2*7
    case 7:
        return 3*7
    case 8:
        return 4*7
    case 9:
        return 5*7
    case 10:
        return 6*7
    case 11:
        return 7*7
    case 12:
        return 8*7
    default:
        return 0
    }
}

func isValidEmail(_ testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}
