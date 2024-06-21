# HMAC

总结起来就一个公式：

${HMAC}_k(M)=H\{(K^+\oplus opad)||H[(K^+\oplus ipad) ||M]\}$

![image-20240620102426902](/home/username/.config/Typora/typora-user-images/image-20240620102426902.png)



一般而言，密钥小于等于单向散列函数的分组长度，后面填充0至分组长度即可。

如果密钥长度大于分组长度，就对密钥进行一次哈希。