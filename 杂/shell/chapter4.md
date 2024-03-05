### Note

```
$ long & medium & short
[1] 4592
[2] 4593
```

方括号内的是作业号，随后是在后台启动的进程ID

作业号或进程ID可用于对作业实施有限的控制。如：

`kill %1`（杀死作业号为1的进程）

`kill 4592`（杀死进程号为4592的进程）



如果执行某个命令,但发觉其完成时间比预想的更长,那么可以用 Ctrl-Z 暂停该命令,返回到提示符下。接着输入 bg 来恢复作业,并在后台继续运行。这么做的效果相当于事前在命令尾部加上 & 符号。



shell用128+N代表被信号N“杀死”。另外，如果使用的值大于255或小于0,则会出现值回绕。



如果想在后台运行作业并在该作业完成前退出 shell，那就需要对作业使用 nohup。

```
$ nohup long & 
nohup: appending output tònohup.out' 
```

nohup 命令只是设置子进程忽略 hangup 信号。你仍可以用 kill命令“杀死”作业，因为 kill 发送的是 SIGTERM 信号，而非SIGHUP 信号。但有了 nohup，作业就不会在退出 bash 时被无意间“杀死”。



### Task

```
mkdir test_good
mkdir test_denied
chmod 744 test_denied/
chmod 777 test_good/
touch test_good/garbage
touch test_denied/garbage
su testman
```

1.执行一条命令：如果能进入目录，就删除garsubage。

2.如何在退出shell的情况下仍然进行作业？

3.写一个脚本，能执行指定目录的所有脚本
