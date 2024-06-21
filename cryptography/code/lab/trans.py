import numpy as np

table =['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'] 


def gen_table():
    rng = np.random.default_rng()
    permute_table = rng.permutation(table)
    key_table   = {}
    value_table = {}
    for i in range(len(table)):
        key_table[table[i]] = permute_table[i]
        value_table[permute_table[i]] = table[i]

    return key_table,value_table

def encrypt(text,key_table):
    ret = ''
    for c in text:
        ret += key_table[c]
    return ret

def decrypt(cipher,value_table):
    ret = ''
    for c in cipher:
        ret += value_table[c]
    return ret

plaintext = 'Linzhouyi26221017'
key_table,value_table = gen_table()
print('encrypting...')
c = encrypt(plaintext,key_table)
print(c)
print('decrypting...')
print(decrypt(c,value_table))

