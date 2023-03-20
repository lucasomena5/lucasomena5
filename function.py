#!/usr/bin/python3

# def nameOfFunction(param):
#   your code
#   return

def addition(num1, num2, num3):
    return num1 + num2 + num3 

def division(num1, num2):
    if num2 == 0:
        return "[ERROR] Cannot divide by ZERO!"
    else:
        return num1/num2
    
var1 = 10
var2 = 13
var3 = 352

result = addition(var1, var2, var3)
print("Result of addition is: ", result)

result = division(var1, var2)
print("Result of division is: ", result)