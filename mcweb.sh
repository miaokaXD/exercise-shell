#!/bin/bash
#by_miaokaXD_20230131

red='\033[31m'
green='\033[32m'
yellow='\033[33m'
none='\033[0m'

webPAN='mcsm-web'
ip=$(curl -s http://www.net.cn/static/customercare/yourip.asp |grep -P -o "[0-9.]+(?=</h2>)")

menu(){
	clear
	while :; do
		echo "***********************"
		echo "欢迎使用MCSM面板管理脚本（孩子不懂随便写的）" 
		echo "by miaoka @ 2023/01/31"
		echo "***********************"
		echo ""
		echo "1.启动面板"
		echo "2.关闭面板"
		echo "3.查看服务状态"
		echo "4.查看面板地址"
		echo "0.退出脚本"
		echo ""
		read -p "$(echo "请选择菜单：")" choose
		if [ -z $choose ]; then
			exit
		else
			case $choose in
			1)
				startWeb
				break
				;;
			2)
				stopWeb
				break
				;;
			3)
				mcsmStatus
				break
				;;	
			4)
				viewPanip
				break
				;;	
			0)
				exit 0	
				;;
			*)
				error	
				;;
			esac
		fi
	done
}


startWeb(){
	echo "正在启动面板服务"
	sleep 1
	systemctl start mcsm-web
	sleep 1 
	if systemctl is-active mcsm-web &> /dev/null ; then
		echo -e "${green}面板服务启动成功！${none}"
		echo -e "请在浏览器访问服务器的公网IP地址! ${green}${ip}${none} "
		echo "即可管理MC服务器～"
		exit
	else
		echo -e "${red}面板服务启动失败？${none}"
		echo "请检查配置是否正确！！！"
		exit
	fi
}


stopWeb(){
	echo "正在关闭面板服务"
	sleep 1
	systemctl stop mcsm-web
	sleep 1 
	if systemctl is-active mcsm-web &> /dev/null ; then
		echo "${red}面板服务关闭失败？${none}"
		echo "请检查配置是否正确！！！"
		exit
	else
		echo -e "${green}面板服务关闭成功！${none}"
		echo "你现在无法通过网页管理MC服务器～"
		exit
	fi
}

mcsmStatus(){
	echo -e "${yellow}面板服务运行状态：${none}"
	systemctl status mcsm-web | grep "Active"
	echo -e "${yellow}守护服务运行状态：${none}"
	systemctl status mcsm-daemon | grep "Active"
	echo -e "${yellow}输出完毕！${none}"
}

viewPanip(){
	echo -e "${yellow}面板访问地址：${none}${green}http://${ip}:23333${none}"
}

error(){
	echo -e "${yellow}[提示]${none} ${red}输入错误！请重新输入！${none}"
}


menu
