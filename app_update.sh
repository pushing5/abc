#!/usr/bin/env bash
ip=$1
version_name=$2
git_source=$3
root_path=$4
ssh_role=$5
is_composer=$6
group_name=$7
project_name=$8
online_update=$9
from=${10}
env=`cat /data_judian/shell/config/env.conf`
not_dev=""
if [ "$env" = "pro" ];then
not_dev="--no-dev"
fi
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
if [ -z $version_name ]
then
  echo -e "第一个参数格式为jira项目名-项目ID，如: TRADE-11"
  exit
fi
path=$root_path$version_name
# for ip in ${ip_arr[@]}
# do
echo -e "*************************************服务器IP: $ip****************************************$enter"
remote_ret=`ssh -o stricthostkeychecking=no $ssh_role@$ip '
echo -e "'$green_start'登陆服务器成功'$color_end''$enter'"  
if [ -d "'$path'" ]
then 
cd '$path'
real_version="'$version_name'"
if [ '$online_update' = "yes" ];then
    real_version="master"
fi
pull_ret=\`git pull --rebase origin $real_version 2>&1\`
  echo -e "----------------------------------------git pull --rebase 输出----------------------------------------'$enter'"
  echo -e "$pull_ret'$enter'"
  flag=\`echo $pull_ret | awk "/'$exception_str'/"\`
  if [ "$flag" = "" ];then
    echo -e "'$green_start'git更新成功'$color_end''$enter'"  
  else
    echo -e "'$red_start'git更新失败,请仔细查看输出信息'$color_end''$enter'"
    exit
  fi
  if [ '$is_composer' -eq 0 ];then
      echo -e "'$green_start' skip composer 成功'$color_end''$enter'"
      exit
  fi
  composer_ret=\`composer update '$not_dev'  2>&1 \`
  echo -e "----------------------------------------composer update输出----------------------------------------'$enter'"
  echo -e "$composer_ret'$enter'"
  flag=\`echo $composer_ret | awk "/'$exception_str'/"\`
  if [ "$flag" = "" ];then
    echo -e "'$green_start'composer update成功'$color_end''$enter'"  
  else
    echo -e "'$red_start'composer update失败,请仔细查看输出信息'$color_end''$enter'"
    exit
  fi
else
  if [ ! -d "'$root_path'" ]
  then
    mkdir -p '$root_path'
  fi
  cd '$root_path'
  git_clone=\`git clone -b '$version_name' '$git_source' ./'$version_name' 2>&1 \`
  echo -e "----------------------------------------git clone输出----------------------------------------'$enter'"
  echo -e "$git_clone'$enter'"
  flag=\`echo -e $git_clone | awk "/'$exception_str'/"\`
  if [ "$flag" = "" ];then
    echo -e "'$green_start'git clone成功'$color_end''$enter'"  
  else
    echo -e "'$red_start'git clone失败'$color_end''$enter'"
    exit
  fi
  cd '$version_name'
  mkdir -p ./application/runtime/cache
  chmod 777 ./application/runtime
  git_checkout=\`git checkout -b '$version_name' origin/'$version_name' 2>&1 \`
  flag=\`echo -e $git_checkout | awk "/exists/"\`
  if [ "$flag" = "" ];then
    echo -e "'$red_start'git checkout -b 失败'$color_end''$enter'"
    cd ..
    rm -rf '$version_name'
    exit
  else
    echo -e "'$green_start'git checkout -b  成功'$color_end''$enter'"
  fi
  git_checkout=\`git checkout '$version_name' 2>&1 \`
  echo -e ""----------------------------------------git checkout '$version_name'"----------------------------------------'$enter'"
  echo -e "----------------------------------------git checkout输出----------------------------------------'$enter'"
  echo -e "$git_checkout'$enter'"
  flag=\`echo -e $git_checkout | awk "/'$exception_str'/"\`
  if [ "$flag" = "" ];then
    echo -e "'$green_start'git checkout 成功'$color_end''$enter'"  
  else
    echo -e "'$red_start'git checkout 失败'$color_end''$enter'"
    cd ..
    rm -rf '$version_name'
    exit
  fi
  composer_ret=\`composer install '$not_dev' 2>&1 \`
  echo -e "----------------------------------------composer install输出----------------------------------------'$enter'"
  echo -e "$composer_ret'$enter'"
  flag=\`echo -e $composer_ret | awk "/'$exception_str'/"\`
  if [ "$flag" = "" ];then
    echo -e "'$green_start'composer install成功'$color_end''$enter'"  
  else
    echo -e "'$red_start'composer install失败'$color_end''$enter'"
    exit
  fi
fi'`
echo -e "$remote_ret"
# done
