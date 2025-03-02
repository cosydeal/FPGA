# 跨时钟域模块

需添加一个额外的异步fifo IP核

![建议参考图](./ip_config.png)

如需保持数据连续性，请考虑应用于快到慢的场景下；

该模块完全无法保证慢到快的数据连续性；

若需要保持连续性可以增加额外的fifo，但目前还未更新读写控制模块。

# author

Email: cosydeal@163.com

Wechat: cosydeal