def cbc_encrypt(text,alg,key,block_len,iv):
    cipher = 0;

    block = text&(2**block_len-1)
    block ^= iv
    newcb = alg(block,key)
    cipher |= newcb

    while (text >>= block_len):
        block = text&(2**block_len-1)
        block ^= newcb;
        newcb = alg(block,key)
        cipher= (cipher<<block_len)|=newcb
    return cipher

def cbc_decrypt(text,alg,key,block_len,iv):
    plain = 0;

    

