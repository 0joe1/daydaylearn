# EIGamel

### 密钥生成

素数p、它的一个原根g

在[2,p-2]中随机选择一个私钥 a ，公开 $y=g^a \mod p$

**公钥**  $(p,g,y)$ 

**私钥**  $a$ ​

其中，素数 p 需要是一个“安全素数”。某些约数分解的算法（如Pollard Rho算法）的计算时间部分取决于被分解数的素因数**减去一的约数大小**，而若被分解的数以一个安全素数2p+1作为约数，**由于此素数减去一有一个大素数p做为约数，计算时间将会变多**。

https://chenliang.org/2021/06/06/attack-dicrete-logarithm/

当 p=2q+1(q是素数) 时，p-1 的质因子显然只有 p、2和p-1。



#### 判断原根

 g 是 p 的原根，当且仅当对于 p-1 的每个质因子 q，都满足 $g^{(p-1)/q}\not \equiv \mod p$​ 



## 加解密

### 加密

随机选择一个 $k\in Z_p$

$c_1=g^k$ 

$c_2=my^k$

发送 $c_1||c_2$



### 解密

$c_2(c1)^{-a} = mg^{ak}g^{-ak}=m$



## 签名

#### 原理

随机选择一个 $k\in Z_p$ ，因为要求逆元要求与p互素。​

$\gamma=g^k \mod p$

$\delta=(m-a\gamma)k^{-1} \mod \phi(p)$



验证时计算 $y^\gamma \gamma^\delta \equiv g^m\mod p$​



#### 实现

将message用Hash压缩成256位，将此作为m。



#### 待解决的问题：

为什么a在[2,p-2]内随机选择？

