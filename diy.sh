#!/usr/bin/env bash
## Author:SuperManito
## Modified:2021-2-26

## 项目安装目录
BASE="/opt/jd"

## 如果您还想添加第三方脚本，需要填写此脚本以下几处地方：
## 1. 作者昵称
## 2. 作者脚本地址URL
## 3. 作者脚本名称
## 4. 修正定时任务

##############################作者昵称（必填）############################## 
# 使用空格隔开 
author_list="qq34347476 i-chenzhe moposmall" 
##############################作者脚本地址URL（必填）############################## 
# 例如：https://raw.githubusercontent.com/whyour/hundun/master/quanx/jx_nc.js 
# 1.从作者库中随意挑选一个脚本地址，每个作者的地址添加一个即可，无须重复添加 
# 2.将地址最后的 “脚本名称+后缀” 剪切到下一个变量里（my_scripts_list_xxx） 
scripts_base_url_1=https://gitee.com/qq34347476/quantumult-x/raw/master/ 
scripts_base_url_2=https://raw.githubusercontent.com/i-chenzhe/qx/main/ 
scripts_base_url_3=https://raw.githubusercontent.com/moposmall/Script/main/Me/ 
##############################作者脚本名称（必填）############################## 
# 将相应作者的脚本填写到以下变量中 
my_scripts_list_1="format_share_jd_code.js whyour_jx_cfdtx.js" 
my_scripts_list_2="jd_asus_iqiyi.js jd_fanslove.js jd_jump-jump.js jd_entertainment.js jd_shake.js" 
my_scripts_list_3="jx_cfd_exchange.js" 

##############################随机函数##########################################
echo -e "\033[37m-------------------------------------------------------------- \033[0m"
echo -e ''
echo -e "\033[37m+-------------- 开 始 更 新 diy 活 动 脚 本... --------------+ \033[0m"
echo -e "\033[37m|                                                            | \033[0m"
echo -e "\033[37m|  如果下载报错，证明您当前网络环境无法连接至 Github 服务器  | \033[0m"
echo -e "\033[37m|                                                            | \033[0m"
echo -e "\033[37m+------------------------------------------------------------+ \033[0m"
echo -e ''

rand() {
  min=$1
  max=$(($2 - $min + 1))
  num=$(cat /proc/sys/kernel/random/uuid | cksum | awk -F ' ' '{print $1}')
  echo $(($num % $max + $min))
}
cd $BASE
index=1
for author in $author_list; do
  echo -e "开始下载 $author 的脚本"
  # 下载my_scripts_list中的每个js文件，重命名增加前缀"作者昵称_"，增加后缀".new"
  eval scripts_list=\$my_scripts_list_${index}
  #echo $scripts_list
  eval url_list=\$scripts_base_url_${index}
  #echo $url_list
  for js in $scripts_list; do
    eval url=$url_list$js
    echo $url
    eval name=$js
    echo $name
    wget -q --no-check-certificate $url -O scripts/$name.new

    # 如果上一步下载没问题，才去掉后缀".new"，如果上一步下载有问题，就保留之前正常下载的版本
    # 随机添加个cron到crontab.list
    if [ $? -eq 0 ]; then
      mv -f scripts/$name.new scripts/$name
      echo -e "更新 $name 完成...\n"
      croname=$(echo "$name" | awk -F\. '{print $1}')
      script_date=$(cat scripts/$name | grep "http" | awk '{if($1~/^[0-59]/) print $1,$2,$3,$4,$5}' | sort | uniq | head -n 1)
      if [ -z "${script_date}" ]; then
        cron_min=$(rand 1 59)
        cron_hour=$(rand 7 9)
        [ $(grep -c "$croname" $BASE/config/crontab.list) -eq 0 ] && sed -i "/hangup/a${cron_min} ${cron_hour} * * * bash $BASE/jd.sh $croname" $BASE/config/crontab.list
      else
        [ $(grep -c "$croname" $BASE/config/crontab.list) -eq 0 ] && sed -i "/hangup/a${script_date} bash $BASE/jd.sh $croname" $BASE/config/crontab.list
      fi
    else
      [ -f scripts/$name.new ] && rm -f scripts/$name.new
      echo -e "更新 $name 失败，使用上一次正常的版本...\n"
    fi
  done
  index=$(($index + 1))
done

##########################  删  除  旧  版  本  失  效  的  活  动  ##########################
## 删除旧版本失效的活动示例： rm -rf $BASE/scripts/jd_test.js >/dev/null 2>&1


##############################修正定时任务##########################################
## 注意两边修改内容区别在于中间内容"jd"、"$BASE/jd.sh"
## 修正定时任务示例：sed -i "s|bash jd jd_test|bash $BASE/jd.sh test|g" config/crontab.list
##                 sed -i "s|bash jd jd_ceshi|bash $BASE/jd.sh ceshi|g" config/crontab.list

#sed -i "s|bash jd jd_asus_iqiyi|bash $BASE/jd.sh jd_asus_iqiyi|g" config/crontab.list
#sed -i "s|bash jd jd_entertainment|bash $BASE/jd.sh jd_entertainment|g" config/crontab.list
#sed -i "s|bash jd jd_jump-jump|bash $BASE/jd.sh jd_jump-jump|g" config/crontab.list


echo -e "\033[37mdiy脚本更新完成... \033[0m"
echo -e ''
