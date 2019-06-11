#!/usr/bin/env bash
#cmd.exe /c "@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin""
sudo apt-get update && sudo apt-get install python python-pip synaptic apt-xapian-index -y && sudo update-apt-xapian-index -vf
curl -s https://packagecloud.io/install/repositories/whitewaterfoundry/wslu/script.deb.sh | sudo bash

chmod +x translate-path.py

HOMEDIR=/home/${USER}
BASH_RC=${HOMEDIR}/.bashrc

# First we grab some handy environmental variables from our Windows Installation
WIN_COMPUTERNAME=$(cmd.exe /c "<nul set /p=%COMPUTERNAME%" 2>/dev/null)
WIN_USERNAME=$(cmd.exe /c "<nul set /p=%USERNAME%" 2>/dev/null)
WIN_USERPROFILE=$(cmd.exe /c "<nul set /p=%USERPROFILE%" 2>/dev/null)

USERPROFILE=`./translate-path.py ${WIN_USERPROFILE}`

if ! (grep -q DISPLAY "${BASH_RC}"); then
    echo export DISPLAY=:0 >> ${BASH_RC}
fi

if ! (grep -q COMPUTERNAME "${BASH_RC}"); then
  echo COMPUTERNAME=${WIN_COMPUTERNAME} >> ${BASH_RC}
fi

if ! (grep -q WINUSER "${BASH_RC}"); then
    echo WINUSER=${WIN_USERNAME} >> ${BASH_RC}
fi

if ! (grep -q USERPROFILE "${BASH_RC}"); then
    echo USERPROFILE=${USERPROFILE} >> ${BASH_RC}
fi

if ! [ -d "${HOMEDIR}/.ssh" ]; then
	if ! [ -d "${USERPROFILE}/.ssh" ]; then
	    mkdir ${USERPROFILE}/.ssh
	fi
	if ! [ -d "${HOMEDIR}/.ssh" ]; then
	    ln -s ${USERPROFILE}/.ssh ${HOMEDIR}/.ssh
	fi
fi

windows_folders=("Videos" "Pictures" "Downloads" "Desktop" "Documents" "OneDrive" "workspace")
for windows_folder in "${windows_folders[@]}"; do
    foldername="${HOMEDIR}/$windows_folder"
    winfolder="${USERPROFILE}/$windows_folder"
    echo "Checking $foldername"
    if ! [ -d "$foldername" ]; then
        if [ -d "$winfolder" ]; then
            echo "Creating: $foldername"
            ln -s $winfolder $foldername
        fi
    fi
done

