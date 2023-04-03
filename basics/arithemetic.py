#!/usr/bin/python3  

def add(n1, n2):
    return n1+n2

def subtract(n1, n2):
    return n1-n2

def multiply(n1, n2):
    return n1*n2

def divide(n1, n2):
    if n2 == 0:
        return "ERROR: Cannot divide by 0. Second parameter cannot be a 0!"
    else:
        return n1/n2
    
num1 = 10 
num2 = 11

print(add(num1,num2))
print(subtract(num1,num2))
print(multiply(num1,num2))
print(divide(num1,num2))

num2 = 0
print(divide(num1,num2))
