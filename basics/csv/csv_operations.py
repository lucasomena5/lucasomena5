#!/usr/bin/env python3
import os 
import csv 

def printList(listData, listType):
    print("\nHere is the listing of {}".format(listType))
    for item in listData:
        print(item)

# Set up the working directory, fileName, full file path 
workingDir = 'basics/csv'
fileName = 'customers.csv'
newFileName = 'newcustomers.csv'
myFile = os.path.join('/home/lucasomena/REPO/lucasomena5', workingDir, fileName)
myNewFile = os.path.join('/home/lucasomena/REPO/lucasomena5', workingDir, newFileName)

# Read from a csv file
customerFile = open(myFile)
customerReader = csv.reader(customerFile)
customerData = list(customerReader)
print("\nPassing the reader to list() creates a list of lists:")
print(customerData)
input("\nPress Enter to continue...\n")
printList(customerData, 'customers')
input("\nPress Enter to continue...\n")
print(customerData[1][1] + ' email: ' + customerData[1][2])
input("\nPress Enter to continue...\n")
customerFile.close()

# Write to a csv file 
customerFile = open(myNewFile, 'w', newline='')
customerWriter = csv.writer(customerFile)
customerWriter.writerow(['customer_id','customer_name','customer_email','prov_state','country'])
customerWriter.writerow(['1','Lucas','lucasomena5@gmail.com','BC','CA'])
print("\nSuccessfully created new customer data file...")
input("\nPress Enter to exit...\n")