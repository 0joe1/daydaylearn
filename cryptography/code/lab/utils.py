import random

def gcd(a,b):
    while b:
        a,b = b,a%b
    return a


def mod_inv(x,n):
    s_jn1 = 1
    t_jn1 = 0
    s_j = 0
    t_j = 1
    a = x
    b = n
    while b:
        q = a//b
        a,b = b,a%b
        s_j,s_jn1 = s_jn1-s_j*q,s_j
        t_j,t_jn1 = t_jn1-t_j*q,t_j
    if (s_jn1 < 0):
        s_jn1 += n
    return s_jn1

def fpowmod(a,b,n):
    ret = 1
    while b:
        if (b & 1):
            ret = (ret*a) % n
        b >>= 1
        a = a*a % n

    return ret


def miller_test(a,num):
    h = num-1
    n = 0
    while h&1==0:
        n += 1
        h >>= 1

    if fpowmod(a,num-1,num) != 1:
        return False

    for k in range(0,n):
        t = fpowmod(a,(2**k)*h,num)
        if t==1 or t==num-1:
            return True
    return False


def is_prime(num):
    lowprime_table=[2,3,5,7,11,13,17,19,23,29,31,
                    37,41,43,47,53,59,61,67,71,73,
                    79,83,89,97]
    for prime in lowprime_table:
        if num % prime == 0:
            return False

    for _ in range(15):
        a = random.randint(2,num-1)
        if not(miller_test(a,num)):
            return False
    return True


def get_prime(bitlen):
    while 1:
        num = random.randrange(1<<(bitlen-1),1<<bitlen)
        if (is_prime(num)):
            return num
    return -1  # never gets here

def bytearray(message):
    return [i for i in bytes(message.encode('utf-8'))]

def test_g(g,facs,p):
    for fac in facs:
        if fpowmod(g,(p-1)//fac,p)==1:
            return False
    return True

def get_generator(p):
    phi  = p-1
    facs = [2,phi//2,phi]
    if test_g(2,facs,p):
        return 2
    if test_g(phi//2,facs,p):
        return phi//2
    return False

def getpg(size):
    p = g = 0
    while 1:
        q = get_prime(size-1)
        p = 2*q + 1
        if not(is_prime(p)):
            continue
        g = get_generator(p)
        if g != False:
            break
    return p,g

def message2int(message):
    m = bytes(message.encode('utf-8'))
    mlen = len(m)
    return int.from_bytes(m,byteorder='big'),mlen

def int2message(integer,size):
    ret = int.to_bytes(integer,size,byteorder='big')
    return str(ret,encoding='utf-8')

