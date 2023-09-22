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

