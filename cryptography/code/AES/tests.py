
def test_conversion(text):
    # 将整数转换为矩阵
    matrix = text2matrix(text)
    # 将矩阵转换回整数
    result = matrix2text(matrix)
    # 检查转换后的整数是否与原始整数相等
    if result == text:
        print("转换成功！")
    else:
        print("转换失败！")

# 测试代码
text = 0x112233445566778899aabbccddeeff00
test_conversion(text)



