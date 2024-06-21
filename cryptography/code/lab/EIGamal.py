from gmssl import sm3
from utils import *

def generate_k(p):
    while True:
        k = random.randint(1, p-2)
        if gcd(k, p-1) == 1:
            return k

class EIGamal:
    def __init__(self,p=-1,g=-1,y=-1,a=-1):
        self.p = p
        self.g = g
        self.y = y
        self.a = a

    def gen_newkeys(self):
        print('gen_newkeys...')
        self.p,self.g = getpg(256)
        self.a = random.randint(2,self.p-2)
        self.y = fpowmod(self.g,self.a,self.p)

    def encrypt(self,text):
        print('EIGamal encrypting...')
        k = random.randint(2,self.p-2)
        blocksize = 32
        ret = bytes()
        enbytes = 0
        text = bytes(text.encode('utf-8'))
        textlen = len(text)
        while enbytes < textlen:
            if textlen-enbytes < blocksize:
                mlen = textlen-enbytes
            else:
                mlen = blocksize

            m = text[enbytes:enbytes+mlen]
            mint = int.from_bytes(m,byteorder='big')
            c1 = fpowmod(self.g,k,self.p)
            c2 = (mint*fpowmod(self.y,k,self.p)) % self.p
            ret += int.to_bytes(c1,blocksize,byteorder='big')
            ret += int.to_bytes(c2,blocksize,byteorder='big')
            enbytes += mlen

        return ret

    def decrypt(self,cipher):
        print('EIGamal decrypting...')
        blocksize = 32
        ret = bytes()
        debytes = 0
        cipherlen = len(cipher)
        while debytes < cipherlen:
            c1 = cipher[debytes:debytes+blocksize]
            cint = int.from_bytes(c1,byteorder='big')
            c1 = mod_inv(fpowmod(cint,self.a,self.p),self.p)
            debytes += blocksize

            c2 = cipher[debytes:debytes+blocksize]
            c2 = int.from_bytes(c2,byteorder='big')
            debytes += blocksize

            mint = c1*c2 % self.p
            ret += int.to_bytes(mint,blocksize,byteorder='big')

        return str(ret,encoding='utf-8')

    def sign(self,text):
        k = generate_k(self.p)
        k_n1 = mod_inv(k,self.p-1)
        blocksize = 32

        textarray = bytearray(text)
        mint = int(sm3.sm3_hash(textarray),16)

        ret = bytes()
        c1 = fpowmod(self.g,k,self.p)
        c2 = (mint - self.a*c1)*k_n1 % (self.p-1)
        ret += int.to_bytes(c1,blocksize,byteorder='big')
        ret += int.to_bytes(c2,blocksize,byteorder='big')

        return ret,mint

    def checksign(self,sign,mhash):
        blocksize = 32
        debytes = 0
        c1 = sign[debytes:debytes+blocksize]
        c1 = int.from_bytes(c1,byteorder='big')
        debytes += blocksize

        c2 = sign[debytes:debytes+blocksize]
        c2 = int.from_bytes(c2,byteorder='big')
        debytes += blocksize

        l = fpowmod(self.y,c1,self.p)*fpowmod(c1,c2,self.p) %self.p
        s = fpowmod(self.g,mhash,self.p)
        if l != s:
            return False

        return True



if __name__ == '__main__':
    plaintext = '林洲毅 26221017'
    e1 = EIGamal()
    e1.gen_newkeys()
    c = e1.encrypt(plaintext)
    print(e1.decrypt(c))


