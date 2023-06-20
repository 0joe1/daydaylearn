As a subdirectory: 作为子目录：
In this case you have a subdirectory containing the whole repository of Backward (eg.: using git-submodules), in this case you can do:
在这种情况下，您有一个包含 Backward 的整个存储库的子目录（例如：使用 git 子模块），在这种情况下，您可以执行以下操作：

在CMakeList.txt中添加：

```
add_subdirectory(/path/to/backward-cpp)

# This will add backward.cpp to your target

add_executable(mytarget mysource.cpp ${BACKWARD_ENABLE})

# This will add libraries, definitions and include directories needed by backward

# by setting each property on the target.

add_backward(mytarget)
```



