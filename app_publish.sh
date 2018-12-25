#!/bin/bash
ip=$1
ssh_role=$2
version_file=$3
version_name=$4
group_name=$5
project_name=$6
from=$7
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
project_pattern="^.*(ga|beta)$"
flag=`echo $version_file | awk /$project_pattern/`
if [ "$flag" = "" ];then
  echo -e "$red_start 第一个参数必须为beta或ga结尾 $color_end$enter"
  exit
fi
version_pattern="^[0-9-]+$"
flag=`echo $version_name | awk /$version_pattern/`
if [ "$flag" = "" ];then
  echo -e "$red_start 第二个参数必须为数字与横线-的组合 $color_end$enter"
  exit
fi
if [ "$from" != "" -a "$from" != "web" ]
then
  echo -e "$red_start 第三个参数必须为web或空 $color_end$enter"
  exit
fi
#for ip in ${ip_arr[@]}
#do
echo -e "*************************************服务器IP: $ip****************************************$enter"
remote_ret=`ssh $ssh_role@$ip '
echo -e "'$green_start'登陆服务器成功'$color_end''$enter'"
if [ ! -e "'$version_file'" ]
then 
  echo -e "配置文件不存在,创建中'$enter'"
  touch '$version_file'
fi
echo "'$version_name'" > '$version_file'
checkversion=\`cat '$version_file'\`
if [ "$checkversion" != "'$version_name'" ];then
  echo -e "'$red_start'版本更新失败'$color_end$enter'"
  exit
else
  echo -e "'$green_start'版本更新成功'$enter'"
  echo -e "版本号为： $checkversion'$enter'"
  echo -e "上线配置： '$version_file''$color_end$enter'"
fi
ga_project_pattern="^.*(ga)$"
ga_flag=\`echo '$version_file' | awk /$ga_project_pattern/\`
if [ "$ga_flag" != "" ];then
    clear_runtime_ret1=\`rm -rf /data/runtime/'$group_name'/'$project_name'/runtime/temp 2>&1 \`
    clear_runtime_ret2=\`rm -rf /data/runtime/'$group_name'/'$project_name'/runtime/cache 2>&1 \`
    echo -e "----------------------------------------clear ga runtime temp cache----------------------------------------'$enter'"
    echo -e "$clear_runtime_ret1 $clear_runtime_ret2 '$enter'"
fi

beta_project_pattern="^.*(beta)$"
beta_flag=\`echo '$version_file' | awk /$beta_project_pattern/\`
if [ "$beta_flag" != "" ];then
    if [  -d "/data/beta_runtime/" ];then
        clear_runtime_ret1=\`rm -rf /data/beta_runtime/'$group_name'/'$project_name'/runtime/temp 2>&1 \`
        clear_runtime_ret2=\`rm -rf /data/beta_runtime/'$group_name'/'$project_name'/runtime/cache 2>&1 \`
        echo -e "----------------------------------------clear beta runtime temp cache----------------------------------------'$enter'"
        echo -e "$clear_runtime_ret1 $clear_runtime_ret2 '$enter'"
    fi
fi
'`
echo -e "$remote_ret"
#done