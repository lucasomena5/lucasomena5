#!/usr/bin/env python3
import os 
import xml.etree.ElementTree as et

# Set up the working directory, fileName, full file path 
workingDir = 'basics/xml'
fileName = 'customers.xml'
myFile = os.path.join('/home/lucasomena/REPO/lucasomena5', workingDir, fileName)

# Read from a xml file and print to console
tree = et.parse(myFile)
root = tree.getroot()
print("\nThe root tag is:")
print(root.tag)
input("\nPress Enter to continue...\n")

print("\nList the tag and attrib for children nodes:")
for child in root:
    print(child.tag, child.attrib)
input("\nPress Enter to continue...\n")

print("\n\nList each customer, along with their country:")
for customer in root.findall('customer'):
    country = customer.find('country').text 
    name = customer.get('name')
    print(name + ': ', country)
input("\nPress Enter to exit...\n")