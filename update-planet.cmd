@echo off
chcp 936 >nul
REM ====================================================
REM update-planet.cmd
REM 功能：下载 planet.custom，并替换 ZeroTier 的 planet 文件
REM 用法（管理员运行）：
REM   update-planet.cmd https://domain/planet.custom
REM ====================================================

if "%~1"=="" (
  echo 错误：请提供下载链接
  echo 用法：%~nx0 https://domain/planet.custom
  exit /b 1
)

set "DOWNLOAD_URL=%~1"
set "DEST_DIR=C:\ProgramData\ZeroTier\One"
set "TEMP_FILE=%TEMP%\planet.custom"

echo.
echo ========== 停止 ZeroTier 服务 ==========
net stop "ZeroTier One" >nul 2>&1
if errorlevel 1 (
  net stop ZeroTierOne >nul 2>&1
  if errorlevel 1 (
    echo 警告：未能停止服务“ZeroTier One”或“ZeroTierOne”，请确认服务是否存在。
  ) else (
    echo 已停止服务 ZeroTierOne
  )
) else (
  echo 已停止服务 "ZeroTier One"
)

echo.
echo ========== 下载 planet.custom ==========
echo URL: %DOWNLOAD_URL%
curl -L -f -o "%TEMP_FILE%" "%DOWNLOAD_URL%"
if errorlevel 1 (
  echo 错误：curl 下载失败
  exit /b 1
)
echo 下载完成：%TEMP_FILE%

echo.
echo ========== 备份旧文件 ==========
if exist "%DEST_DIR%\planet" (
  echo 备份原 planet 到 planet.bak
  copy /Y "%DEST_DIR%\planet" "%DEST_DIR%\planet.bak" >nul
) else (
  echo 原 planet 文件不存在，跳过备份
)

echo.
echo ========== 替换 planet ==========
move /Y "%TEMP_FILE%" "%DEST_DIR%\planet" >nul
if errorlevel 1 (
  echo 错误：无法移动文件到 %DEST_DIR%\planet
  exit /b 1
)
echo 替换完成

echo.
echo ========== 重启 ZeroTier 服务 ==========
net start "ZeroTier One" >nul 2>&1
if errorlevel 1 (
  net start ZeroTierOne >nul 2>&1
  if errorlevel 1 (
    echo 警告：未能启动服务“ZeroTier One”或“ZeroTierOne”，请检查服务状态
  ) else (
    echo 已启动服务 ZeroTierOne
  )
) else (
  echo 已启动服务 "ZeroTier One"
)

echo.
echo ===== 更新完成：%DEST_DIR%\planet =====
pause

