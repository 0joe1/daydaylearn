

time.time() 1970纪元后经过的浮点秒数
```
time.time(): 1234892919.655932
```


```python
import numpy as np

rd = np.random.RandomState(888) #输入种子(0~2**32-1)，形成伪随机数容器
matrix = rd.randint(-2, 3, (10, 10)) # 随机生成[-2,3)的整数，20x20的矩阵

```


产生范围内的整型
```python
random.randrange(start, stop[, step])
#Return a randomly selected element from range(start, stop, step).


random.randint(a, b)
#Return a random integer N such that a <= N <= b. Alias for randrange(a, b+1).
```


bytes 与 str

```python
# bytes object
b = b"example"

# str object
s = "example"
```

bytes 与 int

```python
classmethod int.from_bytes(bytes, byteorder='big', *, signed=False)
#Return the integer represented by the given array of bytes.

int.to_bytes(length=1, byteorder='big', *, signed=False)
#Return an array of bytes representing an integer.
```
If byteorder is "big", the most significant byte is at the beginning of the byte array. If byteorder is "little", the most significant byte is at the end of the byte array.



#### 生成随机置换表
numpy.random.Generator.permutation
method

random.Generator.permutation(x, axis=0)
Randomly permute a sequence, or return a permuted range.

Parameters
:
x
int or array_like
If x is an integer, randomly permute np.arange(x). If x is an array, make a copy and shuffle the elements randomly.

axis
int, optional
The axis which x is shuffled along. Default is 0.

Returns
:
out
ndarray
Permuted sequence or array range.






求行列式
linalg.det(a)

Parameters
:
a
(…, M, M) array_like
Input array to compute determinants for.

Returns
:
det
(…) array_like
Determinant of a.

```python
The determinant of a 2-D array [[a, b], [c, d]] is ad - bc:

a = np.array([[1, 2], [3, 4]])
np.linalg.det(a)
-2.0 # may vary
Computing determinants for a stack of matrices:

a = np.array([ [[1, 2], [3, 4]], [[1, 2], [2, 1]], [[1, 3], [3, 1]] ])
a.shape
(3, 2, 2)
np.linalg.det(a)
array([-2., -3., -8.])
```


### 删除np矩阵某一行/列
numpy.delete(arr, obj, axis=None)
Return a new array with sub-arrays along an axis deleted. For a one dimensional array, this returns those entries not returned by arr[obj].

Parameters:
arrarray_like
Input array.

objslice, int or array of ints
Indicate indices of sub-arrays to remove along the specified axis.

axisint, optional
The axis along which to delete the subarray defined by obj. If axis is None, obj is applied to the flattened array.

Returns:
out
ndarray
A copy of arr with the elements specified by obj removed. Note that delete does not occur in-place. If axis is None, out is a flattened array.


### string的填充方法
The ljust() method will left align the string, using a specified character (space is default) as the fill character.

Syntax
string.ljust(length, character)
Parameter Values
Parameter	Description
length	Required. The length of the returned string
character	Optional. A character to fill the missing space (to the right of the string). Default is " " (space).



