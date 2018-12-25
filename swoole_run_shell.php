#!/usr/bin/env php
<?php
$ip_list_string = $argv[2];
$ip_list = explode(',', $ip_list_string);
foreach ($ip_list as $ip) {
    $argv[2] = $ip;
    $argv2 = array_slice($argv, 1);
    go(function () use (&$data_list, $argv2) {
        $shell_params = implode(' ', $argv2);
        $ret = Swoole\Coroutine::exec($shell_params . " 2>&1");
        if (0 === $ret['code']) {
            $data_list[] = ['message' => $ret['output'], 'code' => 0];
        } else {
            $data_list[] = ['message' => 'exec 失败', 'code' => -1];
        }
    });
}
swoole_event::wait();
foreach ($data_list as $item) {
    if (0 === $item['code']) {
        echo $item['message'];
    } else {
        echo '<p style="color:red;">********************************' . $item['message'] . '********************************</p>';
    }
}