DiyUpdate

wget -q https://raw.githubusercontent.com/luyiwind/JD_config/main/diy.sh -O $BASE/config/myself.sh
if [ $? -eq 0 ];then
  echo -e "\033[37mdiy脚本同步成功... \033[0m"
  echo -e ''
else
  echo -e "\033[37mdiy脚本同步失败... \033[0m"
  echo -e ''
fi
echo -e "\033[37m执行myself脚本... \033[0m"
echo -e ''
bash $BASE/config/myself.sh
