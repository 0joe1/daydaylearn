vscode 为每个项目的根目录下新建了一个 `.vscode` 目录，里面保存了一个 `tasks.json` 来定义针对该项目的任务。而 asynctasks.vim 采用类似机制，在每个项目的根文件夹下面放一个 `.tasks` 来描述针对该项目的局部任务，同时维护一份 `~/.vim/tasks.ini` 的全局任务配置，适配一些通用性很强的项目，避免每个项目重复写 `.tasks` 配置。



### 整个项目的编译运行

解决项目编译运行首先需要定位项目目录，在 Vim 中，众多插件也早就采用了一套叫做 `rootmark` 的机制， 从当前文件所在目录一直往上递归到根目录，直到发现某一级父目录中包含下列项目标识：

```VimL
let g:asyncrun_rootmarks = ['.git', '.svn', '.root', '.project', '.hg']
```

则认为该目录是当前项目的根目录，如向上搜索到根目录都没找到任何标识，则将当前文件所在目录当作项目根目录。

如果项目在版本管理系统里，那么仓库的顶层文件夹就会被自动识别成项目的根目录。

如果你有一个项目不在 `git` 中，或者 `git`仓库下面有很多项目，不想让最上层作为项目根目录的话，只要在你想要的地方新建一个空的 `.root` 文件就行了。

最后一个边界情况，如果你没有打开文件（未命名新文件窗口），或者当前 buffer 是一个非文件（比如工具窗口），怎么办呢？此时会使用 vim 的**当前文件夹**（即 `:pwd` 返回的值）作为项目目录。



形状如同 `$(VIM_xxx)` 的宏，这些是vim自带的，具体在运行时会具体替换成对应的值，常用的宏有：

```bash
$(VIM_FILEPATH)    # 当前 buffer 的文件名全路径
$(VIM_FILENAME)    # 当前 buffer 的文件名（没有前面的路径）
$(VIM_FILEDIR)     # 当前 buffer 的文件所在路径
$(VIM_FILEEXT)     # 当前 buffer 的扩展名
$(VIM_FILENOEXT)   # 当前 buffer 的主文件名（没有前面路径和后面扩展名）
$(VIM_PATHNOEXT)   # 带路径的主文件名（$VIM_FILEPATH 去掉扩展名）
$(VIM_CWD)         # 当前 Vim 目录（:pwd 命令返回的）
$(VIM_RELDIR)      # 相对于当前路径的文件名
$(VIM_RELNAME)     # 相对于当前路径的文件路径
$(VIM_ROOT)        # 当前 buffer 的项目根目录
$(VIM_CWORD)       # 光标下的单词
$(VIM_CFILE)       # 光标下的文件名
$(VIM_CLINE)       # 光标停留在当前文件的多少行（行号）
$(VIM_GUI)         # 是否在 GUI 下面运行？
$(VIM_VERSION)     # Vim 版本号
$(VIM_COLUMNS)     # 当前屏幕宽度
$(VIM_LINES)       # 当前屏幕高度
$(VIM_SVRNAME)     # v:servername 的值
$(VIM_DIRNAME)     # 当前文件夹目录名，比如 vim 在 ~/github/prj1/src，那就是 src
$(VIM_PRONAME)     # 当前项目目录名，比如项目根目录在 ~/github/prj1，那就是 prj1
$(VIM_INIFILE)     # 当前任务的 ini 文件名
$(VIM_INIHOME)     # 当前任务的 ini 文件的目录（方便调用一些和配置文件位置相关的脚本）
```

同名的环境变量也被设置成同样的值，例如你某个任务命令太复杂了，你倾向于写道一个 shell 脚本中，那么 `command` 配置就可以简单的调用一下脚本文件：



可以在任务中用 `$(VIM_ROOT)` 或者它的别名 `<root>` 来代替项目位置：

```ini
[project-build]
command=make
# 设置在当前项目的根目录处运行 make
cwd=$(VIM_ROOT)

[project-run]
command=make run
# <root> 是 $(VIM_ROOT) 的别名，写起来容易些
cwd=<root>
output=terminal
```



### 配置优先级

并不需要，最简单的做法是你可以把上面两个任务（`project-build` 和 `project-run`）配置成公共任务，放到 `~/.vim/tasks.ini` 这个公共配置里，然后对于所有一般的 make 类型项目，你就不用配置了。

而对于其他类型的项目，比如某个项目中，我还在用 `msbuild` 来构建，我就单独给这个项目的 `.tasks` 局部配置中，再定义两个名字一模一样的局部任务，比如项目 `A` 中：

```ini
[project-build]
command=vcvars32 > nul && msbuild build/StreamNet.vcxproj /property:Configuration=Debug /nologo /verbosity:quiet
cwd=<root>
errorformat=%f(%l):%m

[project-run]
command=build/Debug/StreamNet.exe
cwd=<root>
output=terminal
```

在 `asynctasks.vim` 中，局部配置的优先级高于全局配置，下层目录的配置高于上层目录的配置（`.tasks` 可以嵌套存在）。因此，在 `A` 项目中，老朋友 `project-build` 和 `project-run` 两个任务被我们替换成了针对 `A` 项目的 msbuild 的方法。

这样在 `A` 这个项目中，我任然可以使用 F7 来编译项目，然后 F6 来运行整个项目，不会因为项目切换而导致我的操作发生改变，我可以用统一一致的操作，处理各种不同类型的项目，这就是本地任务和全局任务协同所能产生的奇迹。

PS：可以用 `:AsyncTaskEdit` 来编辑本地任务，`:AsyncTaskEdit!` 来编辑全局任务。



### 多种运行模式

配置任务时，output 字段可以设置如何运行任务，它有下面两个值：

- `quickfix`： 默认值，实时显示输出到 quickfix 窗口，并匹配 errorformat。
- `terminal`：在终端内运行任务。

设置 `terminal` 时，可以通过一个全局变量：

```VimL
let g:asynctasks_term_pos = 'xxx'
```

来具体设置终端的工作位置和工作模式，它有几个可选值：

|    名称    |   类型   | 说明                                                         |
| :--------: | :------: | ------------------------------------------------------------ |
| `quickfix` |  伪终端  | 默认值，使用 quickfix 窗口模拟终端，输出不匹配 `errorformat`。 |
|   `tab`    | 内置终端 | 在一个新的 tab 上打开内置终端，运行程序。                    |
|   `top`    | 内置终端 | 在上方打开可复用内部终端。                                   |
| `external` | 外部终端 | 启动一个新的操作系统的外置终端窗口，运行程序。               |



### Runner

得益于 AsyncRun 的 [customizable runners](https://github.com/skywind3000/asyncrun.vim/wiki/Customize-Runner) 机制，任务可以按你想要的任何方式执行，插件发布包含了一批默认 runner：

| Runner    | 描 述                          | 需 求                                                     | 链 接                                                        |
| --------- | ------------------------------ | --------------------------------------------------------- | ------------------------------------------------------------ |
| `gnome`   | 在新的 Gnome 终端里运行        | GNOME                                                     | [gnome.vim](https://github.com/skywind3000/asyncrun.vim/blob/master/autoload/asyncrun/runner/gnome.vim) |
| `tmux`    | 在一个新的 tmux 的 pane 里运行 | [Vimux](https://github.com/preservim/vimux)               | [tmux.vim](https://github.com/skywind3000/asyncrun.vim/blob/master/autoload/asyncrun/runner/tmux.vim) |
| `quickui` | 在 quickui 的浮窗里运行        | [vim-quickui](https://github.com/skywind3000/vim-quickui) | [quickui.vim](https://github.com/skywind3000/asyncrun.vim/blob/master/autoload/asyncrun/runner/quickui.vim) |
| `xfce`    | 在 xfce 终端中运行             | xfce4-terminal                                            | [xfce.vim](https://github.com/skywind3000/asyncrun.vim/blob/master/autoload/asyncrun/runner/xfce.vim) |
| `konsole` | 在 KDE 的自带终端里运行        | KDE                                                       | [konsole.vim](https://github.com/skywind3000/asyncrun.vim/blob/master/autoload/asyncrun/runner/konsole.vim) |


当为 AsyncRun 定义了一个 runner，可以在本插件的任务配置里用 `pos` 配置来指定：

```ini
[file-run]
command=python "$(VIM_FILEPATH)"
cwd=$(VIM_FILEDIR)
output=terminal
pos=gnome
```

当你使用:

```VimL
:AsyncTask file-run
```

这个任务将会在 `gnome-terminal` 的 runner 里执行。

如果你想避免为大部分任务设置 `pos` 配置，设置全局配置会方便很多：

```VimL
let g:asynctasks_term_pos = 'gnome'
```

全局配置生效后，任何 `output=terminal` 的任务如果没有包含 `pos` 字段，都将默认用 `gnome-terminal` 来运行任务。

![image-20230529205413252](assets/image-20230529205413252.png)

注意，任务配置里的 `option` 字段必须为 `terminal`，同时任务配置里的 `pos` 会比全局配置 `g:asynctasks_term_pos` 拥有更高的优先级。

