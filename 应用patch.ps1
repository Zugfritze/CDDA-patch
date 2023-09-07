# 获取当前脚本所在目录
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

# 获取脚本所在目录下的所有 Git Patch 文件
$patchFiles = Get-ChildItem -Path $scriptPath -Filter "*.patch" | Sort-Object @{Expression = {
        [regex]::Match($_.BaseName, '^\d+').Value -as [int]
    }
}

# 遍历每个 Patch 文件
foreach ($patchFile in $patchFiles) {
    $patchFilePath = "$scriptPath\$($patchFile.Name)"

    try {
        # 应用 Patch 文件到当前目录
        Write-Host "应用 Patch 文件 $($patchFile.Name) 到当前目录..."
        git apply $patchFilePath
        if (-not $?) { throw }
        Write-Host "应用完成！"
    }
    catch {
        # 应用 Patch 发生错误
        Write-Host "应用 Patch 文件 $($patchFile.Name) 时出现错误!"
    }
}