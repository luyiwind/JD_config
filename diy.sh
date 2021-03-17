#!/usr/bin/env bash
## Author:Louis
## Modified:2021-3-8

## 定义URL&File
URL1=https://gitee.com/SuperManito/JD-FreeFuck/raw/main/diy/diy.sh
URL2=https://raw.githubusercontent.com/luyiwind/JD_config/main/scripts.sh

FileDiy1=/opt/jd/config/diy1.sh
FileDiy2=/opt/jd/config/diy2.sh

## 自定义脚本功能
function ExecShell() {
  ## 自动同步用户自定义的diy.sh
  if [[ ${EnableExtraShellUpdate} == true ]]; then
    wget -q $1 -O $2
    if [ $? -eq 0 ]; then
      echo -e "自定义 $1 脚本同步完成......"
      echo -e ''
      sleep 2s
    else
      echo -e "自定义 $1 脚本同步失败......"
      echo -e ''
      sleep 2s
    fi
  fi

  ## 调用用户自定义的diy.sh
  if [[ ${EnableExtraShell} == true ]]; then
    if [ -f $2 ]; then
      . $2
    else
      echo -e "$2 文件不存在，跳过执行自定义 DIY 脚本...\n"
      echo -e ''
    fi
  fi
}

ExecShell ${URL1} ${FileDiy1}
ExecShell ${URL2} ${FileDiy2}
