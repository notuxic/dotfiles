#!/bin/sh

_uname="$(uname -s)"



# Audio
########


_sbc_audio_toggle() {
	if [ "$_uname" = "Linux" ]
	then
		amixer set Master toggle
	fi
}


_sbc_audio_mute() {
	if [ "$_uname" = "Linux" ]
	then
		amixer set Master mute
	fi
}


_sbc_audio_unmute() {
	if [ "$_uname" = "Linux" ]
	then
		amixer set Master unmute
	fi
}


_sbc_audio_volume_decrease() {
	if [ "$_uname" = "Linux" ]
	then
		amixer set Master 5%-
	fi
}


_sbc_audio_volume_increase() {
	if [ "$_uname" = "Linux" ]
	then
		amixer set Master 5%+
	fi
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


_sbc_cli_help() {
	echo "Usage: ./compat audio <SUBCOMMAND>    audio control"
}


_sbc_cli_main() {
	case "$1" in
		"help" )
			_sbc_cli_help
			;;
		"audio" )
			_sbc_cli_audio "$@"
			;;
		* )
			_sbc_cli_help
			exit 1
	esac

	exit 0
}


_sbc_cli_main "$@"
