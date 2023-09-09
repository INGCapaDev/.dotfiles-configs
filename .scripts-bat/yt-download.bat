@echo off
setlocal enabledelayedexpansion

REM Solicitar la URL del usuario
set /p "youtube_url=Introduce la URL de YouTube: "

REM Cambiar al directorio raíz de C:
cd "C:\"

REM Ejecutar yt-dlp con la URL proporcionada
CD "C:\" && "%PROGRAMFILES%\yt-dlp\yt-dlp.exe" --format bestaudio --ffmpeg-location "%PROGRAMFILES%\ffmpeg" --extract-audio --audio-format mp3 --no-keep-video --ignore-errors --cookies-from-browser brave --output "%HOMEPATH%\Music\%%(title)s.mp3" !youtube_url!

endlocal
