# zerotier私有根一键替换脚本

```cmd
# Window或者Linux
## 国外
curl -L -o update_planet.py https://raw.githubusercontent.com/dadastory/zerotier-replace-custom/main/update_planet.py && python update_planet.py https://your.domain/planet.custom
## 国内镜像
curl -L -o update_planet.py https://gitee.com/chen_da/zerotier-replace-custom/raw/main/update_planet.py && python update_planet.py https://your.domain/planet.custom


# Openwrt
# 国外
curl -L -o update_planet.py https://raw.githubusercontent.com/dadastory/zerotier-replace-custom/main/update_planet.py && python update_planet.py https://your.domain/planet.custom --openwrt-path /overlay/zerotier/planet

# 国内镜像
curl -L -o update_planet.py https://gitee.com/chen_da/zerotier-replace-custom/raw/main/update_planet.py && python update_planet.py https://your.domain/planet.custom --openwrt-path /overlay/zerotier/planet
```