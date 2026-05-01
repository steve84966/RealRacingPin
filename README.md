# RealRacingPin

English | [中文](README_CN.md)

An app for RealRacing3 verifying the network server timestamp. Based on [ProxyPin](https://github.com/wanghongenpin/proxypin)v1.2.7。

You can use it to intercept, inspect & rewrite HTTP(S) traffic.

---

## Features

- After starting capture, it'll automatically respond to the server network verification from Real Racing 3.

- Timestamp offset. This is for ROUND HUB and Special events. 

## examples

- Daily Sign-in v7.6.0 

![image](example_images/0760.jpg)

- Daily Sign-in v14.0.1 

![image](example_images/1401.jpg)

- Timestamp offset. You can read the timestamp response to game from "ISO-8601-Time". This is for some special things. Such as:
  - In RR3 14.0.1, set it to a proper time can play all events in the roundhub. (**DO NOT** earlier than 210731, otherwise an extra force download is needed. I set to 210801 with -1734)
  - Buy NASCARs and Supercars in old versions(back to 2019 is enough. I set it to 2016 with -3619. As for the download, I can skip it by replace files. [See here(Baidu Tieba, ZH_CN)](https://tieba.baidu.com/p/10578188276)).
  - Using it with older versions of the game to play special events.
  - If you miss the previous day's sign-in, you can make up for it.

![image](example_images/timeoffset.jpg)


## Download

Look at [Github Release page](https://github.com/steve84966/RealRacingPin/releases). 

## How to use

[Guide with images (ZH_CN)](https://ycna0fgq1dzb.feishu.cn/wiki/ZQxVwLU70ink4vkwU8hcRFk8nEc)

the following simple guide is edited from [reddit](https://www.reddit.com/r/RealRacing3/comments/1syj2c1/comment/oixcxii/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button). thanks [HOS2002sGhost](https://www.reddit.com/user/HOS2002sGhost/) & [Bokun_Zhao](https://www.reddit.com/user/Bokun_Zhao/) for translation and write the guide.

1. Download "RealRacing Pin" from the [Release Page](https://github.com/steve84966/RealRacingPin/releases) and install it.

2. Open the "RealRacing Pin" app and go to "Settings" on the bottom right corner of the screen.

3. Go to "HTTPS Proxy" and toggle on the "Enable HTTPS Proxy" toggle then go to "Install Certificate".

4. Go to **"User Certificate"** and follow the instructions there (if the route described in step 2 isn't the same as on your own device, just go to your device settings and search up "certificate", then choose whatever has "CA certificate" or "Install certificate" or whatever your device manufacturers named it as). The part about Xposed can be ignored completely.

5. Go back to the "Settings" menu in the RealRacing Pin app and toggle on "Enable HTTP2".

6. Go to "Proxy Filter" > "App Whitelist" > press the "+" on the top right of the screen then look for Real Racing 3 and tap on it (also make sure the "Enable" toggle is on)

7. Go to "Settings" > "Memory Cleanup", set to 512M.

8. Set timeoffset if needed(see example.). Otherwise keep it 0.

8. Go to the 3 dots that form a triangle on the bottom left of the app and then press the play button on the bottom right that's right above the settings button.

9. Open up the game.

10. Enjoy the now online functional game!

## Thanks

- Project [ProxyPin](https://github.com/wanghongenpin/proxypin), and those who contribute it.

- All those who are dedicated to researching and reviving this game on the [Baidu Tieba](https://tieba.baidu.com/f?kw=%E7%9C%9F%E5%AE%9E%E8%B5%9B%E8%BD%A63&ie=utf-8).

## Todo

- Change logic to enable capture in **Airplane mode**.