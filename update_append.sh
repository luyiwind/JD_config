#!/usr/bin/env bash

wget -q https://raw.githubusercontent.com/SuperManito/JD-FreeFuck/source/git_pull.sh -O /opt/jd/git_pull.sh
if [ $? -eq 0 ];then
  echo -e "\033[37mManual-update脚本同步成功... \033[0m"
  echo -e ''
else
  echo -e "\033[37mManual-update脚本同步失败... \033[0m"
  echo -e ''
  exit 1
fi

wget -q https://raw.githubusercontent.com/luyiwind/JD_config/main/append.sh -O /opt/jd/append.sh
if [ $? -eq 0 ];then
  echo -e "\033[37m追加脚本同步成功... \033[0m"
  echo -e ''
  cat /opt/jd/append.sh >> /opt/jd/manual-update.sh
  echo -e "\033[37mManual-update脚本追加成功... \033[0m"
  echo -e ''
else
  echo -e "\033[37m追加脚本同步失败... \033[0m"
  echo -e ''
  exit 1
fi

wget -q https://raw.githubusercontent.com/SuperManito/JD-FreeFuck/source/git_pull.sh -O /opt/jd/git_pull.sh
