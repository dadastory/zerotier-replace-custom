@echo off
chcp 936 >nul
REM ====================================================
REM update-planet.cmd
REM ���ܣ����� planet.custom�����滻 ZeroTier �� planet �ļ�
REM �÷�������Ա���У���
REM   update-planet.cmd https://domain/planet.custom
REM ====================================================

if "%~1"=="" (
  echo �������ṩ��������
  echo �÷���%~nx0 https://domain/planet.custom
  exit /b 1
)

set "DOWNLOAD_URL=%~1"
set "DEST_DIR=C:\ProgramData\ZeroTier\One"
set "TEMP_FILE=%TEMP%\planet.custom"

echo.
echo ========== ֹͣ ZeroTier ���� ==========
net stop "ZeroTier One" >nul 2>&1
if errorlevel 1 (
  net stop ZeroTierOne >nul 2>&1
  if errorlevel 1 (
    echo ���棺δ��ֹͣ����ZeroTier One����ZeroTierOne������ȷ�Ϸ����Ƿ���ڡ�
  ) else (
    echo ��ֹͣ���� ZeroTierOne
  )
) else (
  echo ��ֹͣ���� "ZeroTier One"
)

echo.
echo ========== ���� planet.custom ==========
echo URL: %DOWNLOAD_URL%
curl -L -f -o "%TEMP_FILE%" "%DOWNLOAD_URL%"
if errorlevel 1 (
  echo ����curl ����ʧ��
  exit /b 1
)
echo ������ɣ�%TEMP_FILE%

echo.
echo ========== ���ݾ��ļ� ==========
if exist "%DEST_DIR%\planet" (
  echo ����ԭ planet �� planet.bak
  copy /Y "%DEST_DIR%\planet" "%DEST_DIR%\planet.bak" >nul
) else (
  echo ԭ planet �ļ������ڣ���������
)

echo.
echo ========== �滻 planet ==========
move /Y "%TEMP_FILE%" "%DEST_DIR%\planet" >nul
if errorlevel 1 (
  echo �����޷��ƶ��ļ��� %DEST_DIR%\planet
  exit /b 1
)
echo �滻���

echo.
echo ========== ���� ZeroTier ���� ==========
net start "ZeroTier One" >nul 2>&1
if errorlevel 1 (
  net start ZeroTierOne >nul 2>&1
  if errorlevel 1 (
    echo ���棺δ����������ZeroTier One����ZeroTierOne�����������״̬
  ) else (
    echo ���������� ZeroTierOne
  )
) else (
  echo ���������� "ZeroTier One"
)

echo.
echo ===== ������ɣ�%DEST_DIR%\planet =====
pause

