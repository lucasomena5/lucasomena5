# List - use []
a = [1, 2, 3]
print(a)
print(a[1])

a[2] = 4
print(a)

a.append('string')
print(a)

listSize = len(a)
print(listSize)

# Tuples - use ()
t = ('string', 1, 2, 3.14)
print(t)
t += ('another string', 4)
print(t)

# Dictionaries - key|value 
d = {'k1': 'val1', 'k2': 'val2'}
print(d['k1'])

d['k3'] = 'val3'
print(d)
print(d['k3'])