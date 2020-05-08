# unitySpeedTools2020

unitySpeedTools2020是unitySpeedTools的无验证版本。

English version is in wiki page


# 功能

主要提供越狱环境下对Unity游戏的速度控制，一个简陋的界面可在游戏中进行调速，或者在系统设置菜单中调整好速度，在游戏用一个按钮来快捷加速/减速、恢复原速。

# 原理

1、在插件启动时，或者触屏被点按时，查找Unity的System函数（根据二进制特征）

2、使用System函数查找UnityEngine.Time::set_timeScale(System.Single)的地址，进行劫持

## 特征值

根据多个Unity游戏的二进制进行整理，找出最通用的特征值。该值可能不止一组，补充更多特征值将可使变速器适用于更多的Unity游戏


## 适配性

非Unity游戏的、不使用Unity引擎此2函数进行变速的、有根据速度进行非正常游戏判定的，将无法使用此插件。有些变速还将导致外挂判定，而被封号。

