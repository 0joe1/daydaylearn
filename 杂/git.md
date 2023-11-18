从根本上来讲 Git 是一个内容寻址（content-addressable）文件系统，并在此之上提供了一个版本控制系统的用户界面。 



##### info/exclude 与 .gitignore

info/exclude，用于排除提交规则，与 .gitignore 功能类似。

他们的区别在于.gitignore 这个文件本身会提交到版本库中去，用来保存的是公共需要排除的文件；而info/exclude 这里设置的则是你自己本地需要排除的文件，他不会影响到其他人，也不会提交到版本库中去。



##### 那一大段乱码是什么东西？

将一个将待存储的数据外加一个头部信息（header）一起做 SHA-1 校验运算而得的校验和。

可以在 `objects` 目录下看到一个文件。 这就是开始时 Git 存储内容的方式——一个文件对应一条内容，以该内容加上特定头部信息一起的 SHA-1 校验和为文件命名。 校验和的前两个字符用于命名子目录，余下的 38 个字符则用作文件名。

`<header>` 是一个固定格式的字符串，用于描述文件的类型和大小等信息，以确保对象名的唯一性。它包括以下内容：

```
blob <content_length>\0
```

- `blob` 是文件类型的标识符，表示这是一个普通文件。
- `<content_length>` 是文件内容的长度，以字节为单位。
- `\0` 是一个空字符，用于分隔 `<header>` 和 `<content>`。

上述类型的对象我们称之为数据对象（blob object）



##### 相同内容相同id

即使在两个不同的Git仓库中，相同内容的文件greeting也将使用相同的id来保存，甚至在整个互联网上也是一样的。（译者注：这是由于hash算法相同）

Git即使知道这个文件来自两个不同的仓库，但是只要他们的内容是一致的，Git就只会保存一份副本！



##### Git存储对象与Unix文件系统的对比

 所有内容均以树对象和数据对象的形式存储，其中树对象对应了 UNIX 中的目录项，数据对象则大致上对应了 i-node。 

一个树对象包含了一条或多条树对象记录（tree entry），每条记录含有一个指向数据对象或者子树对象的 SHA-1 指针，以及相应的模式、类型、文件名信息。

```
// 一个包含文件和目录的目录
type tree = map<string, tree | blob>
```

相同点：

1.tree可以包括blob，也可以包括tree。目录可以包括普通文件也可以包括目录。

2.i-node并不存储文件名（仅通过目标列表内的一个映射来定义文件名称）。同样地，blob 对象仅仅保存文件内容，没有保存自己的元信息。

3.仅当 i-node 的链接计数降为0时，会释放相应的i-node记录数据块。而blob也是只有在所有文件内容相同的文件都被删光之后才会消失。



##### 何为提交

```
// 每个提交都包含一个父辈，元数据和顶层树
type commit = struct {
    parent: array<commit>
    author: string
    message: string
    snapshot: tree
}
```



##### Git 引用

 我们需要一个文件来保存 SHA-1 值，并给文件起一个简单的名字，然后用这个名字指针来替代原始的 SHA-1 值。在 Git 里，这样的文件被称为“引用（references，或缩写为 refs）”；



##### HEAD

HEAD 文件是一个符号引用（symbolic reference），指向目前所在的分支。 所谓符号引用，意味着它并不像普通引用那样包含一个 SHA-1 值——它是一个指向其他引用的指针。 如果查看 HEAD 文件的内容，一般而言我们看到的类似这样：

```
$ cat .git/HEAD
ref: refs/heads/master
```



##### 远程引用

我们将看到的第三种引用类型是远程引用（remote reference）。 如果你添加了一个远程版本库并对其执行过推送操作，Git 会记录下最近一次推送操作时每一个分支所对应的值，并保存在 refs/remotes 目录下。 

远程引用和分支（位于 refs/heads 目录下的引用）之间最主要的区别在于，远程引用是只读的。 虽然可以 git checkout 到某个远程引用，但是 Git 并不会将 HEAD 引用指向该远程引用。因此，你永远不能通过 commit 命令来更新远程引用。 Git 将这些远程引用作为记录远程服务器上各分支最后已知位置状态的书签来管理。



##### 推送与拉取

你必须显式地推送想要分享的分支。

 `git push <remote> <local branch>:<remote branch>`：

 `git branch --set-upstream-to=<remote>/<remote branch>`: 创建本地和远端分支的关联关系，会在 .git/config下添加：

```
[branch "master"]
        remote = orange
        merge = refs/heads/bbb
```

`push --set-upstream <remote> <remote branch>` 也有相同的功能，同时它还会把东西push上去。





### 命令集

##### hash-object

 `hash-object` 将任意数据保存于 `.git` 目录，并返回相应的键值。`-w` 选项指示 `hash-object` 命令存储数据对象；若不指定此选项，则该命令仅返回对应的键值。



##### cat-file

可以通过 `cat-file` 命令从 Git 那里取回数据。 为 `cat-file` 指定 `-p` 选项可指示该命令自动判断内容的类型，并为我们显示格式友好的内容。在 Git 中,^{} 表示获得一个对象的指定信息。

利用 `cat-file -t` 命令，可以让 Git 告诉我们其内部存储的任何对象类型，只要给定该对象的 SHA-1 值。



##### update-index

将文件加入到index中。 如果文件本来不在index中，那么需要添加 --add 选项；可 `--cacheinfo` 选项，手动指定文件模式、SHA-1 与文件名



##### ls-files

查看index中引用的东西



##### write-tree

 write-tree 命令将当前Index中的所有内容打包。 



##### read-tree

`read-tree --prefix=<prefix>`将一个已有的树对象作为子树读入index



##### commit-tree

 `commit-tree` 命令创建一个提交对象，为此需要指定一个树对象的 SHA-1 值，以及该提交的父提交对象（如果有的话）`-p`参数表示父对象



## 分享

##### 演示 info/exclude 的作用

git status 后修改，然后再次查看 git status



##### 用 hash-object 将blob加入.git

1.将一个随意内容放进 .git

看看它的内容，第一次失败了（原来还要加上目录）。

第二次加上目录后成功，发现就是我们刚刚输入的。



2.创建一个文件，hash后发现git status没有，说明它没有被添加进暂存区

3.修改这个文件，再次hash，发现和原来的不同。

4.copy这个文件，发现 objects目录下 的内容没有增加。

oops! 看来相同内容的文件使用的id都是一样的，这大概是因为用的哈希算法是固定的，由此可以推知即使知道这个文件来自两个不同的仓库，但是只要他们的内容是一致的，Git就只会保存一份副本！



##### 检查 tree 是什么

1.创建一个tree。查看一下.gits目录有没有发生什么变化，看到objects目录下多了个相同哈希值的东西。

说明tree也是一个object，在某种意义上来说跟blob具有相同的地位。

2.git status，发现还没commit。接着再cat-file -t 一下，发现类型是tree。

说明这个东西不是 commit ，我们将其称为 tree。

3.cat-file -p 查看 tree 中的内容，发现是几个Blob对象。

4.使用read-tree将tree写入index。git status一下，index确实修改了。向里面添加tree，发现没问题。

于是我们发现这个 tree Unix文件系统很像，于是我们可以做一个类比。



##### 查看 HEAD 到底是什么东西

1.refs的heads下有一个master，cat-file -t 查看，发现是个commit

2.cat commit下的内容，发现是一串哈希值

3.分别 cat-file 哈希值和master分支，得到的结果是一样的

说明是mater分支储藏的是指向一个commit的指针。那么我们将别的commit 替换这个master的内容，当前master所指向的地方是不是会发生改变呢？

4.改写 master 文件的方式，git log查看

你会发现 如今HEAD指向的commit已经变成了我们刚才指定的commit，它的parent也都消失了。

5.再在heads下添加其他文件,checkout到新建分支，观察 HEAD 的变化



##### 远程引用

1.将本地分支关联到远程，观察 config 文件的变动，看到有一行 fetch

想必跟 git fetch 有关系，将冒号前的远程分支的 commit 下载到本地，并将 refs/remote/ 下的生成相应的分支指针，指向相应的 commit 

2.改动 fetch那一行的内容，观察相应的变化















