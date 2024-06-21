import random
from AES import AES
from utils import *

plaintext = '林洲毅 26221017'
p,g = getpg(64)
print('A generate X_A')
x_a = random.randint(2**20,2**60)
pka1 = fpowmod(g,x_a,p)
print('B generate X_B')
x_b = random.randint(2**20,2**60)
pkb1 = fpowmod(g,x_b,p)

K = pka1*pkb1 %p
a = AES(K%128)
c = a.cbc_encrypt(plaintext,0)
print(a.cbc_decrypt(c,a.keys,0))

