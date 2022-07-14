#!/bin/bash
set -euo pipefail

# tmux 会话名字
sessionName=mc
# 服务器关闭警告信息
stopDelay=10
stopWarn=服务器将在${stopDelay}秒后关闭进行备份

# 存档位置
saveDir=world_1.16.5_survival*/
# 服务器启动脚本
startScript=1.18.2_survival.sh
# 备份位置
backupPath=bak
# 存档保留天数
backupDays=3

# 警告并关闭服务器
tmux send-keys -t ${sessionName} say Space ${stopWarn} Enter
sleep ${stopDelay}
tmux send-keys -t ${sessionName} stop Enter
echo 服务器关闭ing...
# 等待服务器关闭
sleep 30

# 开始备份
echo 开始备份...
if [ -z "${backupPath}" ]; then
    tar -czf auto-backup-`date +%Y-%m-%d-%H-%M-%S`.tar.gz ${saveDir}
else
    mkdir -p ${backupPath}
    tar -czf ${backupPath}/auto-backup-`date +%Y-%m-%d-%H-%M-%S`.tar.gz ${saveDir}
fi
echo 备份完毕

# 删除旧存档
find ${backupPath} -mtime +${backupDays} -name "auto-backup-*.tar.gz" -exec rm {} \;

# 重启服务器
tmux send-keys -t ${sessionName} bash Space ${startScript} Enter
