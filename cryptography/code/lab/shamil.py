import random
from utils import *


class shamil:
    def __init__(self,t):
        self.p = get_prime(1024)
        self.t = t
        self.a = []
        for _ in range(t-1):
            self.a.append(random.randint(1,self.p-1))

    def add_message(self,m):
        self.K = m

    def calc_k(self,x_i,times):
        k = 0
        for i in range(times):
            k += self.a[i]*x_i
            k = k%self.p
            x_i *= x_i
        k = (k+self.K) %self.p
        return k

    def calc_b(self,x_i,keys):
        num = 1
        deno = 1
        for x_j in keys.keys():
            if x_j==x_i:
                continue
            num = num*x_j %self.p
            deno = deno*(x_i-x_j) %self.p
        deno_n1 = mod_inv(deno,self.p)
        return num*deno_n1 %self.p

    def distribute_keys(self,n):
        keys = {}
        for _ in range(n):
            x_i = random.randint(1,self.p-1)
            keys[x_i] = self.calc_k(x_i,self.t-1)
        return keys

    def preprocess(self,keys):
        self.b = {}
        for x_j in keys.keys():
            self.b[x_j] = self.calc_b(x_j,keys)

    def recover(self,keys):
        if len(keys)<self.t:
            print('keycount must >= t')
            return
        self.preprocess(keys)

        K = 0
        for x_i,b in self.b.items():
            k_i = keys[x_i]
            K += k_i*b
            K = K%self.p
        return K


secret = '林洲毅 26221017'
secretlen = len(bytes(secret.encode('utf-8')))
blocksize = 64

s1 = shamil(3)
secret_list = []
enbytes = 0
while (enbytes < secretlen):
    if secretlen-enbytes < blocksize:
        mlen = secretlen-enbytes
    else:
        mlen = blocksize
    mint,mlen = message2int(secret[enbytes:enbytes+mlen])
    s1.add_message(mint)
    keys = s1.distribute_keys(5)
    K = int2message(s1.recover(keys),mlen)
    print(K)
    enbytes += mlen

keys = s1.distribute_keys(5)




