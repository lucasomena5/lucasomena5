#!/usr/bin/env python3

def addUsers(users, user):
    users.append(user)
    print("Added user: {}".format(user))
    return users

def printUsers(users):
    for item in users:
        print(item)

# Define a list of users
users = ['lucas', 'bruna']
print("\n\n")

# Add a user, passing users (list) and user (string)
print("*** Add a user")
addUsers(users, 'beatriz')
print("\n")

# Print users, passing users (list)
print("*** Print all users")
printUsers(users)
print("\n\n")

input('Press ENTER to exit...')