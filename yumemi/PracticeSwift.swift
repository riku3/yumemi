//
//  PracticeSwift.swift
//  yumemi
//
//  Created by riku on 2021/04/20.
//

import Foundation

class Closure {
    
    func main() -> Void{
        _ = double(2)
        _ = triple(3)
        
        var closure: (String) -> Int
        closure = { (stiring: String) -> Int in
            return stiring.count
        }
        _ = closure("abc")
        
        closure = { string in
            return string.count
        }
        _ = closure("def")
        
        let lengthOfString = { (string: String) -> Int in
            return string.count
        }
        _ = lengthOfString("ghi")
        
        let add = { (x: Int, y: Int) -> Int in
            return x + y
        }
        _ = add(1,2)
        
        let isEqual : (Int, Int) -> Bool = {
            return $0 == $1
        }
        _ = isEqual(1,1)
        
        let numbers = [1,2,3,4]
        let moreThanTwenty = numbers.filter { $0 > 2}
        _ = moreThanTwenty
        
        let greeting: (String) -> String
        do {
            let symbol = "!"
            greeting = { user in
                return "Hello, \(user) and \(symbol)"
            }
        }
        _ = greeting("taro")
        
        let counter: () -> Int
        do {
            var count = 0
            counter = {
                count += 1
                return count
            }
        }
        _ = counter() // 1
        _ = counter() // 2
    }
    
    func double(_ x: Int) -> Int {
        return x * 2
    }
    
    let triple = { (x: Int) -> Int in
        return x * 3
    }
    
}

