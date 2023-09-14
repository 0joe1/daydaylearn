## 二

ADD_SUBDIRECTORY(source_dir [binary_dir] [EXCLUDE_FROM_ALL])
这个指令用于向当前工程添加存放源文件的子目录,并可以指定中间二进制和目标二进制存放的位置。EXCLUDE_FROM_ALL 参数的含义是将这个目录从编译过程中排除



我们可以通过 SET 指令重新定义 EXECUTABLE_OUTPUT_PATH 和 LIBRARY_OUTPUT_PATH 变量来指定最终的目标二进制的位置(指最终生成的 hello 或者最终的共享库,不包含编译生成的中间文件)

```
SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)
SET(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/lib)
```

`<projectname>_BINARY_DIR` 和 `PROJECT_BINARY_DIR `变量,指的编译发生的当前目录,如果是内部编译,就相当于 `PROJECT_SOURCE_DIR` 也就是工程代码所在目录,如果是外部编译,指的是外部编译所在目录。

一般 autotools 工程,会运行这样的指令:
`./configure –prefix=/usr` 或者`./configure --prefix=/usr/local` 来指定PREFIX
PREFIXCMAKE_INSTALL_PREFIX 变量类似于 configure 脚本的 –prefix,常见的使用方法看
起来是这个样子:
`cmake -DCMAKE_INSTALL_PREFIX=/usr .`



INSTALL 指令包含了各种安装类型,我们需要一个个分开解释:
目标文件的安装:

```
INSTALL(TARGETS targets...
[[ARCHIVE|LIBRARY|RUNTIME]
[DESTINATION <dir>]
[PERMISSIONS permissions...]
[CONFIGURATIONS
[Debug|Release|...]]
[COMPONENT <component>]
[OPTIONAL]
] [...])
```

参数中的 TARGETS 后面跟的就是我们通过 ADD_EXECUTABLE 或者 ADD_LIBRARY 定义的目标文件,可能是可执行二进制、动态库、静态库。
目标类型也就相对应的有三种,ARCHIVE 特指静态库,LIBRARY 特指动态库,RUNTIME特指可执行目标二进制。
DESTINATION 定义了安装的路径,如果你希望使用 CMAKE_INSTALL_PREFIX 来定义安装路径,就不要以/开头,那么安装后的路径就是
${CMAKE_INSTALL_PREFIX}/<DESTINATION 定义的路径>



普通文件的安装:

```
INSTALL(FILES files... DESTINATION <dir>
[PERMISSIONS permissions...]
[CONFIGURATIONS [Debug|Release|...]]
[COMPONENT <component>]
[RENAME <name>] [OPTIONAL])
```


文件名是此指令所在路径下的相对路径。默认不定义权限 PERMISSIONS,安装后的权限为644 权限。



非目标文件的可执行程序安装(比如脚本之类):

```
INSTALL(PROGRAMS files... DESTINATION <dir>
[PERMISSIONS permissions...]
[CONFIGURATIONS [Debug|Release|...]]
[COMPONENT <component>]
[RENAME <name>] [OPTIONAL])
```


跟上面的 FILES 指令使用方法一样,唯一的不同是安装后权限为755 权限



目录的安装:

```
INSTALL(DIRECTORY dirs... DESTINATION <dir>
[FILE_PERMISSIONS permissions...]
[DIRECTORY_PERMISSIONS permissions...]
[USE_SOURCE_PERMISSIONS]
[CONFIGURATIONS [Debug|Release|...]]
[COMPONENT <component>]
[[PATTERN <pattern> | REGEX <regex>]
[EXCLUDE] [PERMISSIONS permissions...]] [...])
```

这里主要介绍其中的 DIRECTORY、PATTERN 以及 PERMISSIONS 参数。DIRECTORY 后面连接的是所在 Source 目录的相对路径,但务必注意:
abc 和 abc/有很大的区别。
如果目录名不以/结尾,那么这个目录将被安装为目标路径下的 abc,如果目录名以/结尾,
代表将这个目录中的内容安装到目标路径,但不包括这个目录本身。
PATTERN 用于使用正则表达式进行过滤,PERMISSIONS 用于指定 PATTERN 过滤后的文件权限。



```
cmake -DCMAKE_INSTALL_PREFIX=/tmp/t2/usr ..
```



## 三

 ```
 ADD_LIBRARY
 ADD_LIBRARY(libname  [SHARED|STATIC|MODULE] [EXCLUDE_FROM_ALL]  source1 source2 ... sourceN)
 ```



```
SET_TARGET_PROPERTIES,其基本语法是:
SET_TARGET_PROPERTIES(target1 target2 ... PROPERTIES prop1 value1 prop2 value2 ...)
```

与他对应的指令是:

```
GET_TARGET_PROPERTY(VAR target property)
```



为了实现动态库版本号,我们仍然需要使用 SET_TARGET_PROPERTIES 指令。
具体使用方法如下:

```
SET_TARGET_PROPERTIES(hello PROPERTIES VERSION 1.2 SOVERSION 1)
```

VERSION 指代动态库版本,SOVERSION 指代 API 版本。T  



## 四

引入头文件搜索路径。

```
INCLUDE_DIRECTORIES,其完整语法为:
INCLUDE_DIRECTORIES([AFTER|BEFORE] [SYSTEM] dir1 dir2 ...)
```

这条指令可以用来向工程添加多个特定的头文件搜索路径,路径之间用空格分割,如果路径中包含了空格,可以使用双引号将它括起来,默认的行为是追加到当前的头文件搜索路径的后面,你可以通过两种方式来进行控制搜索路径添加的方式:

1. CMAKE_INCLUDE_DIRECTORIES_BEFORE,通过 SET 这个 cmake 变量为 on,可以
   将添加的头文件搜索路径放在已有路径的前面。
2. 通过 AFTER 或者 BEFORE 参数,也可以控制是追加还是置前。



为 target 添加共享库

LINK_DIRECTORIES 和 TARGET_LINK_LIBRARIES

```
LINK_DIRECTORIES 的全部语法是:
LINK_DIRECTORIES(directory1 directory2 ...)
```

这个指令非常简单,添加非标准的共享库搜索路径,比如,在工程内部同时存在共享库和可执行二进制,在编译时就需要指定一下这些共享库的路径。



TARGET_LINK_LIBRARIES 的全部语法是:

```
TARGET_LINK_LIBRARIES(target library1
<debug | optimized> library2
...)
```


这个指令可以用来为 target 添加需要链接的共享库



特殊的环境变量 CMAKE_INCLUDE_PATH 和 CMAKE_LIBRARY_PATH

务必注意,这两个是环境变量而不是 cmake 变量。
使用方法是要在 bash 中用 export 或者在 csh 中使用 set 命令设置或者
CMAKE_INCLUDE_PATH=/home/include cmake ..等方式。



前面我们直接使用了绝对路径 INCLUDE_DIRECTORIES(/usr/include/hello)告诉工
程这个头文件目录。
为了将程序更智能一点,我们可以使用 CMAKE_INCLUDE_PATH 来进行,使用 bash 的方法
如下:
export CMAKE_INCLUDE_PATH=/usr/include/hello
然后在头文件中将 INCLUDE_DIRECTORIES(/usr/include/hello)替换为:
FIND_PATH(myHeader hello.h)
IF(myHeader)
INCLUDE_DIRECTORIES(${myHeader})
ENDIF(myHeader)

FIND_PATH 用来在指定路径中搜索文件名,比如:
FIND_PATH(myHeader NAMES hello.h PATHS /usr/include /usr/include/hello)
这里我们没有指定路径,但是,cmake 仍然可以帮我们找到 hello.h 存放的路径,就是因为我们设置了环境变量 CMAKE_INCLUDE_PATH。
如果你不使用 FIND_PATH,CMAKE_INCLUDE_PATH 变量的设置是没有作用的,你不能指望它会直接为编译器命令添加参数-I<CMAKE_INCLUDE_PATH>



## 五 cmake 常用变量和常用环境变量

一,cmake 变量引用的方式:
前面我们已经提到了,使用`${}`进行变量的引用。在 IF 等语句中,是直接使用变量名而不通过`${}`取值

二,cmake 自定义变量的方式:
主要有隐式定义和显式定义两种,前面举了一个隐式定义的例子,就是 PROJECT 指令,他会隐式的定义`<projectname>_BINARY_DIR` `<projectname>_SOURCE_DIR `两个变量。
显式定义的例子我们前面也提到了,使用 SET 指令,就可以构建一个自定义变量了。
比如:
SET(HELLO_SRC main.SOURCE_PATHc),就 PROJECT_BINARY_DIR 可以通过${HELLO_SRC}来引用这个自定义变量了.

三,cmake 常用变量:
1,`CMAKE_BINARY_DIR`
`PROJECT_BINARY_DIR`
`<projectname>_BINARY_DIR`
这三个变量指代的内容是一致的,如果是 in source 编译,指得就是工程顶层目录,如果
是 out-of-source 编译,指的是工程编译发生的目录。PROJECT_BINARY_DIR 跟其他
指令稍有区别,现在,你可以理解为他们是一致的。
2,`CMAKE_SOURCE_DIR`
`PROJECT_SOURCE_DIR`
`<projectname>_SOURCE_DIR`
这三个变量指代的内容是一致的,不论采用何种编译方式,都是工程顶层目录。
也就是在 in source 编译时,他跟 CMAKE_BINARY_DIR 等变量一致。
PROJECT_SOURCE_DIR 跟其他指令稍有区别,现在,你可以理解为他们是一致的。
3,CMAKE_CURRENT_SOURCE_DIR
指的是当前处理的 CMakeLists.txt 所在的路径,比如上面我们提到的 src 子目录。

