## (saved) set-user-id 的目的

Several reasons: 几个原因：

First and foremost: so that the process knows what user launched it! Otherwise, it'd have no way of knowing -- there is no system call to explicitly get the UID of another process. (There is procfs, but that's nonstandard and unreliable.)
首先也是最重要的：让进程知道是什么用户启动了它！否则，它将无法知道 - 没有系统调用来显式获取另一个进程的 UID。（有procfs，但这是非标准和不可靠的。

As others have mentioned, for safety. Dropping privileges limits the damage that can be done by a malfunctioning setuid-root program. (For instance, a web server will typically bind to a socket on port 80 while running as root, then set its UID/GID to a service user before serving any content.)
正如其他人所提到的，为了安全。删除权限会限制故障的 setuid-root 程序可能造成的损害。（例如，Web 服务器通常会 bind 在以 root 身份运行时连接到端口 80 上的套接字，然后在提供任何内容之前将其 UID/GID 设置为服务用户。

So that files created by the setuid-root process are created as owned by the user that launched the process, not by root.
这样，由 setuid-root 进程创建的文件将创建为由启动进程的用户拥有，而不是由 root 创建。

In some situations, root can have less capabilities than non-root user IDs. One example is on NFS -- UID 0 is typically mapped to "nobody" on NFS servers, so processes running as root do not have the ability to read or modify all files on an NFS share.
在某些情况下，root 用户标识的功能可能少于非 root 用户标识。一个例子是在 NFS 上 - UID 0 通常映射到 NFS 服务器上的“nobody”，因此以 root 身份运行的进程无法读取或修改 NFS 共享上的所有文件。