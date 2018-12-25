#!/bin/bash 
ip=$1
version_name=$2
git_source=$3
root_path=$4
ssh_role=$5
is_composer=$6
group_name=$7
project_name=$8
from=$9
env=`cat /data_judian/shell/config/env.conf`
not_dev=""
if [ "$env" = "pro" ];then
not_dev="--no-dev"
fi
project=$1
filepath=$(cd "$(dirname "$0")"; pwd)
#if [ "$project" = "market_thrift" ]
#then
#  root_path='/data33/thrift_impl/market-service-impl/'
#  git_source="git@gitlab.33.cn:_site-service/market-service-impl.git"
#  log_file_name="market_thrift_version"
#elif [ "$project" = "otc_thrift" ]
#then
#  root_path='/data33/thrift_impl/otc-service-impl/'
#  git_source="git@gitlab.33.cn:_site-service/otc-service-impl.git"
#  log_file_name="otc_thrift_version"
#elif [ "$project" = "zhaobi_api" ]
#then
#  root_path='/data33/user_site/zhaobi/'
#  git_source="git@gitlab.33.cn:user_site/zhaobi.git"
#  log_file_name="zhaobi_api_version"
#elif [ "$project" = "devops" ]
#then
#  root_path='/data33/inner_site/devops/'
#  git_source="git@gitlab.33.cn:inner_site/devops.git"
#  log_file_name="devops_version"
#elif [ "$project" = "risk_thrift" ]
#then
#  root_path='/data33/thrift_impl/risk-service-impl/'
#  git_source="git@gitlab.33.cn:riskapi/RiskAPIServer.git"
#  log_file_name="risk_thrift_version"
#elif [ "$project" = "otc_cms_api" ]
#then
#  root_path='/data33/inner_site/cms_otc_api/'
#  git_source="git@gitlab.33.cn:inner_site/cms_otc_api.git"
#  log_file_name="cms_otc_api_version"
#else
#  echo -e "project name error"
#  exit
#fi
log_file_name="${group_name}_${project_name}"
version_log="$filepath/log/$log_file_name.log"
lockfile="$filepath/log/$log_file_name.lock"
pidfile="$filepath/log/$log_file_name.pid"
if [ ! -d "$filepath/log" ];then
  mkdir -p "$filepath/log"
fi
if [ ! -f $version_log ];then
    # 不存在锁文件，则直接产生锁
    touch $version_log
fi

# if [ ! -f $lockfile ];then
#   # 不存在锁文件，则直接产生锁
#   touch $lockfile
#   echo $$ > $lockfile
# fi
# exec 9>$lockfile
# flock -n -e 9 #设置锁失败时,返回1;设置锁成功时,返回0
# if [ $? -eq 1 ];then
#   echo -e 'Tere is another script running '
#   lock_pid=`cat $pidfile  2>&1`
#   echo -e " pid is $lock_pid"
#   exit
# fi
# echo $$ > $lockfile
# echo $$ > $pidfile
# version_name 为版本号
if [ "$from" = "" ];then
from="cli"
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
# version_name=`date +%Y%m%d-%H%M%S 2>&1`
# for ip in ${ip_arr[@]}
# do
echo -e "*************************************服务器IP: $ip****************************************$enter"
remote_ret=`ssh $ssh_role@$ip '
echo -e "'$green_start'登陆服务器成功'$color_end''$enter'"
version_name='$version_name'
if [ ! -d "'$root_path'" ];then
  mkdir -p "'$root_path'"
fi
cd '$root_path'
echo $version_name >> '$version_log'
git_clone=\`git clone -b master '$git_source' ./$version_name 2>&1 \`
echo -e "----------------------------------------git clone输出----------------------------------------'$enter'"
echo -e "$git_clone'$enter'"
flag=\`echo $git_clone | awk "/'$exception_str'/"\`
if [ "$flag" = "" ];then
  echo -e "'$green_start'git clone成功'$color_end''$enter'"  
else
  echo -e "'$red_start'git clone失败'$color_end''$enter'"
  exit
fi
cd $version_name
mkdir -p ./application/runtime/cache
chmod 777 ./application/runtime
composer_ret=\`composer install '$not_dev' 2>&1 \`
echo -e "----------------------------------------composer install输出----------------------------------------'$enter'"
echo -e "$composer_ret'$enter'"
flag=\`echo -e $composer_ret | awk "/'$exception_str'/"\`
if [ "$flag" = "" ];then
  echo -e "'$green_start'composer install成功'$color_end''$enter'"  
else
  echo -e "'$red_start'composer install失败'$color_end''$enter'"
  exit
fi'`
echo -e "$remote_ret"
# done