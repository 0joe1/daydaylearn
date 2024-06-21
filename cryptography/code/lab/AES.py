Sbox = (
    0x63, 0x7C, 0x77, 0x7B, 0xF2, 0x6B, 0x6F, 0xC5, 0x30, 0x01, 0x67, 0x2B, 0xFE, 0xD7, 0xAB, 0x76,
    0xCA, 0x82, 0xC9, 0x7D, 0xFA, 0x59, 0x47, 0xF0, 0xAD, 0xD4, 0xA2, 0xAF, 0x9C, 0xA4, 0x72, 0xC0,
    0xB7, 0xFD, 0x93, 0x26, 0x36, 0x3F, 0xF7, 0xCC, 0x34, 0xA5, 0xE5, 0xF1, 0x71, 0xD8, 0x31, 0x15,
    0x04, 0xC7, 0x23, 0xC3, 0x18, 0x96, 0x05, 0x9A, 0x07, 0x12, 0x80, 0xE2, 0xEB, 0x27, 0xB2, 0x75,
    0x09, 0x83, 0x2C, 0x1A, 0x1B, 0x6E, 0x5A, 0xA0, 0x52, 0x3B, 0xD6, 0xB3, 0x29, 0xE3, 0x2F, 0x84,
    0x53, 0xD1, 0x00, 0xED, 0x20, 0xFC, 0xB1, 0x5B, 0x6A, 0xCB, 0xBE, 0x39, 0x4A, 0x4C, 0x58, 0xCF,
    0xD0, 0xEF, 0xAA, 0xFB, 0x43, 0x4D, 0x33, 0x85, 0x45, 0xF9, 0x02, 0x7F, 0x50, 0x3C, 0x9F, 0xA8,
    0x51, 0xA3, 0x40, 0x8F, 0x92, 0x9D, 0x38, 0xF5, 0xBC, 0xB6, 0xDA, 0x21, 0x10, 0xFF, 0xF3, 0xD2,
    0xCD, 0x0C, 0x13, 0xEC, 0x5F, 0x97, 0x44, 0x17, 0xC4, 0xA7, 0x7E, 0x3D, 0x64, 0x5D, 0x19, 0x73,
    0x60, 0x81, 0x4F, 0xDC, 0x22, 0x2A, 0x90, 0x88, 0x46, 0xEE, 0xB8, 0x14, 0xDE, 0x5E, 0x0B, 0xDB,
    0xE0, 0x32, 0x3A, 0x0A, 0x49, 0x06, 0x24, 0x5C, 0xC2, 0xD3, 0xAC, 0x62, 0x91, 0x95, 0xE4, 0x79,
    0xE7, 0xC8, 0x37, 0x6D, 0x8D, 0xD5, 0x4E, 0xA9, 0x6C, 0x56, 0xF4, 0xEA, 0x65, 0x7A, 0xAE, 0x08,
    0xBA, 0x78, 0x25, 0x2E, 0x1C, 0xA6, 0xB4, 0xC6, 0xE8, 0xDD, 0x74, 0x1F, 0x4B, 0xBD, 0x8B, 0x8A,
    0x70, 0x3E, 0xB5, 0x66, 0x48, 0x03, 0xF6, 0x0E, 0x61, 0x35, 0x57, 0xB9, 0x86, 0xC1, 0x1D, 0x9E,
    0xE1, 0xF8, 0x98, 0x11, 0x69, 0xD9, 0x8E, 0x94, 0x9B, 0x1E, 0x87, 0xE9, 0xCE, 0x55, 0x28, 0xDF,
    0x8C, 0xA1, 0x89, 0x0D, 0xBF, 0xE6, 0x42, 0x68, 0x41, 0x99, 0x2D, 0x0F, 0xB0, 0x54, 0xBB, 0x16,
)

InvSbox = (
    0x52, 0x09, 0x6A, 0xD5, 0x30, 0x36, 0xA5, 0x38, 0xBF, 0x40, 0xA3, 0x9E, 0x81, 0xF3, 0xD7, 0xFB,
    0x7C, 0xE3, 0x39, 0x82, 0x9B, 0x2F, 0xFF, 0x87, 0x34, 0x8E, 0x43, 0x44, 0xC4, 0xDE, 0xE9, 0xCB,
    0x54, 0x7B, 0x94, 0x32, 0xA6, 0xC2, 0x23, 0x3D, 0xEE, 0x4C, 0x95, 0x0B, 0x42, 0xFA, 0xC3, 0x4E,
    0x08, 0x2E, 0xA1, 0x66, 0x28, 0xD9, 0x24, 0xB2, 0x76, 0x5B, 0xA2, 0x49, 0x6D, 0x8B, 0xD1, 0x25,
    0x72, 0xF8, 0xF6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xD4, 0xA4, 0x5C, 0xCC, 0x5D, 0x65, 0xB6, 0x92,
    0x6C, 0x70, 0x48, 0x50, 0xFD, 0xED, 0xB9, 0xDA, 0x5E, 0x15, 0x46, 0x57, 0xA7, 0x8D, 0x9D, 0x84,
    0x90, 0xD8, 0xAB, 0x00, 0x8C, 0xBC, 0xD3, 0x0A, 0xF7, 0xE4, 0x58, 0x05, 0xB8, 0xB3, 0x45, 0x06,
    0xD0, 0x2C, 0x1E, 0x8F, 0xCA, 0x3F, 0x0F, 0x02, 0xC1, 0xAF, 0xBD, 0x03, 0x01, 0x13, 0x8A, 0x6B,
    0x3A, 0x91, 0x11, 0x41, 0x4F, 0x67, 0xDC, 0xEA, 0x97, 0xF2, 0xCF, 0xCE, 0xF0, 0xB4, 0xE6, 0x73,
    0x96, 0xAC, 0x74, 0x22, 0xE7, 0xAD, 0x35, 0x85, 0xE2, 0xF9, 0x37, 0xE8, 0x1C, 0x75, 0xDF, 0x6E,
    0x47, 0xF1, 0x1A, 0x71, 0x1D, 0x29, 0xC5, 0x89, 0x6F, 0xB7, 0x62, 0x0E, 0xAA, 0x18, 0xBE, 0x1B,
    0xFC, 0x56, 0x3E, 0x4B, 0xC6, 0xD2, 0x79, 0x20, 0x9A, 0xDB, 0xC0, 0xFE, 0x78, 0xCD, 0x5A, 0xF4,
    0x1F, 0xDD, 0xA8, 0x33, 0x88, 0x07, 0xC7, 0x31, 0xB1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xEC, 0x5F,
    0x60, 0x51, 0x7F, 0xA9, 0x19, 0xB5, 0x4A, 0x0D, 0x2D, 0xE5, 0x7A, 0x9F, 0x93, 0xC9, 0x9C, 0xEF,
    0xA0, 0xE0, 0x3B, 0x4D, 0xAE, 0x2A, 0xF5, 0xB0, 0xC8, 0xEB, 0xBB, 0x3C, 0x83, 0x53, 0x99, 0x61,
    0x17, 0x2B, 0x04, 0x7E, 0xBA, 0x77, 0xD6, 0x26, 0xE1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0C, 0x7D,
)
R = (0x00, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40,0x80, 0x1B, 0x36)

def Tmatrix(matrix):
    ret = []
    for i in range(4):
        ret.append([])
        for j in range(4):
            ret[i].append(matrix[j][i])
    return ret


def text2matrix(text):
    matrix=[]
    move=8*15
    for _ in range(4):
        row = []
        for _ in range(4):
            byte = (text >> move)&0xff
            row.append(byte)
            move -= 8

        matrix.append(row)
    return Tmatrix(matrix)

def matrix2text(matrix):
    matrix=Tmatrix(matrix)
    text=0
    for i in range(4):
        for j in range(4):
            append = matrix[i][j]
            text <<= 8
            text |= append
    matrix=Tmatrix(matrix)
    return text

def xtime(a):
    if a&0x80:
        return ((a<<1)&0xff)^0x1B
    else:
        return (a<<1)&0xff

def mul(a,b):
    ans = bit = 0;
    while(2**bit <= a):
        if a&(2**bit):
            t=b
            for _ in range(bit):
                t = xtime(t)
            ans ^= t
        bit+=1
    return ans;


def Tfunc(index,W_i):
    ret = []
    ret.append(Sbox[W_i[1]]^R[index])
    for i in range(1,4):
        ret.append(Sbox[W_i[(i+1)%4]])
    return ret




class AES:
    def __init__(self,seed=0):
        if seed != 0:
            self.keys = self.KeyGenerator(Tmatrix(text2matrix(seed)))

    def SubBytes(self,matrix):
        for i in range(4):
            for j in range(4):
                matrix[i][j]=Sbox[matrix[i][j]]

    def ShiftRows(self,matrix):
        origin=list(map(list,matrix))
        for i in range(4):
            for j in range(4):
                matrix[i][j]=origin[i][(j+i)%4]

    def MixColumns(self,matrix):
        origin=list(map(list,matrix))
        m=[[2,3,1,1],[1,2,3,1],[1,1,2,3],[3,1,1,2]]
        for i in range(4):
            for j in range(4):
                total=0;
                for k in range(4):
                    total ^= mul(m[i][k],origin[k][j])
                matrix[i][j]=total

    def AddRoundKey(self,matrix,keys):
        for i in range(4):
            for j in range(4):
                matrix[i][j] ^= keys[j][i]

    def Inv_SubBytes(self,matrix):
        for i in range(4):
            for j in range(4):
                matrix[i][j]=InvSbox[matrix[i][j]]

    def Inv_ShiftRows(self,matrix):
        origin=list(map(list,matrix))
        for i in range(4):
            for j in range(4):
                matrix[i][j]=origin[i][(j-i+4)%4]

    def Inv_MixColumns(self,matrix):
        origin=list(map(list,matrix))
        m=[[0x0E,0x0B,0x0D,0x09],[0x09,0x0E,0x0B,0x0D],[0x0D,0x09,0x0E,0x0B],[0x0B,0x0D,0x09,0x0E]]
        for i in range(4):
            for j in range(4):
                total=0;
                t=[]
                for k in range(4):
                    t.append(origin[k][j])
                    total ^= mul(m[i][k],origin[k][j])
                matrix[i][j]=total

    def KeyGenerator(self,matrix):
        keys=matrix
        index=0
        for i in range(4,4*11):
            W_i = []
            if (i%4 == 0):
                index += 1
                t = Tfunc(index,keys[i-1])
                for k in range (4):
                    new = keys[i-4][k]^t[k]
                    W_i.append(new)
            else:
                for k in range(4):
                    new = keys[i-4][k]^keys[i-1][k]
                    W_i.append(new)
            keys.append(W_i)
        return keys

    def encrypt(self,text):
        keys = self.keys
        matrix = text2matrix(text)

        self.AddRoundKey(matrix,keys[:4])
        for i in range(1,10):
            self.SubBytes(matrix)
            self.ShiftRows(matrix)
            self.MixColumns(matrix)
            self.AddRoundKey(matrix,keys[i*4:(i+1)*4])
        self.SubBytes(matrix)
        self.ShiftRows(matrix)
        self.AddRoundKey(matrix,keys[40:44])

        return matrix2text(matrix)

    def decrypt(self,cipher,keys):
        matrix = text2matrix(cipher)
        self.AddRoundKey(matrix,keys[40:44])
        self.Inv_ShiftRows(matrix)
        self.Inv_SubBytes(matrix)

        for i in range(9,0,-1):
            self.AddRoundKey(matrix,keys[i*4:(i+1)*4])
            self.Inv_MixColumns(matrix)
            self.Inv_ShiftRows(matrix)
            self.Inv_SubBytes(matrix)
        self.AddRoundKey(matrix,keys[:4])

        return matrix2text(matrix)

    def cbc_encrypt(self,text,iv):
        print('cbc_encrypting...')
        ret = bytes()
        blocksize = 16
        text = bytes(text.encode('utf-8'))
        textlen = len(text)
        enbytes = 0
        while enbytes < textlen:
            if textlen-enbytes < blocksize:
                mlen = textlen-enbytes
            else:
                mlen = blocksize
            m    = text[enbytes:enbytes+mlen]
            mint = int.from_bytes(m,byteorder='big')
            mint ^= iv
            c    = self.encrypt(mint)
            ret += int.to_bytes(c,blocksize,byteorder='big')
            enbytes += blocksize
            iv   = c

        return ret

    def cbc_decrypt(self,cipher,keys,iv):
        print('cbc_decrypting...')
        ret = bytes()
        blocksize = 16
        cipherlen = len(cipher)
        debytes = 0
        while debytes < cipherlen:
            c = cipher[debytes:debytes+blocksize]
            cint = int.from_bytes(c,byteorder='big')
            mint = self.decrypt(cint,keys)
            mint ^= iv
            ret += int.to_bytes(mint,blocksize,byteorder='big')
            debytes += blocksize
            iv   = cint

        return str(ret,encoding='utf-8')

    def ofb_encrypt(self,text,iv):
        print('ofb_encrypting...')
        ret = bytes()
        blocksize = 16
        text = bytes(text.encode('utf-8'))
        textlen = len(text)
        enbytes = 0
        while enbytes < textlen:
            if textlen-enbytes < blocksize:
                mlen = textlen-enbytes
            else:
                mlen = blocksize
            m    = text[enbytes:enbytes+mlen]
            mint = int.from_bytes(m,byteorder='big')
            nextiv = self.encrypt(iv)
            c    = mint^nextiv
            ret += int.to_bytes(c,blocksize,byteorder='big')
            enbytes += blocksize
            iv   = nextiv

        return ret

    def ofb_decrypt(self,cipher,iv):
        print('ofb_decrypting...')
        ret = bytes()
        blocksize = 16
        textlen = len(cipher)
        enbytes = 0
        while enbytes < textlen:
            if textlen-enbytes < blocksize:
                mlen = textlen-enbytes
            else:
                mlen = blocksize
            m    = cipher[enbytes:enbytes+mlen]
            mint = int.from_bytes(m,byteorder='big')
            nextiv = self.encrypt(iv)
            c    = mint^nextiv
            ret += int.to_bytes(c,blocksize,byteorder='big')
            enbytes += blocksize
            iv   = nextiv

        return str(ret,encoding='utf-8')


if __name__ == '__main__':
    seed = 0x2b7e151628aed2a6abf7158809cf4f3c
    iv = 0x123456789
    plaintext = '林洲毅 26221017'

    a1 = AES(seed)
    print('明文')
    print(plaintext)
    t = a1.cbc_encrypt(plaintext,iv)
    print(a1.cbc_decrypt(t,a1.keys,iv))

    t = a1.ofb_encrypt(plaintext,iv)
    print(a1.ofb_decrypt(t,iv))
