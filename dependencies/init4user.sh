#!/bin/bash

# 获取用户信息
NEW_USER=$1
NEW_ID=$2

# 设置~T~H stu
addgroup --gid $NEW_ID $NEW_USER \
        && useradd -g $NEW_USER --uid $NEW_ID --create-home --no-log-init --shell /bin/bash "$NEW_USER" \
        && usermod -aG sudo $NEW_USER \
        && echo $NEW_USER':000000' | sudo chpasswd

NEW_USERHOME=$(grep $NEW_USER /etc/passwd | cut -d: -f6)
echo $NEW_USERHOME

# ~[~M conda ~P~R~L pip ~P
cp /tmp/dependencies/.condarc $NEW_USERHOME
cp /tmp/dependencies/.bashrc $NEW_USERHOME
cp /tmp/dependencies/.profile $NEW_USERHOME
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# ~P~J vnc 以~O~J ssh
cp -r /tmp/dependencies/.vnc $NEW_USERHOME
cp -r /tmp/dependencies/.config $NEW_USERHOME

cp /tmp/dependencies/motd /etc/motd
chmod +x $NEW_USERHOME/.vnc/xstartup

# 设置~T~H~V~G件夹~]~C~Y~P
chown -R $NEW_USER:$NEW_ID $NEW_USERHOME

# 移动 apt 文件
cp -r /tmp/dependencies/apt /etc/

# 删除缓存
rm -rf /tmp/dependencies

# 尝试开启 ssh 服务
service ssh start

pkill xfce4-power-manager
pkill xfce4-screensaver

xfce4-power-manager
xfce4-screensaver

runuser -l $NEW_USER -c "/opt/anaconda/bin/conda init"
runuser -l $NEW_USER -c "vncserver :2 --localhost no"
