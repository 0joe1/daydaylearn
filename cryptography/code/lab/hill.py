from utils import gcd,mod_inv
import numpy as np
import time


def Tmatrix(matrix,size):
    ret = []
    for i in range(size):
        ret.append([])
        for j in range(size):
            ret[i].append(matrix[j][i])
    return ret

def geninv_matrix(size,mod,seed):
    rd = np.random.RandomState(seed)
    while 1:
        matrix = rd.randint(0,mod-1,(size,size))
        D = np.linalg.det(matrix)
        if gcd(D,mod)==1:
            return matrix


def message2numflow(message):
    ret = []
    for c in message:
        ret.append(int(ord(c) - ord('a')))
    return ret

def numflow2message(numflow):
    message = ''
    for c in numflow:
        message += chr(c+ord('a'))
    return message

class Hill:
    def __init__(self,size):
        seed = int(time.time())
        self.size = size
        self.kmatrix = geninv_matrix(size,26,seed)

    def modinv_matrix(self,matrix,mod):
        m_star = []
        D = np.linalg.det(matrix)
        for i in range(self.size):
            row = []
            for j in range(self.size):
                M_ij = np.linalg.det(np.delete(np.delete(matrix,i,0),j,1))
                row.append(int(mod_inv(D,26))*pow(-1,i+j)*round(M_ij) % mod)
            m_star.append(row)
        return Tmatrix(m_star,self.size)

    def padding(self,message):
        while len(message)%self.size:
            message += 'h'
        return message

    def unpadding(self,message,mlen):
        return message[0:mlen]

    def encrypt(self,message):
        print('Hill encrypting...')
        ret = []
        message = self.padding(message)
        mnumflow = message2numflow(message)
        for i in range(0,len(message),self.size):
            mmatrix = np.array(mnumflow[i:i+self.size])
            new = (mmatrix@self.kmatrix) %26
            ret.extend(new)
        return numflow2message(ret)

    def decrypt(self,message,mlen):
        print('Hill decrypting...')
        ret = ''
        inv_kmatrix = self.modinv_matrix(self.kmatrix,26)
        cnumflow = message2numflow(message)
        for i in range(0,len(cnumflow),self.size):
            cmatrix = np.array(cnumflow[i:i+self.size])
            new = (cmatrix@inv_kmatrix) %26
            ret += numflow2message(new)
        ret = self.unpadding(ret,mlen)
        return ret

h1 = Hill(2)
message = 'linzhouyi'
c = h1.encrypt(message)
print(c)
m = h1.decrypt(c,5)
print(message)
