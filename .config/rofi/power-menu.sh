#!/bin/sh

_uname="$(uname -s)"


_pm_poweroff() {
	if [ "$_uname" = "Linux" ]
	then
		poweroff
	fi
}


_pm_reboot() {
	if [ "$_uname" = "Linux" ]
	then
		reboot
	fi
}


_pm_lock() {
	(~/.config/i3lock/wrapper.sh </dev/null >/dev/null 2>/dev/null &)
}


_pm_bootnext() {
	if [ "$_uname" = "Linux" ]
	then
		efibootmgr -n "$ROFI_INFO"
	fi
}


printf "\0no-custom\x1ftrue\n"
if [ $# -eq 0 ]
then
	_boot_entries=$(efibootmgr | grep "^Boot[[:digit:]]\{4\}")
	_ebm_available=$?

	
	printf "Lock\0info\x1fLock\x1ficon\x1fsystem-lock-screen\n"
	printf "Poweroff\0info\x1fPoweroff\x1ficon\x1fsystem-shutdown\n"
	printf "Reboot\0info\x1fReboot\x1ficon\x1fsystem-reboot\n"

	if [ $_ebm_available -eq 0 ]
	then
		printf "   \0nonselectable\x1ftrue\n"
		printf "Reboot into:\0nonselectable\x1ftrue\n"

		_ifs_bak="$IFS"
		IFS='
'
		for _entry in $_boot_entries
		do
			printf "%s\0info\x1f%s\x1ficon\x1fsystem-reboot\n" "$(echo "$_entry" | sed 's/Boot[[:digit:]]\{4\}\**/ /')" "$(echo "$_entry" | sed 's/Boot\([[:digit:]]\{4\}\).*/\1/')"
		done
		IFS="$_ifs_bak"
	fi
else
	case "$ROFI_INFO" in
		Poweroff )
			_pm_poweroff
			;;
		Reboot )
			_pm_reboot
			;;
		Lock )
			_pm_lock
			;;
		* )
			_pm_bootnext
			_pm_reboot
			;;
	esac
fi

