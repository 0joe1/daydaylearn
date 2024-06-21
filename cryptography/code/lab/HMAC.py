from gmssl import sm3
from utils import *

def make_pad(content,times):
    ret = 0
    for _ in range(times):
        ret |= content
        ret <<= 8
    ret >>= 8
    return ret

def cat(a,b,bsize):
    return a<<(bsize*8) | b


def int2bytearray(integer,size):
    ret = int.to_bytes(integer,size,byteorder='big')
    return [i for i in ret]

class HMAC:
    def __init__(self,key,hash_func,blocksize=64):
        self.key = str(key)
        self.hash= hash_func
        self.blocksize = blocksize

    def sign(self,message):
        mint,mlen = message2int(message)
        ipad = make_pad(0x36,self.blocksize)
        opad = make_pad(0x5c,self.blocksize)
        key = self.key
        if (len(self.key) > self.blocksize):
            key = self.hash(key)
        kpad = int(key.ljust(self.blocksize))
        tm = int2message(cat(kpad^ipad,mint,mlen),mlen+self.blocksize)
        r = self.hash(bytearray(tm))
        all = cat(kpad^opad,int(r,16),len(tm))
        return self.hash(int2bytearray(all,len(tm)+self.blocksize))

cipher = '林洲毅 26221017'
key = 0x123445
h1 = HMAC(key,sm3.sm3_hash)
print('Alice signging...')
sign = h1.sign(cipher)
print(sign)

print('Bob checking...')
h2 = HMAC(key,sm3.sm3_hash)
if (sign == h2.sign(cipher)):
    print('succeed')

