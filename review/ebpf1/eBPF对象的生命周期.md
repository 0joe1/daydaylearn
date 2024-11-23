## eBPF对象的生命周期

### 创建BPF映射

进行`bpf(BPF_MAP_CREATE, ...)`系统调用时, 内核会:

- ##### 分配一个`struct bpf_map`对象

- 设置该对象的引用计数: `refcnt=1`

- 返回一个fd给用户空间

fd关闭, 导致`refcnt--`变为0之后就会被内核释放掉



### 加载BPF程序

如果BPF程序引入了BPF映射。

那么它所引用的映射的refcnt++，同时，它的refcnt被设置为1。

当它被关闭时，所引用的所有映射refcnt--

 

### 把BPF程序attach到钩子上

BPF程序的`refcnt++`



#### BPF文件系统(BPFFS)

用户空间的程序可以把一个BPF或者BPF映射固定到BPFFS, 以生成一个文件. pin操作会使得BPF对象`refcnt++`

如果想要取消某个固定的对象, 只要调用unlink()即可, 也可以直接用rm命令删除这个文件