#!/usr/bin/env bash
## Author:SuperManito
## Modified:2021-3-2

## 定义下载的脚本代理链接
Proxy_URL=https://ghproxy.com/
ShellDir=/opt/jd
##############################  作  者  昵  称  （必填）  ##############################
# 使用空格隔开
author_list="qq34347476 moposmall yangtingxiao luyiwind"

## 添加更多作者昵称（必填）示例：author_list="i-chenzhe whyour testuser"  直接追加，不要新定义变量

##############################  作  者  脚  本  地  址  URL  （必填）  ##############################
# 例如：https://raw.githubusercontent.com/whyour/hundun/master/quanx/jx_nc.js
# 1.从作者库中随意挑选一个脚本地址，每个作者的地址添加一个即可，无须重复添加
# 2.将地址最后的 “脚本名称+后缀” 剪切到下一个变量里（my_scripts_list_xxx）
scripts_base_url_1=https://gitee.com/qq34347476/quantumult-x/raw/master/ 
scripts_base_url_2=https://raw.githubusercontent.com/moposmall/Script/main/Me/ 
scripts_base_url_3=https://raw.githubusercontent.com/yangtingxiao/QuantumultX/master/scripts/jd/
scripts_base_url_4=https://raw.githubusercontent.com/luyiwind/JD_config/js/
## 添加更多脚本地址URL示例：scripts_base_url_3=https://raw.githubusercontent.com/SuperManito/JD-FreeFuck/master/

##############################  作  者  脚  本  名  称  （必填）  ##############################
# 将相应作者的脚本填写到以下变量中
my_scripts_list_1="format_share_jd_code.js whyour_jx_cfdtx.js"
my_scripts_list_2="jx_cfd_exchange.js"
my_scripts_list_3="jd_baiTiao.js"
my_scripts_list_3="jd_live_redrain.js"

## 活动脚本名称1：百变大咖秀、母婴跳一跳、摇一摇、摇京豆
## 活动脚本名称2：东东爱消除、个护爱消除

## 添加更多脚本名称示例：my_scripts_list_3="jd_test1.js jd_test2.js jd_test3.js ......"

##############################  随  机  函  数  ##########################################
rand() {
  min=$1
  max=$(($2 - $min + 1))
  num=$(cat /proc/sys/kernel/random/uuid | cksum | awk -F ' ' '{print $1}')
  echo $(($num % $max + $min))
}
cd ${ShellDir}
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
    wget -q --no-check-certificate $Proxy_URL$url -O scripts/$name.new

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
        [ $(grep -c "$croname" ${ShellDir}/config/crontab.list) -eq 0 ] && sed -i "/hangup/a${cron_min} ${cron_hour} * * * bash ${ShellDir}/jd.sh $croname" ${ShellDir}/config/crontab.list
      else
        [ $(grep -c "$croname" ${ShellDir}/config/crontab.list) -eq 0 ] && sed -i "/hangup/a${script_date} bash ${ShellDir}/jd.sh $croname" ${ShellDir}/config/crontab.list
      fi
    else
      [ -f scripts/$name.new ] && rm -f scripts/$name.new
      echo -e "更新 $name 失败，使用上一次正常的版本...\n"
    fi
  done
  index=$(($index + 1))
done

##########################  删  除  旧  的  失  效  活  动  ##########################
## 删除旧版本失效的活动示例： rm -rf ${ScriptsDir}/jd_test.js >/dev/null 2>&1


##############################  修  正  定  时  任  务  ##########################################
## 注意两边修改内容区别在于中间内容"jd"、"${ShellDir}/jd.sh"
## 修正定时任务示例：sed -i "s|bash jd jd_test|bash ${ShellDir}/jd.sh test|g" config/crontab.list
##                 sed -i "s|bash jd jd_ceshi|bash ${ShellDir}/jd.sh ceshi|g" config/crontab.list

echo -e "\033[37mdiy脚本更新完成... \033[0m"
echo -e ''
