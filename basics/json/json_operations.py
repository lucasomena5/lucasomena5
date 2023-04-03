#!/usr/bin/env python3
import os 
import json

def printCustomers(d_data, dataType, dataCol):
    print("\nHere is the list of {}:".format(dataType))
    for item in d_data:
        print(item[dataCol])

# Set up the working directory, fileName, full file path 
workingDir = 'basics/json'
fileName = 'customers.json'
myFile = os.path.join('/home/lucasomena/REPO/lucasomena5', workingDir, fileName)

# Read from a json file and print to console
customerOpen = open(myFile)
customerData = json.load(customerOpen)
print(customerData)
input("\nPress Enter to continue...\n")

printCustomers(customerData, 'customers', 'customer_name')
input("\nPress Enter to exit...\n")