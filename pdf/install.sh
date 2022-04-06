#! /usr/bin/env bash
# 

if [[ "$(id -u)" != "0" ]]; then
	echo "Install service menu for Dolphin!"
		install -m 755 bin/* ~/.local/bin/
		install -m 644 desktop/*.desktop ~/.local/share/kservices5/ServiceMenus/
	echo "Service menu is now installed"
fi