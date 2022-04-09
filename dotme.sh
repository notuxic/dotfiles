#!/bin/sh

## AUTHOR: notuxic
## LICENSE: BSD 2-clause
## VERSION: 1.0


DOTME_TARGET_DIR=${DOTME_TARGET_DIR:-$HOME}
DOTME_IGNORE=${DOTME_IGNORE:-"dotme.sh README.md LICENSE"}


_util_in_list() {
	elem=${1?}
	lst=${2?}

	for e in $lst
	do
		if [ x"$e" = x"$elem" ]
		then
			return 0
		fi
	done

	return 1
}

_install_file() {
	source_file=${1?}
	mkdir -p "$DOTME_TARGET_DIR/$(dirname "$source_file")"

	if [ -e "$DOTME_TARGET_DIR/$source_file" ]
	then
		serial_new=$(ls -i "$source_file" | awk '{ print $1 }')
		serial_old=$(ls -i "$DOTME_TARGET_DIR/$source_file" | awk '{ print $1 }')
		if [ x"$serial_old" != x"$serial_new" ]
		then
			echo "[!] File already exists: $DOTME_TARGET_DIR/$source_file"
			printf "Replace file? [y/N] "
			read -r confirm
			case ${confirm:-"N"} in
				y | Y | yes | Yes | YES )
					rm "$DOTME_TARGET_DIR/$source_file"
					;;
				* )
					return 0
					;;
			esac
		else
			echo "[i] Skipping installed file: $source_file"
			return 0
		fi
	fi

	echo "[i] Installing file: $source_file"
	ln -P "$source_file" "$DOTME_TARGET_DIR/$source_file"
}

_cmd_install() {
	if [ $# -ne 1 ]
	then
		_cmd_help
	fi

	for filex in $(find . ! -type d | grep -v './.git/')
	do
		if ! _util_in_list $(echo "$filex" | sed 's/^\.\///') "$DOTME_IGNORE"
		then
			_install_file "$filex"
		fi
	done
}

_cmd_help() {
	echo "Usage: ./dotme.sh <SUBCOMMAND>"
	echo "Available sub-commands:"
	echo "  - install"
	echo "    Install all files into \$DOTME_TARGET_DIR (defaults to \$HOME) using hardlinks."
	echo "  - help"
	echo "    Print this help text."
	exit 1
}

_main() {
	cd "$PWD/$(dirname "$0")"
	if [ $# -lt 1 ]
	then
		_cmd_help
	fi

	cmd=${1?}
	case $cmd in
		help )
			_cmd_help
			;;
		install )
			_cmd_install "$@"
			;;
		* )
			_cmd_help
			;;
	esac

	exit 0
}

_main "$@"

