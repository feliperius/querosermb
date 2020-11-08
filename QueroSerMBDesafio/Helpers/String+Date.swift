//
//  String+Date.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 07/11/20.
//

import Foundation

extension String {
    func date() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZZZZZ"
        
        guard let date = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
       return dateFormatter.string(from: date)
    }
}
