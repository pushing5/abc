#!/bin/bash 

# index
mkdir -p /data33/index
cd /data33/index
git clone git@gitlab.33.cn:foge/web_index.git ./

# console
mkdir -p /data33/console
cd /data33/console  
git clone git@gitlab.33.cn:foge/console.git ./

# thrift_impl
mkdir -p /data33/thrift_impl/app_config
echo -e "<?php\n\
\n\
global \$G_CONF_PATH;\n\
// 后面相同文件名相同配置覆盖上面\n\
\$G_CONF_PATH = [\n\
    \$base_path . 'vendor/system/config/',\n\
    __DIR__ . '/app_config/',\n\
];" > /data33/thrift_impl/LoadConfig.php
mkdir -p /data33/thrift_impl/market-service-impl/11211
cd /data33/thrift_impl/market-service-impl/11211
git clone git@gitlab.33.cn:_site-service/market-service-impl.git ./
php /data2/composer.phar install

mkdir -p /data33/thrift_impl/otc-service-impl/11211
cd /data33/thrift_impl/otc-service-impl/11211
git clone git@gitlab.33.cn:_site-service/otc-service-impl.git ./
php /data2/composer.phar  install

# user_site
mkdir -p /data33/user_site/app_config
echo -e "<?php\n\
\n\
global \$G_CONF_PATH;\n\
// 后面相同文件名相同配置覆盖上面\n\
\$G_CONF_PATH = [\n\
    \$base_path . 'vendor/system/config/',\n\
    __DIR__ . '/app_config/',\n\
];" > /data33/user_site/LoadConfig.php
mkdir -p /data33/user_site/zhaobi/11211
cd /data33/user_site/zhaobi/11211
git clone git@gitlab.33.cn:user_site/zhaobi.git ./
# composer install
php /data2/composer.phar  install
# inner_site
mkdir -p /data33/inner_site/app_config
echo -e "<?php\n\
\n\
global \$G_CONF_PATH;\n\
// 后面相同文件名相同配置覆盖上面\n\
\$G_CONF_PATH = [\n\
    \$base_path . 'vendor/system/config/',\n\
    __DIR__ . '/app_config/',\n\
];" > /data33/inner_site/LoadConfig.php
mkdir -p /data33/inner_site/devops/11211
cd /data33/inner_site/devops/11211
git clone git@gitlab.33.cn:inner_site/devops.git ./
# composer install
php /data2/composer.phar  install
mkdir -p /data33/inner_site/cms_otc_api/11211
cd /data33/inner_site/cms_otc_api/11211
git clone git@gitlab.33.cn:inner_site/cms_otc_api.git ./

# shell 
mkdir -p /data33/shell/
cd /data33/shell/
git clone git@gitlab.33.cn:foge/rsync_service_shell.git ./
mkdir config
echo "127.0.0.1" > config/ip_arr.conf
echo "foge" > config/role.conf
# version
mkdir -p /data33/version/
echo 11211 > /data33/version/inner_site_cms_otc_api_version_ga
echo 11211 > /data33/version/inner_site_cms_otc_api_version_beta
echo 11211 > /data33/version/inner_site_devops_version_ga
echo 11211 > /data33/version/inner_site_devops_version_beta

echo 11211 > /data33/version/user_site_zhaobi_version_ga
echo 11211 > /data33/version/user_site_zhaobi_version_beta

echo 11211 > /data33/version/thrift_impl_market_version_ga
echo 11211 > /data33/version/thrift_impl_market_version_beta
echo 11211 > /data33/version/thrift_impl_otc_version_ga
echo 11211 > /data33/version/thrift_impl_otc_version_beta
echo 11211 > /data33/version/thrift_impl_risk_version_ga
echo 11211 > /data33/version/thrift_impl_risk_version_beta
cd /data33/user_site/app_config
echo "cd /data33/user_site/app_config"
git clone git@gitlab.33.cn:foge/dev_user_site_app_config.git ./
echo "cd data33/inner_site/app_config"
cd /data33/inner_site/app_config
git clone git@gitlab.33.cn:foge/dev_inner_app_config.git ./
echo "cd data33/thrift_impl/app_config"
cd /data33/thrift_impl/app_config
git clone git@gitlab.33.cn:foge/dev_thrift_impl_app_config.git ./