#!/bin/bash

# 设置 conda
conda clean -all -y

# 开启 vncserver
# nohup vncserver :2 -localhost no &

# 保持会话
tail -f /dev/null
