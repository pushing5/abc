#!/bin/bash 
ip=$1
ssh_role=$2
from=$3
green_start="\033[32m"
red_start="\033[31m"
color_end="\033[0m"
enter="\n"
if [ "$from" = "web" ];then
  green_start="<span style='color:#32dd32;'>"
  red_start="<span style='color:#fc5757;'>"
  color_end="</span>"
  enter="<br/>"
fi
echo -e "starting....$enter"
exception_str="fatal|Cannot|error|RuntimeException|PHP Warning|Problem|could not|is not|do not|Fail"
#for ip in ${ip_arr[@]}
#do
echo -e "*************************************服务器IP: $ip****************************************$enter"
remote_ret=`ssh $ssh_role@$ip '
echo -e "'$green_start'登陆服务器成功'$color_end''$enter'"
config_path="/data_judian/index_console/"
if [  -d $config_path ];then
    echo "----------------------------------------git pull --rebase 输出----------------------------------------'$enter'"
    cd $config_path
    echo -e "cd /data_judian/index_console/'$enter'"
    pull_ret=\`git pull --rebase origin master 2>&1\`
    echo -e "$pull_ret'$enter'"
    flag=\`echo $pull_ret | awk "/'$exception_str'/"\`
    if [ "$flag" = "" ];then
      echo -e "'$green_start'git更新成功'$color_end''$enter'"
    else
      echo -e "'$red_start'git更新失败,请仔细查看输出信息'$color_end''$enter'"
      exit
    fi
fi
'`
echo "$remote_ret"
#done
