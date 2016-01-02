//
//  MathFunctions.swift
//  
//
//  Created by Don Willems on 23/12/15.
//
//

import Foundation


// MARK: Operators for Numbers

/**
This operator returns `true` when the Decimal values are equal to each other.

- parameter left: The left Decimal in the comparison.
- parameter right: The right Decimal in the comparison.
- returns: True when the Decimals are equal, false otherwise.
*/
public func == (left: Decimal, right: Decimal) -> Bool {
    if left.decimalInteger == right.decimalInteger && left.decimalExponent == right.decimalExponent {
        return true
    }
    let dleft = Double(left.decimalInteger)*pow(10,-Double(left.decimalExponent))
    let dright = Double(right.decimalInteger)*pow(10,-Double(right.decimalExponent))
    if dleft != dright {
        return false
    }
    if left.decimalExponent > right.decimalExponent {
        var integ = right.decimalInteger
        for _ in right.decimalExponent...left.decimalExponent-1 {
            if Int64.max/10 < integ {
                return false
            }
            integ = integ * 10
        }
        if left.decimalInteger == integ {
            return true
        }
        return false
    }
    if left.decimalExponent < right.decimalExponent {
        var integ = left.decimalInteger
        for _ in left.decimalExponent...right.decimalExponent-1 {
            if Int64.max/10 < integ {
                return false
            }
            integ = integ * 10
        }
        if right.decimalInteger == integ {
            return true
        }
        return false
    }
    return false
}

/**
 This operator returns `true` when the Decimal values are not equal to each other.
 
 - parameter left: The left Decimal in the comparison.
 - parameter right: The right Decimal in the comparison.
 - returns: True when the Decimals are not equal, false otherwise.
 */
public func != (left: Decimal, right: Decimal) -> Bool {
    return !(left == right)
}

/**
 This operator returns `true` when the left Decimal value in the comparisson is greater
 than the right value.
 
 - parameter left: The left Decimal in the comparison.
 - parameter right: The right Decimal in the comparison.
 - returns: True when the left Decimal value if greater than the right value, false otherwise.
 */
public func > (left: Decimal, right: Decimal) -> Bool {
    if left.decimalInteger > right.decimalInteger && left.decimalExponent == right.decimalExponent {
        return true
    }
    if left.decimalInteger < right.decimalInteger && left.decimalExponent == right.decimalExponent {
        return false
    }
    let dleft = Double(left.decimalInteger)*pow(10,-Double(left.decimalExponent))
    let dright = Double(right.decimalInteger)*pow(10,-Double(right.decimalExponent))
    if dleft > dright {
        return true
    }
    if dleft < dright {
        return false
    }
    if left.decimalExponent > right.decimalExponent {
        var integ = right.decimalInteger
        for _ in right.decimalExponent...left.decimalExponent-1 {
            if Int64.max/10 < integ {
                return false
            }
            integ = integ * 10
        }
        if left.decimalInteger > integ {
            return true
        }
        return false
    }
    if left.decimalExponent < right.decimalExponent {
        var integ = left.decimalInteger
        for _ in left.decimalExponent...right.decimalExponent-1 {
            if Int64.max/10 < integ {
                return true
            }
            integ = integ * 10
        }
        if right.decimalInteger < integ {
            return true
        }
        return false
    }
    return false
}

/**
 This operator returns `true` when the left Decimal value in the comparisson is greater than
 or equal to the right value.
 
 - parameter left: The left Decimal in the comparison.
 - parameter right: The right Decimal in the comparison.
 - returns: True when the left Decimal value if greater than or equal to the right value, false otherwise.
 */
public func >= (left: Decimal, right: Decimal) -> Bool {
    return left > right || left == right
}


/**
 This operator returns `true` when the left Decimal value in the comparisson is smaller
 than the right value.
 
 - parameter left: The left Decimal in the comparison.
 - parameter right: The right Decimal in the comparison.
 - returns: True when the left Decimal value if smaller than the right value, false otherwise.
 */
public func < (left: Decimal, right: Decimal) -> Bool {
    if left.decimalInteger < right.decimalInteger && left.decimalExponent == right.decimalExponent {
        return true
    }
    if left.decimalInteger > right.decimalInteger && left.decimalExponent == right.decimalExponent {
        return false
    }
    let dleft = Double(left.decimalInteger)*pow(10,-Double(left.decimalExponent))
    let dright = Double(right.decimalInteger)*pow(10,-Double(right.decimalExponent))
    if dleft < dright {
        return true
    }
    if dleft > dright {
        return false
    }
    if left.decimalExponent > right.decimalExponent {
        var integ = right.decimalInteger
        for _ in right.decimalExponent...left.decimalExponent-1 {
            if Int64.max/10 < integ {
                return true
            }
            integ = integ * 10
        }
        if left.decimalInteger < integ {
            return true
        }
        return false
    }
    if left.decimalExponent < right.decimalExponent {
        var integ = left.decimalInteger
        for _ in left.decimalExponent...right.decimalExponent-1 {
            if Int64.max/10 < integ {
                return false
            }
            integ = integ * 10
        }
        if right.decimalInteger > integ {
            return true
        }
        return false
    }
    return false
}

/**
 This operator returns `true` when the left Decimal value in the comparisson is smaller than
 or equal to the right value.
 
 - parameter left: The left Decimal in the comparison.
 - parameter right: The right Decimal in the comparison.
 - returns: True when the left Decimal value if smaller than or equal to the right value, false otherwise.
 */
public func <= (left: Decimal, right: Decimal) -> Bool {
    return left < right || left == right
}



// MARK: Mathematical functions for Decimal

/**
 The logarithm with base 10 of the decimal parameter.
 
 - parameter _decimal: The decimal whose base 10 logarithm should be determined.
 - returns: The base 10 logarithm value.
 */
public func log10(_decimal : Decimal) -> Double {
    return log10(Double(_decimal.decimalInteger)*pow(10,-Double(_decimal.decimalExponent)))
}

/**
 The natural logarithm of the decimal parameter.
 
 - parameter _decimal: The decimal whose natural logarithm should be determined.
 - returns: The natural logarithm value.
 */
public func log(_decimal : Decimal) -> Double {
    return log(Double(_decimal.decimalInteger)*pow(10,-Double(_decimal.decimalExponent)))
}

/**
 The natural exponent of the decimal parameter.
 
 - parameter _decimal: The decimal whose exponent should be determined.
 - returns: The exponent value.
 */
public func exp(_decimal : Decimal) -> Double {
    return exp(Double(_decimal.decimalInteger)*pow(10,-Double(_decimal.decimalExponent)))
}