import random
from utils import *


class Rsa:
    def __init__(self,e=-1,N=-1,d=-1):
        self.e = e
        self.N = N
        self.d = d

    def gen_newkeys(self):
        p = get_prime(512)
        q = get_prime(512)
        self.N = p * q

        orla = (p-1)*(q-1)
        self.e = 35537
        while 1:
            if gcd(self.e,orla)==1:
                break
            else:
                self.e -= 2

        self.d = mod_inv(self.e,orla)


    def padding(self,text,textlen):
        space = (1024//8)-textlen-3
        m = bytes([0x00,0x02] + [random.randint(1,255) for _ in range(space)] + [0x00]) + text
        return m

    def unpadding(self,byteflow):
        index = byteflow.find(b'\x00',2)
        if index==-1:
            raise ValueError('Invalid padding')
        return byteflow[index+1:]

    def encrypt(self,text):
        print("RSA encrypting...")
        ret = bytes()
        mlen = 0
        enbytes = 0
        text = bytes(text.encode('utf-8'))
        textlen = len(text)
        blocksize = 1024/8 - 11
        while enbytes < textlen:
            if textlen-enbytes < blocksize:
                mlen = textlen-enbytes
            else:
                mlen = blocksize

            m = self.padding(text[enbytes:enbytes+mlen],mlen)
            mint = int.from_bytes(m,byteorder='big')
            c = fpowmod(mint,self.e,self.N)
            ret += int.to_bytes(c,128,byteorder='big')
            enbytes += mlen

        return ret

    def decrypt(self,cipher):
        print("RSA decrypting...")
        ret = bytes()
        cipherlen = len(cipher)
        print(cipherlen)
        blocksize = 1024//8
        debytes = 0
        while debytes < cipherlen:
            c = cipher[debytes:debytes+blocksize]
            cint = int.from_bytes(c,byteorder='big')
            m = fpowmod(cint,self.d,self.N)
            m = self.unpadding(int.to_bytes(m,128,byteorder='big'))
            ret += m
            debytes += blocksize

        return str(ret,encoding='utf-8')

    def sign(self,text):
        ret = bytes()
        mlen = 0
        enbytes = 0
        text = bytes(text.encode('utf-8'))
        textlen = len(text)
        blocksize = 1024/8 - 11
        while enbytes < textlen:
            if textlen-enbytes < blocksize:
                mlen = textlen-enbytes
            else:
                mlen = blocksize

            m = self.padding(text[enbytes:enbytes+mlen],mlen)
            mint = int.from_bytes(m,byteorder='big')
            c = fpowmod(mint,self.d,self.N)
            ret += int.to_bytes(c,128,byteorder='big')
            enbytes += mlen

        return ret

    def checksign(self,sign):
        ret = bytes()
        signlen = len(sign)
        blocksize = 1024//8
        debytes = 0
        while debytes < signlen:
            c = sign[debytes:debytes+blocksize]
            cint = int.from_bytes(c,byteorder='big')
            m = fpowmod(cint,self.e,self.N)
            m = self.unpadding(int.to_bytes(m,128,byteorder='big'))
            ret += m
            debytes += blocksize

        return str(ret,encoding='utf-8')

if __name__ == '__main__':
    t = "林洲毅 26221017"
    r1 = Rsa()
    r1.gen_newkeys()
    c = r1.encrypt(t)
    print(c.hex())
    m = r1.decrypt(c)
    print(m)
