from RSA import Rsa
from AES import AES,text2matrix,matrix2text


if __name__ == '__main__':
    plaintext = '林洲毅 26221017'
    seed = 0x2b7e151628aed2a6abf7158809cf4f3c
    a1 = AES(seed)
    sendingiv = 0x123456789
    sendingkeys = a1.keys

    print('RSA sending keys and iv...')
    r1 = Rsa()
    r1.gen_newkeys()
    print('encrypting with receiver public key...')
    r2 = Rsa(r1.e,r1.N)
    ckeys = r2.encrypt(str(matrix2text(a1.keys)))
    print('receiver get aes keys')
    keys  = text2matrix(int(r1.decrypt(ckeys)))

    civ = r1.encrypt(str(sendingiv))
    print('receiver get aes iv')
    iv  = int(r1.decrypt(civ))

    print('sending message...')
    cipher = a1.cbc_encrypt(plaintext,iv)
    print('receiving message...')
    a2 = AES()
    m = a2.cbc_decrypt(cipher,a1.keys,iv)
    print(m)
