@echo off
chcp 65001 >nul
echo ========================================
echo   霍尔木兹监控网站 - 自动更新脚本
echo ========================================
echo.

:: 设置路径
set SOURCE=C:\Users\61959\.qclaw\workspace\hormuz_monitor_final.html
set TARGET=C:\Users\61959\.qclaw\workspace\hormuz-site\index.html

:: 检查源文件是否存在
if not exist "%SOURCE%" (
    echo [错误] 找不到源文件: %SOURCE%
    echo 请确保 hormuz_monitor_final.html 在正确位置
    pause
    exit /b 1
)

:: 复制文件
echo [1/3] 复制文件...
copy /Y "%SOURCE%" "%TARGET%" >nul
if %errorlevel% neq 0 (
    echo [错误] 文件复制失败！
    pause
    exit /b 1
)
echo [OK] 文件已复制

:: Git 提交
echo.
echo [2/3] 提交更新...
cd /d "%~dp0"

:: 获取当前时间作为提交信息
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set DATE=%dt:~0,4%-%dt:~4,2%-%dt:~6,2% %dt:~8,2%:%dt:~10,2%:%dt:~12,2%

git add .
git commit -m "Update: %DATE%"
if %errorlevel% neq 0 (
    echo [错误] 提交失败！
    pause
    exit /b 1
)
echo [OK] 已提交

:: Git 推送
echo.
echo [3/3] 推送到 GitHub...
git push
if %errorlevel% neq 0 (
    echo.
    echo [错误] 推送失败！可能是网络问题或未登录 GitHub
    echo 请确保已运行: git remote add origin https://github.com/riven9955-max/hormuz-monitor.git
    pause
    exit /b 1
)
echo [OK] 推送成功！

echo.
echo ========================================
echo   更新完成！
echo   网站地址: https://riven9955-max.github.io/hormuz-monitor/
echo   等待约1-2分钟后生效
echo ========================================
pause
