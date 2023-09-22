TensorFlow中的Session是用来运行图(graph)的执行会话。它具有以下的作用和用法:

作用:

运行图中的操作(Op),计算得到tensor的输出结果。

图(graph)表示的是一系列操作(Operations)之间的连接关系和数据流转。它定义了运算的流程和数据传递方式,但并不实际执行运算。

TensorFlow使用图(graph)定义运算,这些运算需要在会话内部运行才能真正执行。

允许同时打开多个会话,在不同上下文运行相同的图。



使用方法:

- 创建Session对象,关联要运行的图
- 在Session内使用run方法执行操作(Op)
- 传入feed_dict为 placeholder 提供输入值
- 关闭Session以释放资源

总结一下,Session是TensorFlow的执行会话,通过run方法触发图的执行,起到了连接图定义和运行的桥梁作用。



placeholder

```
tf.placeholder(dtype, shape=None, name=None)  //return type: tensor
```

此函数可以理解为形参，用于定义过程，在执行的时候再赋具体的值

参数：

dtype：返回的张量(tensor)的数据类型。常用的是tf.float32,tf.float64等数值类型
shape：返回的张量(tensor)的数据形状。默认是None，就是一维值，也可以是多维，比如[None, 3]表示列是3，行不定
name：返回的张量(tensor)的名称。



在 TensorFlow 中，张量和操作都是节点。当您调用 `sess.run()` 方法时，提供 `vgg.prob` 作为要执行的节点，TensorFlow 会计算并返回该张量的值。

例如，`sess.run(vgg.prob, feed_dict={input: image})` 的作用是计算 `vgg.prob` 张量的值，并使用 `feed_dict` 提供输入数据 `image`，以满足计算图中与 `vgg.prob` 相关的依赖关系。

TensorFlow 会运行与 `vgg.prob` 相关的所有节点。

具体而言，它将会执行以下操作：

首先，根据 `vgg.prob` 的定义，检查它所依赖的所有操作和张量。

接下来，根据这些节点之间的依赖关系，按照正确的顺序计算它们的值。这意味着它会从输入节点 `image` 开始计算，然后依次计算每个节点的值，直到达到 `vgg.prob` 这个节点。



