## 执行文件路径的变量：$PATH

PATH(一定是大写)这个变量的内容是由一堆目录所组成的,每个目录中间用冒号(:)来隔开, 每个目录是有“顺序”之分的。

在执行一个命令的时候，系统会依照PATH的设置去每个PATH定义的目录下搜寻这个命令的可执行文件, 如果在PATH定义的目录中含有多个该命令对应文件名的
可执行文件,那么先搜寻到的同名可执行文件先被执行!