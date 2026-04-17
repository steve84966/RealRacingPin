# RealRacingPin

English | [中文](README_CN.md)

An app for RealRacing3 verifying the network server timestamp. Based on [ProxyPin](https://github.com/wanghongenpin/proxypin)v1.2.7。

You can use it to intercept, inspect & rewrite HTTP(S) traffic.

---

## Features

- After starting capture, it'll automatically respond to the server network verification from Real Racing 3.

- Timestamp offset. This is for ROUND HUB. 

## examples

- Daily Sign-in v7.6.0 

![image](example_images/0760.jpg)

- Daily Sign-in v14.0.1 

![image](example_images/1401.jpg)

- Timestamp offset. (the real time is 2026-04-17T19:24:35.013). You can read the timestamp response to game from "ISO-8601-Time".

![image](example_images/timeoffset.jpg)


## Download

Now it's in alpha testing. If all good, I'll put it in Github Release page. (A few weeks later.)

You can get a BauduNetdisk link in the Guide. (it's temporary)

## How to use

[Guide (ZH_CN)](https://ycna0fgq1dzb.feishu.cn/wiki/ZQxVwLU70ink4vkwU8hcRFk8nEc)

## Thanks

- Project [ProxyPin](https://github.com/wanghongenpin/proxypin), and those who contribute it.

- All those who are dedicated to researching and reviving this game on the [Baidu Tieba](https://tieba.baidu.com/f?kw=%E7%9C%9F%E5%AE%9E%E8%B5%9B%E8%BD%A63&ie=utf-8).

## Todo

- Change logic to enable capture in **Airplane mode**.