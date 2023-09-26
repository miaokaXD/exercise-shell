#!/bin/bash
#脚本通过lastb获取失败信息
#提取失败次数大于5次的IP地址
iplist=$(/bin/lastb |awk '{print $3}'|sort|uniq -c|awk '{if ($1>5) print $2}')
#遍历异常IP列表
for ip in ${iplist}
do
  #追加到黑名单
  echo ALL:${ip} >> /etc/hosts.deny
  #重定向到日志文件，清除lastb已经记录的登录失败信息
  echo > /var/log/btmp
done
