//
//  Converter.swift
//  LA
//
//  Created by Okita Subaru on 8/21/19.
//  Copyright © 2019 Nguyen Thi Lan Anh. All rights reserved.
//

import Foundation

struct Converter {
    
    // MARK: - Variables
    
    public static let asciiChars = "\0\u{01}\u{02}\u{03}\u{04}\u{05}\u{06}\u{07}\u{08}\t\n\u{0B}\u{0C}\r\u{0E}\u{0F}\u{10}\u{11}\u{12}\u{13}\u{14}\u{15}\u{16}\u{17}\u{18}\u{19}\u{1A}\u{1B}\u{1C}\u{1D}\u{1E}\u{1F} !\"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~\u{7F}"
    
    // MARK: - Functions
    
    public static func encode(number: Int) -> String {
        let base = asciiChars.count
        var _number = number, result = ""
        repeat {
            let index = asciiChars.index(asciiChars.startIndex, offsetBy: (_number % base))
            result = [asciiChars[index]] + result
            _number /= base
        } while (_number > 0)
        return result
    }
    
    public static func decode(encoded: String) -> Int? {
        let base = asciiChars.count
        var result = 0
        for char in encoded {
            guard let index = asciiChars.firstIndex(of: char) else { return nil }
            let mult = result.multipliedReportingOverflow(by: base)
            
            guard !mult.overflow else { return nil }
            let add = mult.partialValue.addingReportingOverflow(asciiChars.distance(from: asciiChars.startIndex, to: index))
            
            if (add.overflow) {
                return nil
            } else {
                result = add.partialValue
            }
        }
        
        return result
    }
    
    public static func showASCIITable() {
        // Header.
        print("#     ASCII")
        
        // Use values between 0 and 127.
        let min = 0
        let max = 128
        
        // Loop over all possible indexes.
        for i in min..<max {
            
            // Get UnicodeScalar.
            let u = UnicodeScalar(i)!
            
            // Build left part of display line.
            let displayIndex = String(i).padding(toLength: 5, withPad: " ", startingAt: 0)
            
            // Escape the UnicodeScalar for display.
            let display = u.escaped(asASCII: true)
            
            // Print this line.
            let result = "\(displayIndex) \(display)"
            print(result)
        }
    }
}
