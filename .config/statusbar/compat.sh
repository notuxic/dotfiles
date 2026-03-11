#!/bin/sh

_uname="$(uname -s)"


_sbc_update_i3status() {
	for _pid in $(ps -A -o pid,args | awk '/[[:digit:]]+ i3status/ { print $1 }')
	do
		kill -s USR1 "$_pid"
	done
}



# Audio
########


_sbc_audio_toggle() {
	if [ "$_uname" = "Linux" ]
	then
		amixer set Master toggle
	elif [ "$_uname" = "FreeBSD" ]
	then
		mixer vol.mute=toggle
	fi
	_sbc_update_i3status
}


_sbc_audio_mute() {
	if [ "$_uname" = "Linux" ]
	then
		amixer set Master mute
	elif [ "$_uname" = "FreeBSD" ]
	then
		mixer vol.mute=on
	fi
	_sbc_update_i3status
}


_sbc_audio_unmute() {
	if [ "$_uname" = "Linux" ]
	then
		amixer set Master unmute
	elif [ "$_uname" = "FreeBSD" ]
	then
		mixer vol.mute=off
	fi
	_sbc_update_i3status
}


_sbc_audio_volume_decrease() {
	if [ "$_uname" = "Linux" ]
	then
		amixer set Master 5%-
	elif [ "$_uname" = "FreeBSD" ]
	then
		mixer vol=-5%
	fi
	_sbc_update_i3status
}


_sbc_audio_volume_increase() {
	if [ "$_uname" = "Linux" ]
	then
		amixer set Master 5%+
	elif [ "$_uname" = "FreeBSD" ]
	then
		mixer vol=+5%
	fi
	_sbc_update_i3status
}


_sbc_brightness_increase() {
	if [ "$_uname" = "Linux" ]
	then
	elif [ "$_uname" = "FreeBSD" ]
	then
		backlight + 5
	fi
	_sbc_update_i3status
}


_sbc_brightness_decrease() {
	if [ "$_uname" = "Linux" ]
	then
	elif [ "$_uname" = "FreeBSD" ]
	then
		backlight - 5
	fi
	_sbc_update_i3status
}



# CLI
######


_sbc_cli_audio_help() {
	echo "Usage: ./compat.sh audio toggle    toggle mute/unmute"
	echo "       ./compat.sh audio mute      mute audio"
	echo "       ./compat.sh audio unmute    unmute audio"
	echo "       ./compat.sh audio up        increase volume by 5%"
	echo "       ./compat.sh audio down      decrease volume by 5%"
}


_sbc_cli_audio() {
	case "$2" in
		"help" )
			_sbc_cli_audio_help
			;;
		"toggle" )
			_sbc_audio_toggle
			;;
		"mute" )
			_sbc_audio_mute
			;;
		"unmute" )
			_sbc_audio_unmute
			;;
		"up" )
			_sbc_audio_volume_increase
			;;
		"down" )
			_sbc_audio_volume_decrease
			;;
		* )
			_sbc_cli_audio_help
			exit 1
	esac
}


_sbc_cli_brightness_help() {
	echo "Usage: ./compat.sh brightness up      increase brightness"
	echo "       ./compat.sh brightness down    decrease brightness"
}


_sbc_cli_brightness() {
	case "$2" in
		"help" )
			_sbc_cli_brightness_help
			;;
		"up" )
			_sbc_brightness_increase
			;;
		"down" )
			_sbc_brightness_decrease
			;;
		* )
			_sbc_cli_brightness_help
			exit 1
	esac
}


_sbc_cli_help() {
	echo "Usage: ./compat audio <SUBCOMMAND>        audio control"
	echo "       ./compat brightness <SUBCOMMAND>    brightness control"
}


_sbc_cli_main() {
	case "$1" in
		"help" )
			_sbc_cli_help
			;;
		"audio" )
			_sbc_cli_audio "$@"
			;;
		"brightness" )
			_sbc_cli_brightness "$@"
			;;
		* )
			_sbc_cli_help
			exit 1
	esac

	exit 0
}


_sbc_cli_main "$@"
