# 背景画像のパスを設定
$lightThemePath = "D:\Media\Picture\ChangeWallpaperByTime\daytime.jpg"
$darkThemePath = "D:\Media\Picture\ChangeWallpaperByTime\nighttime.jpg"
$logPath = "D:\Media\Picture\ChangeWallpaperByTime\WallpaperChangeLog.txt"

#朝夜の時間を設定
$morning_time = 7
$night_time = 23

# 現在の時刻を取得
$hour = (Get-Date).Hour
$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# 時刻に応じて背景を変更し、ログに記録
if ($hour -ge $morning_time -and $hour -lt $night_time) {
    $imagePath = $lightThemePath
    $logMessage = "$date - Set light theme wallpaper."
} else {
    $imagePath = $darkThemePath
    $logMessage = "$date - Set dark theme wallpaper."
}

# 壁紙を設定
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

# SPI_SETDESKWALLPAPERを使って壁紙を変更
$SPI_SETDESKWALLPAPER = 0x0014
$SPIF_UPDATEINIFILE = 0x01
$SPIF_SENDWININICHANGE = 0x02
[Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $imagePath, $SPIF_UPDATEINIFILE -bor $SPIF_SENDWININICHANGE)

# ログにメッセージを追記
Add-Content -Path $logPath -Value $logMessage