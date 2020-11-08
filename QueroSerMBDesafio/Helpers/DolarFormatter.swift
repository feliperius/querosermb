//
//  DolarFormatter.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 07/11/20.
//
import Foundation

extension String {
    func dolar() -> String {
        let amount1 = Double(self)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "en_US")
        return numberFormatter.string(from: NSNumber(value: amount1!))!
    }
}
