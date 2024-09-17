# 获取当前路径
$currentPath = Get-Location


$passWord = "88888888"

# 定义下载链接
$exeUrl = "https://gitee.com/dylanbai8/download/releases/download/27.77/7z.exe"
$dllUrl = "https://gitee.com/dylanbai8/download/releases/download/27.77/7z.dll"



# 查找所有符合条件的文件
$files = Get-ChildItem -Path $currentPath -Filter *.7z.001

# 检查文件数
if ($files.Count -eq 1) {
    # 如果文件数为1，将文件名赋值给变量
    $fileName = $files.Name
    Write-Output "找到的文件: $fileName"
Extract-With7z -fileName $fileName -passWord $passWord -exeUrl $exeUrl -dllUrl $dllUrl

} else {
    # 如果文件数不为1，则报错
    Write-Output "错误: 找到的文件数为 $($files.Count)，应为1个"
return
}


function Extract-With7z {
    param (
        [string]$fileName,
        [string]$passWord,
        [string]$exeUrl,
        [string]$dllUrl
    )

    $currentPath = Get-Location
    $exeFile = Join-Path $currentPath "7z.exe"
    $dllFile = Join-Path $currentPath "7z.dll"
    $fileToExtract = Join-Path $currentPath $fileName

    # 下载 7z.exe 和 7z.dll
    Invoke-WebRequest -Uri $exeUrl -OutFile $exeFile
    Invoke-WebRequest -Uri $dllUrl -OutFile $dllFile

    # 检查文件是否存在
    if (Test-Path $exeFile -and Test-Path $dllFile) {
        attrib +h $exeFile
        attrib +h $dllFile

        # 解压命令
        & $exeFile x $fileToExtract "-p$passWord" "-o$currentPath"
        Write-Output "解压完成。"

        # 删除临时文件
        Remove-Item $exeFile -Force
        Remove-Item $dllFile -Force
    } else {
        Write-Output "下载失败或文件不完整，请检查网络连接。"
    }
}
