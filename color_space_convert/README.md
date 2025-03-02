# 常用色彩空间转换模块

#RGB888_2_YUV444

include all kinds of yuv type ,such as yuv422 yuv420.......

只需在外围添加一个数据的下采样即可；

整体思路为一个单bit flag信号，用于进行数据采样；

一些计数器用于控制采样周期；

后续有时间会对采样模块进行补充。


#RGB888_2_RGB565

截取位宽，非常简单;


#RGB565_2_RGB888

扩展位宽，非常简单;

#bayer RAW10 to RGB565 （reserved）

bayer格式数据解码，后续一定会补充该代码，预计在25/4/1之前

# author

Email: cosydeal@163.com

Wechat: cosydeal