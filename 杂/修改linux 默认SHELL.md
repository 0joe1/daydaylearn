# [修改linux 默认SHELL](https://www.cnblogs.com/xuyaowen/p/linux-chsh.html)

**首先你得查看可以用的shell：**

1.命令：chsh -l ，结果如下：

/bin/sh
/bin/bash
/sbin/nologin
/usr/bin/sh
/usr/bin/bash
/usr/sbin/nologin
/usr/bin/fish

2.设置默认shell

chsh -s /usr/bin/fish 输入管理员密码

3.查看一下没有设置到成功

grep 用户名 /etc/passwd

这样重启后，就能使用改变之后的shell了。