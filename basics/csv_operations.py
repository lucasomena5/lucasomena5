#!/usr/bin/env python3
import os 
import csv 

def printList(listData, listType):
    print("\nHere is the listing of {}".format(listType))
    for item in listData:
        print(item)

# Set up the working directory, fileName, full file path 
workingDir = 'basics'
fileName = 'customers.csv'
myPath = os.path.join('/home/lucasomena/REPO/lucasomena5', workingDir)
myFile = os.path.join('/home/lucasomena/REPO/lucasomena5', workingDir, fileName)

