def mul( poly1, poly2):
# 两个多项式相乘
    result = 0
    for index in range(poly2.bit_length()):
        if poly2 & 1 << index:
            result ^= poly1 << index
        return result

print(mul(0b111,0b1111))
