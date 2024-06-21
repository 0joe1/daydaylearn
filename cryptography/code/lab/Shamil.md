# Shamil

### Lagrange 插值多项式算法

多项式 $h(x)=a_{t-1}x^{t-1}+\cdots+a_1x+K \in Z_p[x]$

假设它 $h(x)$ 有几个解$x_1、x_2...$，满足 $h(x)$ 可被 $(x-x_i)$ 整除

$h(x)=\sum_{l=1}^{t}\prod_{j=1,j\neq1}\frac{x-x_{ij}}{x_{il}-x_{ij}}$

显然，对某个 $x=x_{il}$ ，有 $\prod_{j=1,j\neq1}\frac{1}{x_{il}-x_{ij}}$ 作为它的逆元。

