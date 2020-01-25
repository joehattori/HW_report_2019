i = int(input())
h = i
c = 0
while i != 1:
    c += 1
    if i % 2:
        i = i * 3 + 1
    else:
        i /= 2
    h = max(h, i)
print("len: {}, height: {}".format(c, h))
