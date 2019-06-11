#!/usr/bin/env bash

HOMEDIR=/home/${USER}
BASH_RC=${HOMEDIR}/.bashrc

# First we grab some handy environmental variables from our Windows Installation
WIN_COMPUTERNAME=$(cmd.exe /c "<nul set /p=%COMPUTERNAME%" 2>/dev/null)
WIN_USERNAME=$(cmd.exe /c "<nul set /p=%USERNAME%" 2>/dev/null)
WIN_USERPROFILE=$(cmd.exe /c "<nul set /p=%USERPROFILE%" 2>/dev/null)

USERPROFILE=`./translate-path.py ${WIN_USERPROFILE}`

if ! (grep -q COMPUTERNAME "${BASH_RC}"); then
  echo COMPUTERNAME=${WIN_COMPUTERNAME} >> ${BASH_RC}
fi

if ! (grep -q WINUSER "${BASH_RC}"); then
    echo WINUSER=${WIN_USERNAME} >> ${BASH_RC}
fi

if ! (grep -q USERPROFILE "${BASH_RC}"); then
    echo USERPROFILE=${USERPROFILE} >> ${BASH_RC}
fi

if ! [[ -d "${HOMEDIR}/.ssh" ]]; then
	if ! [[ -d "${USERPROFILE}/.ssh" ]]; then
	    mkdir ${USERPROFILE}/.ssh
	fi
	ln -s ${USERPROFILE}/.ssh ${HOMEDIR}/.ssh
fi

windows_folders='Videos Pictures Downloads Desktop Documents OneDrive workspace '
for f in windows_folders; do
    if ! [[ -d "${HOMEDIR}/$f" ]]; then
        if [[ -d "${USERPROFILE}/$f" ]]; then
            ln -s ${USERPROFILE}/${f} ${HOMEDIR}/${f}
        fi
    fi
done