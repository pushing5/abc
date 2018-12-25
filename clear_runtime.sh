#!/bin/bash 
ip=$1
group_name=$2
project_name=$3
env_list=$4
ssh_role=$5
from=$6
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
ga_project_pattern="ga"
ga_flag=\`echo '$env_list' | awk /$ga_project_pattern/\`
if [ "$ga_flag" != "" ];then
    clear_runtime_ret1=\`rm -rf /data/runtime/'$group_name'/'$project_name'/runtime/temp 2>&1 \`
    clear_runtime_ret2=\`rm -rf /data/runtime/'$group_name'/'$project_name'/runtime/cache 2>&1 \`
    echo -e "----------------------------------------clear ga runtime temp cache----------------------------------------'$enter'"
    echo -e "$clear_runtime_ret1 $clear_runtime_ret2 '$enter'"
fi
beta_project_pattern="beta"
beta_flag=\`echo '$env_list' | awk /$beta_project_pattern/\`
if [  -d "/data/beta_runtime/" ];then
    if [ "$ beta_flag" != "" ];then
        clear_runtime_ret1=\`rm -rf /data/beta_runtime/'$group_name'/'$project_name'/runtime/temp 2>&1 \`
        clear_runtime_ret2=\`rm -rf /data/beta_runtime/'$group_name'/'$project_name'/runtime/cache 2>&1 \`
        echo -e "----------------------------------------clear beta runtime temp cache----------------------------------------'$enter'"
        echo -e "$clear_runtime_ret1 $clear_runtime_ret2 '$enter'"
    fi
fi
'`
echo "$remote_ret"
#done
