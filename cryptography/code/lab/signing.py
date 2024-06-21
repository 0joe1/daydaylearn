from RSA import Rsa
from EIGamal import EIGamal

if __name__ == '__main__':
    text = '林洲毅 26221017'
    print('********** Rsa sign test ************')
    r1 = Rsa()
    r1.gen_newkeys()
    print('Alice signing...')
    sign = r1.sign(text)
    print('Bob checking...')
    r2 = Rsa(r1.e,r1.N)
    if (text == r2.checksign(sign)):
        print('succeed')

    print('********** EIGamal sign test ************')
    e1 = EIGamal()
    e1.gen_newkeys()
    print('Alice signing...')
    sign,mhash = e1.sign(text)
    print('Bob checking...')
    e2 = EIGamal(e1.p,e1.g,e1.y)
    if (e2.checksign(sign,mhash)):
        print('succeed')

