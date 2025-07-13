import os
import platform
import shutil
import subprocess
import sys
import urllib.request


def run_cmd(cmd, sudo=False):
    try:
        if sudo and platform.system() != "Windows":
            cmd = ["sudo"] + cmd
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError:
        print(f"[!] 命令执行失败: {' '.join(cmd)}")


def stop_service():
    print("[*] 正在停止 ZeroTier 服务...")
    if platform.system() == "Windows":
        for name in ["ZeroTierOneService", "ZeroTierOne", "ZeroTier"]:
            try:
                subprocess.run(["net", "stop", name], check=True, capture_output=True, text=True)
                print(f"[+] 服务已停止：{name}")
                return
            except subprocess.CalledProcessError as e:
                if "服务未启动" in e.stdout or "服务名无效" in e.stdout:
                    continue
        print("[!] 无法停止 ZeroTier 服务：可能服务已停止或服务名错误")
    else:
        if os.path.exists("/etc/init.d/zerotier"):
            run_cmd(["/etc/init.d/zerotier", "stop"], sudo=True)
        else:
            run_cmd(["systemctl", "stop", "zerotier-one"], sudo=True)


def start_service():
    print("[*] 正在启动 ZeroTier 服务...")
    if platform.system() == "Windows":
        for name in ["ZeroTierOneService", "ZeroTierOne", "ZeroTier"]:
            try:
                subprocess.run(["net", "start", name], check=True)
                print(f"[+] 服务已启动：{name}")
                return
            except subprocess.CalledProcessError:
                continue
        print("[!] 无法启动 ZeroTier 服务：服务名可能不匹配")
    else:
        if os.path.exists("/etc/init.d/zerotier"):
            run_cmd(["/etc/init.d/zerotier", "start"], sudo=True)
        else:
            run_cmd(["systemctl", "start", "zerotier-one"], sudo=True)


def download_planet(url, target_file):
    print(f"[*] 正在下载 planet 文件：{url}")
    try:
        urllib.request.urlretrieve(url, target_file)
        print(f"[+] 下载完成：{target_file}")
    except Exception as e:
        print(f"[!] 下载失败: {e}")
        sys.exit(1)


def get_planet_path(openwrt_path=None):
    system = platform.system()
    if system == "Windows":
        return r"C:\ProgramData\ZeroTier\One\planet"
    elif "openwrt" in platform.platform().lower():
        if not openwrt_path:
            print("[!] OpenWrt 请使用 --openwrt-path 参数指定 planet 路径")
            sys.exit(1)
        return openwrt_path
    else:
        return "/var/lib/zerotier-one/planet"


def main():
    import argparse
    parser = argparse.ArgumentParser(description="ZeroTier Planet 更新工具（自动适配平台）")
    parser.add_argument("url", help="planet.custom 的下载链接")
    parser.add_argument("--openwrt-path", help="OpenWrt 下的 planet 文件路径（仅 OpenWrt 需要）")
    args = parser.parse_args()

    target_planet = get_planet_path(args.openwrt_path)
    backup_planet = target_planet + ".bak"
    temp_file = os.path.join(os.path.abspath(os.path.dirname(__file__)), "planet.custom")

    stop_service()
    download_planet(args.url, temp_file)

    if os.path.exists(target_planet):
        print("[*] 备份旧 planet 文件...")
        shutil.copyfile(target_planet, backup_planet)
        print(f"[+] 备份到: {backup_planet}")

    print("[*] 替换 planet 文件...")
    shutil.move(temp_file, target_planet)

    start_service()

    print(f"[✓] planet 文件更新完成：{target_planet}")


if __name__ == "__main__":
    main()
