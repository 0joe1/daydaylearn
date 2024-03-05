# 如何配置vim/neovim以使其使用Makefile定位include（头文件）？

在vim的配置文件（~/.vimrc）或neovim的配置文件（~/.config/nvim/init.vim）中添加以下内容：

```vim
set makeprg=make\ -C\ %:h
set errorformat=%f:%l:%c:\ %m,%f:%l:\ %m
set includeexpr=substitute(v:fname,'\(.*\)/.*','.\/\1\/include/**','')
```

这三行代码的作用如下：

- `set makeprg=make\ -C\ %:h`：告诉vim/nvim在打开Makefile所在的目录中运行make命令来编译代码。
- `set errorformat=%f:%l:%c:\ %m,%f:%l:\ %m`：告诉vim/nvim如何[解析](http://www.volcengine.com/product/trafficroute)make命令输出的错误信息。这个格式应该与`make`命令的输出保持一致，以便正确跳转到错误位置。
- `set includeexpr=substitute(v:fname,'\(.*\)/.*','.\/\1\/include/**','')`：告诉vim/nvim如何[解析](http://www.volcengine.com/product/trafficroute)代码中的`#include`语句。这里使用`includeexpr`选项将包含文件的路径替换为特定格式的路径。例如，如果你正在编辑的文件路径是`/path/to/src/main.c`，其中有一个`#include <stdio.h>`语句，那么上述代码将自动将路径转换为`./path/to/include/**/stdio.h`，其中`**`表示在`/path/to/include`及其子目录中查找头文件。

使用这些配置后，当你在vim/nvim中的某个源文件中[调用](https://api.volcengine.com/api-explorer)make时，它会使用Makefile编译你的代码，并在遇到编译错误时自动跳转到相应的行号和列。

注意：如果你的项目中具有多个Makefile（例如，一个Makefile在src目录中，另一个Makefile在test目录中），你还需要设置`makeprg`选项以便正确[调用](https://api.volcengine.com/api-explorer)make。举个例子，如果你要在`/path/to/src/main.c`中编译`/path/to/src/Makefile`，并在`/path/to/test/test.c`中编译`/path/to/test/Makefile`，那么可以设置：

```vim
autocmd FileType c set makeprg=
```