### Linux 工作调度的种类: at, cron

- 一种是例行性的,就是每隔一定的周期要来办的事项;
- 一种是突发性的,就是这次做完以后就没有的那一种 ( 3C 大降价...)

使用 at 与 crontab 这两个好东西!
at ：可以处理仅执行一次就结束调度的指令。
crontab ：crontab 这个指令所设置的工作将会循环的一直进行下去! 可循环的时间为分钟、小时、每周、每月或每年等。crontab 除了可以使用指令执行外,亦可编辑/etc/crontab 来支持。



### 仅执行一次的工作调度

首先,我们先来谈谈单一工作调度的运行,那就是 at 这个指令的运行!

#### 15.2.1 atd 的启动与 at 运行的方式

要使用单一工作调度时,我们的 Linux 系统上面必须要有负责这个调度的服务,那就是 atd 这
个玩意儿。 不过并非所有的 Linux distributions 都默认会把他打开的,所以呢,某些时刻我们
必须要手动将他启用才行。 启用的方法很简单,就是这样:

```
[root@study ~]# systemctl restart atd # 重新启动 atd 这个服务
[root@study ~]# systemctl enable atd  # 让这个服务开机就自动启动
[root@study ~]# systemctl status atd  # 查阅一下 atd 目前的状态 
atd.service - Job spooling tools
Loaded: loaded (/usr/lib/systemd/system/atd.service; enabled)  # 是否开机启动
Active: active (running) since Thu 2015-07-30 19:21:21 CST; 23s ago # 是否正在运行中
Main PID: 26503 (atd)
CGroup: /system.slice/atd.service
└─26503 /usr/sbin/atd -f
Jul 30 19:21:21 study.centos.vbird systemd[1]: Starting Job spooling tools...
Jul 30 19:21:21 study.centos.vbird systemd[1]: Started Job spooling tools.
```



