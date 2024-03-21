### 摘要：

Steganography 是一项在图像载体中隐藏秘密的技术。

先前推出的DCGAN能够生成更精巧的含密图像，能够成功欺骗鉴别器。



### 1.引子

DCGAN 生成的载体图像，比普通的图像更难被隐写分析器分析出来。我们尝试了这个方法是否能欺骗某个特定的隐写分析器（查看图像中是否含密）。



### 2.隐写术

**defination**: message T ，image I ， steganography algorithm: a map $T\times I \rightarrow \hat{I}$

上面的  $\hat{I}$​ 是一个携带秘密信息，但无法从视觉上与原图区分的图像。 



有一些算法借鉴了LSB的思想，但采用更加复杂的技术：

挑选要改变的比特比特， 使得最终对图像的影响最小。

$$
D(X,\hat{X})=\rho(X_{ij},\hat{X_{ij}})\sum_{i=1}^{n_1} \sum_{j=1}^{n_2} |X_{ij}|
$$
D代表失真函数，$\rho(X_{ij},\hat{X_{ij}})$ 是对某一个特定算法来说，改变像素 $X_{ij}$​ 的损失。



stegananalysis 常用来检测 container 中隐藏的信息。基本分析方法是特征提取以及一些传统的机器学习方法（如 SVM,决策树等等）。随着深度神经网络的发展，基于神经网络的方式愈发得到关注，比如说有人发现相比平常的 classifier ， CNN 显著地提升了分类准确性。



### 3.对抗网络

二元交叉熵函数
$$
L(D,G)=E_{x\sim p_{data(x)}}[\log D(x)]+E_{z\sim p_{noise(z)}}[\log (1-D(G(z)))] -> \mathop{min}\limits_G \; \mathop{max}\limits_D
$$
$D(x)$代表鉴别器判断 x 是一个真实图像的概率，$G(z)$是从噪音 z 生成的图像。

保持 G 不变，更新模型D： $\theta_D \leftarrow \theta_D + \lambda_D \nabla_D L $​ 。

其中，
$$
\nabla_D L=\frac{\partial}{\partial \theta_D}\left\{E_{x\sim p_{data(x)}}[\log D(x)]+E_{z\sim p_{noise(z)}}[\log (1-D(G(z,\theta_G),\theta_D))]  \right\}
$$
保持 D 不变，更新 G：$\theta_G \leftarrow \theta_G - \lambda_G \nabla_GL$

其中，
$$
\nabla_G L=\frac{\partial}{\partial \theta_G}E_{z\sim p_{noise(z)}}[\log(1-D(G(z,\theta_G),\theta_D))]
$$
深层神经网络DCGAN采用了GAN的思想，专门针对图像生成。



### 4.Steganographic GAN

在上面的基础上增添了鉴别器S，用来鉴定某个图像是否含有隐藏信息。
$$
L=\alpha(E_{x\sim p_{data}(x)}[\log D(x)]+E_{z\sim p_{noise(z)}}[\log (1-D(G(z)))])+(1-\alpha)E_{z \sim p_{noise(z)}}[\log S(Stego(G(z)))+\log (1-S(G(z)))] -> \mathop{min}\limits_G \; \mathop{max}\limits_D \; \mathop{max}\limits_S
$$
$Stego(x)$ 表示含密的载体图像。

更新D：$\theta_D \leftarrow \theta_D + \lambda_D \nabla_G L$

其中：
$$
\nabla_G L = \alpha(E_{x\sim p_{data(x)}}+E_{z\sim p_{noise(z)}})
$$


