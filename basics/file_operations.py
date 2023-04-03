#!/usr/bin/env python3
import os
import datetime 

def printMsg(msg):
    print("\nContent from message file: ")
    for item in msg:
        print(item)

# Set up the working directory, fileName, full file path 
workingDir = 'basics'
fileName = 'message.txt'
myPath = os.path.join('/home/lucasomena/REPO/lucasomena5', workingDir)
myFile = os.path.join('/home/lucasomena/REPO/lucasomena5', workingDir, fileName)
myFiles = os.listdir(myPath)
print("\n\n")

for localFileName in myFiles:
    print(localFileName)

# Open file object in readonly mode and print it using readlines()
messageFile = open(myFile, 'r')
print("\n\nContents from message file: {}".format(messageFile.readlines()))
input("\nPress ENTER to continue...")
messageFile.close()

# Open file object for appending ('w' will overwrite the existing file)
messageFile = open(myFile, 'a')
messageFile.write("\nFile backed up: " + str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M")))
messageFile.close()
messageFile = open(myFile, 'r')
messages = messageFile.readlines()
messageFile.close()
printMsg(messages)