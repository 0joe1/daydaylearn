定义变量

```
$ foo=bar
echo $foo
```

得到结果

```
bar
```



单引号双引号在 对待里面的变量时不一样：

```
echo "Value is $foo"
自动替换 > value is bar
echo 'Value is $foo'
不会替换 > value is $foo
```



\$0 - 脚本名
\$1 到 \$9 - 脚本的参数。 \$1 是第一个参数，依此类推。
\$@ - 所有参数
\$# - 参数个数
\$? - 前一个命令的返回值
$$ - 当前脚本的进程识别码
!! - 完整的上一条命令，包括参数。常见应用：当你因为权限不足执行命令失败时，可以使用 sudo !!再尝试一次。
$_ - 上一条命令的最后一个参数。如果你正在使用的是交互式 shell，你可以通过按下 Esc 之后键入 . 来获取这个值。



另一个常见的模式是以变量的形式获取一个命令的输出，这可以通过 *命令替换*（*command substitution*）实现。

当您通过 `$( CMD )` 这样的方式来执行`CMD` 这个命令时，它的输出结果会替换掉 `$( CMD )` 。

例如，如果执行 `for file in $(ls)` ，shell首先将调用`ls` ，然后遍历得到的这些返回值。

还有一个冷门的类似特性是 *进程替换*（*process substitution*）， `<( CMD )` 会执行 `CMD` 并将结果输出到一个临时文件中，并将 `<( CMD )` 替换成临时文件名。这在我们希望返回值通过文件而不是STDIN传递时很有用。例如， `diff <(ls foo) <(ls bar)` 会显示文件夹 `foo` 和 `bar` 中文件的区别。





花括号`{}` - 当你有一系列的指令，其中包含一段公共子串时，可以用花括号来自动展开这些命令。这在批量移动或转换文件时非常方便。

```
convert image.{png,jpg}
# 会展开为
convert image.png image.jpg

cp /path/to/project/{foo,bar,baz}.sh /newpath
# 会展开为
cp /path/to/project/foo.sh /path/to/project/bar.sh /path/to/project/baz.sh /newpath

# 也可以结合通配使用
mv *{.py,.sh} folder
# 会移动所有 *.py 和 *.sh 文件

mkdir foo bar
# 下面命令会创建foo/a, foo/b, ... foo/h, bar/a, bar/b, ... bar/h这些文件
touch {foo,bar}/{a..h}
touch foo/x bar/y
```



## 查找文件

`find`命令会递归地搜索符合条件的文件，例如：

```
# 查找所有名称为src的文件夹
find . -name src -type d
# 查找所有文件夹路径中包含test的python文件
find . -path '*/test/*.py' -type f
# 查找前一天修改的所有文件
find . -mtime -1
# 查找所有大小在500k至10M的tar.gz文件
find . -size +500k -size -10M -name '*.tar.gz'
```

除了列出所寻找的文件之外，find 还能对所有查找到的文件进行操作。这能极大地简化一些单调的任务。

```
# 删除全部扩展名为.tmp 的文件
find . -name '*.tmp' -exec rm {} \;
# 查找全部的 PNG 文件并将其转换为 JPG
find . -name '*.png' -exec convert {} {}.jpg \;
```



## 查找代码

ripgrep (`rg`) 

`-C` ：获取查找结果的上下文（Context）；举例来说， `grep -C 5` 会输出匹配结果前后五行。

`-v` 将对结果进行反选（Invert），也就是输出不匹配的结果。

`-w`有word之意，表示搜索的字符串作为一个独立的单词时才会被匹配到。

使用`-i`选项，即可在搜索时不区分大小写

`--max-depth <NUM>`  限制文件夹递归搜索深度。



例子如下：

```
# 查找所有使用了 requests 库的文件
rg -t py 'import requests'

# 查找所有没有写 shebang 的文件（包含隐藏文件）
rg -u --files-without-match "^#!"

# 查找所有的foo字符串，并打印其之后的5行
rg foo -A 5

# 打印匹配的统计信息（匹配的行和文件的数量）
rg --stats PATTERN
```

