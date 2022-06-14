#!/bin/sh

REDSHIFT_PIDFILE=/tmp/redshift.pid

start_redshift() {
	redshift &
	echo $! > "$REDSHIFT_PIDFILE"
	update_i3status
}

stop_redshift() {
	if check_redshift
	then
		kill -s INT "$(cat "$REDSHIFT_PIDFILE")"
	fi
	update_i3status
}

check_redshift() {
	pid=$(cat "$REDSHIFT_PIDFILE")
	for _pid in $(ps -A -o pid,cmd | awk '/[[:digit:]]+ redshift/ { print $1 }')
	do
		if [ x"$pid" = x"$_pid" ]
		then
			return 0
		fi
	done

	return 1
}

update_i3status() {
	for _pid in $(ps -A -o pid,cmd | awk '/[[:digit:]]+ i3status/ { print $1 }')
	do
		kill -s USR1 "$_pid"
	done
}

main() {
	cmd=${1:-'invalid'}

	case $cmd in
		"start" )
			stop_redshift
			start_redshift
			;;
		"stop" )
			stop_redshift
			;;
		"toggle" )
			if check_redshift
			then
				stop_redshift
			else
				start_redshift
			fi
			;;
		* )
			echo "Usage: ./wrapper.sh <SUBCOMMAND>"
			echo "Available sub-commands:"
			echo "  - start"
			echo "  - stop"
			echo "  - toggle"
	esac
}
main "$@"

