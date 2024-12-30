# Set the base path where files should be downloaded
$BasePath = "C:\Sandbox\SandboxFiles"

Function Download-File {
    Param (
        [string]$url,
        [string]$path
    )
  
    $start_time = Get-Date
    Write-Output "Downloading $($url)"
    
    # Enable modern TLS
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # Ensure the directory exists
    $directory = Split-Path -Path $path
    if (-not (Test-Path $directory)) {
        New-Item -Path $directory -ItemType Directory -Force
    }

    # Download the file
    Try {
        Invoke-WebRequest -Uri $url -OutFile $path -Headers @{ 'User-Agent' = 'Wget x64' }
    }
    Catch {
        Write-Output "Exception: $($_.Exception.Message)"
        throw $_
    }
  
    Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"  
}

Try {
    # Example downloads using $BasePath
    Download-File -url "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.6.8/npp.8.6.8.Installer.x64.exe" -path "$($BasePath)\notepad++.exe"
    Write-Output "File downloaded to: $($BasePath)\notepad++.exe"

    Download-File -url "https://download.sublimetext.com/sublime_text_build_4169_x64_setup.exe" -path "$($BasePath)\sublime.exe"
    Write-Output "File downloaded to: $($BasePath)\notepad++.exe"

    Download-File -url "https://corretto.aws/downloads/latest/amazon-corretto-21-x64-windows-jdk.msi" -path "$($BasePath)\corretto.msi"
    Write-Output "File downloaded to: $($BasePath)\notepad++.exe"

    Download-File -url "https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.1_build/ghidra_11.1_PUBLIC_20240607.zip" -path "$($BasePath)\ghidra.zip"
    Write-Output "File downloaded to: $($BasePath)\notepad++.exe"

    Download-File -url "https://www.7-zip.org/a/7z2406-x64.exe" -path "$($BasePath)\7zip.msi"
    Write-Output "File downloaded to: $($BasePath)\notepad++.exe"

    Download-File -url "https://sourceforge.net/projects/dosbox/files/latest/download" -path "$($BasePath)\dosbox.exe"
    Write-Output "File downloaded to: $($BasePath)\notepad++.exe"

    Download-File -url "https://sourceforge.net/projects/x64dbg/files/latest/download" -path "$($BasePath)\x64dbg.zip"
    Write-Output "File downloaded to: $($BasePath)\notepad++.exe"

    Download-File -url "https://download.sysinternals.com/files/SysinternalsSuite.zip" -path "$($BasePath)\sysinternals.zip"
    Write-Output "File downloaded to: $($BasePath)\notepad++.exe"

    Download-File -url "https://github.com/dnSpyEx/dnSpy/releases/latest/download/dnSpy-net-win64.zip" -path "$($BasePath)\dnSpy.zip"
    Write-Output "File downloaded to: $($BasePath)\notepad++.exe"
   
    Download-File -url "https://www.python.org/ftp/python/3.12.4/python-3.12.4-amd64.exe" -path "$($BasePath)\python3.exe"
    Write-Output "File downloaded to: $($BasePath)\notepad++.exe"

    Download-File -url "https://www.python.org/ftp/python/2.7.18/python-2.7.18.amd64.msi" -path "$($BasePath)\python2.msi"
    Write-Output "File downloaded to: $($BasePath)\notepad++.exe"

    Download-File -url "https://github.com/horsicq/DIE-engine/releases/download/3.09/die_win64_portable_3.09_x64.zip" -path "$($BasePath)\detectiteasy.zip"
    Write-Output "File downloaded to: $($BasePath)\notepad++.exe"

    Download-File -url "https://github.com/upx/upx/releases/download/v4.2.4/upx-4.2.4-win64.zip" -path "$($BasePath)\upx.zip"
    Write-Output "File downloaded to: $($BasePath)\notepad++.exe"

    Download-File -url "https://mh-nexus.de/downloads/HxDSetup.zip" -path "$($BasePath)\hxd.zip"
    Write-Output "File downloaded to: $($BasePath)\notepad++.exe"

    Download-File -url "https://npcap.com/dist/npcap-1.79.exe" -path "$($BasePath)\npcap.exe"
    Write-Output "File downloaded to: $($BasePath)\notepad++.exe"

    Download-File -url "https://2.na.dl.wireshark.org/win64/Wireshark-4.2.5-x64.exe" -path "$($BasePath)\wireshark.exe"
    Write-Output "File downloaded to: $($BasePath)\notepad++.exe"

    # dep for pebear
    Download-File -url "https://aka.ms/vs/17/release/vc_redist.x64.exe" -path "$($BasePath)\vcredist_x64.exe"
    Write-Output "File downloaded to: $($BasePath)\notepad++.exe"

    Download-File -url "https://github.com/hasherezade/pe-bear/releases/download/v0.6.7.3/PE-bear_0.6.7.3_x64_win_vs19.zip" -path "$($BasePath)\pebear.zip"
    Write-Output "File downloaded to: $($BasePath)\notepad++.exe"

    Download-File -url "https://www.winitor.com/tools/pestudio/current/pestudio.zip" -path "$($BasePath)\pestudio.zip"
    Write-Output "File downloaded to: $($BasePath)\notepad++.exe"

    Download-File -url "https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml" -path "$($BasePath)\sysmonconfig-export.xml"
    Write-Output "File downloaded to: $($BasePath)\notepad++.exe"

  }
  Catch {
    $error[0] | Format-List * -force
  }
