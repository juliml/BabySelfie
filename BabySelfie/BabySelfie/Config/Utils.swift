//
//  Utils.swift
//  BabySelfie
//
//  Created by Juliana Lacerda on 2019-02-25.
//  Copyright © 2019 Juliana Lacerda. All rights reserved.
//

import Foundation

func getFrequenceDesc(senderValue: Float) -> String {
    switch Int(senderValue) {
    case 0:
        return "DIA"
    case 1:
        return "DIAS"
    case 2:
        return "DIAS"
    case 3:
        return "DIAS"
    case 4:
        return "DIAS"
    case 5:
        return "SEMANA"
    case 6:
        return "SEMANAS"
    case 7:
        return "SEMANAS"
    case 8:
        return "SEMANAS"
    case 9:
        return "SEMANAS"
    case 10:
        return "SEMANAS"
    case 11:
        return "SEMANAS"
    case 12:
        return "SEMANAS"
    default:
        return "FAIL"
    }
}

func getFrequenceValue(senderValue: Float) -> String {
    switch Int(senderValue) {
    case 0:
        return "TODO"
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

func getFrequenceDays(frequence: String) -> Int {
    switch frequence {
    case "TODODIA":
        return 1;
    case "2DIAS":
        return 2
    case "3DIAS":
        return 3
    case "4DIAS":
        return 4
    case "5DIAS":
        return 5
    case "1SEMANA":
        return 1*7
    case "2SEMANAS":
        return 2*7
    case "3SEMANAS":
        return 3*7
    case "4SEMANAS":
        return 4*7
    case "5SEMANAS":
        return 5*7
    case "6SEMANAS":
        return 6*7
    case "7SEMANAS":
        return 7*7
    case "8SEMANAS":
        return 8*7
    default:
        return 0
    }
}
