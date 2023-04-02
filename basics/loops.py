# for loop
def expFor(x,y):
    val = 1 
    for i in range(y):
        print("i is: {}".format(i))
        val *= x
    return val 

print(expFor(2,0))
print(expFor(2,3))

# while loop 
def expWhile(x,y):
    val = 1 
    while y:
        print ("y is: {}".format(y))
        val *= x
        y -= 1
    return val 

print(expWhile(2,0))
print(expWhile(2,3))