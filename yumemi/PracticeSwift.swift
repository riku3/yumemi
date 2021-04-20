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
        
        var queue = [() -> Void]()
        func enqueue(operation: @escaping () -> Void) {
            queue.append(operation)
        }
        enqueue { print("abc") }
        enqueue { print("def") }
        queue.forEach { $0() }
        
        func or1(_ lhs: Bool, _ rhs: Bool) -> Bool {
            if lhs {
                print("true")
                return true
            } else {
                print(rhs)
                return rhs
            }
        }
        _ = or1(true, false) // true
        
        func or(_ lhs: Bool, _ rhs: @autoclosure () -> Bool) -> Bool {
            if lhs {
                print("true")
                return true
            } else {
                let rhs = rhs()
                print(rhs)
                return rhs
            }
        }
        func lhs() -> Bool {
            return true
        }
        
        func rhs() -> Bool {
            return false
        }
        
        _ = or(lhs(), rhs())
        
    }
    
    func double(_ x: Int) -> Int {
        return x * 2
    }
    
    let triple = { (x: Int) -> Int in
        return x * 3
    }
    
}

