#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use IO::Handle;


my $dzen2_cmd = 'dzen2 -fn "Hack Nerd Font-11" -h 18 -bg \#002b36 -fg \#fdf6e3 -e "" -dock';
# 11pt -> 18h 9w
# 12pt -> 19h 9.5w
# 13pt -> 20h 10w

my $workspace_pre = '^bg(#93a1a1) 舘 ^fg(#93a1a1)^bg()';
my $workspace_post = '';
my $status_pre = '';
my $status_post = '^fg(#657b83)^fg()^bg(#657b83) 襤 ';

my %workspace_icons_inactive = (
	'home1' => '',
	'media1' => 'ﱘ',
	'dev1' => '謹',
	'term1' => 'ﲵ',
	'other1' => '',
	'home2' => '',
	'media2' => 'ﱘ',
	'dev2' => '謹',
	'term2' => 'ﲵ',
	'other2' => ''
);

my %workspace_icons_active = %workspace_icons_inactive;


my $dzen2;
my $monitor = '';
my $monitor_width = 0;
my $monitor_width_half = 0;
my $status_width = 0;
my $workspace_width = 0;
my $use_nice_time = 1;
my $i3s_output = '';
my $status_widget;
my $workspace_widget = '';
my $active_workspace = '';
my @inactive_ws_pre = ();
my @inactive_ws_post = ();


sub handle_sighup
{
	parse_workspaces();
	build_workspace_widget();
	print_line();
}

sub handle_sigusr2
{
	$use_nice_time = !$use_nice_time;
	print_line();
}

sub calc_width_workspace_widget
{
	my $text = "$workspace_pre$workspace_widget$workspace_post";
	$text =~ s/\^[a-z]+\(.*?\)//g;
	$workspace_width = length($text) * 9;
}

sub calc_width_status_widget
{
	my $text = "$status_pre$status_widget$status_post";
	$text =~ s/\^[a-z]+\(.*?\)//g;
	$status_width = length($text) * 9;
}

sub parse_workspaces
{
	@inactive_ws_pre = ();
	@inactive_ws_post = ();

	$active_workspace = `bspc query -D -d $monitor:focused --names`;
	chomp $active_workspace;
	my @current_workspaces = split('\n', `bspc query -D -m $monitor --names`);

	my $found_current_ws = 0;
	for (@current_workspaces)
	{
		if ($_ eq $active_workspace)
		{
			$found_current_ws = 1;
			next;
		}

		if ($found_current_ws)
		{
			push(@inactive_ws_post, $_);
		}
		else
		{
			push(@inactive_ws_pre, $_);
		}
	}
}

sub build_workspace_widget
{
	for (my $i = 0; $i <= $#inactive_ws_pre; $i++)
	{
		$inactive_ws_pre[$i] = "^ca(1, bspc desktop $inactive_ws_pre[$i] -f)^fg(#fdf6e3) $workspace_icons_inactive{$inactive_ws_pre[$i]} ^ca()";
	}
	my $inactive_ws_pre = join('^fg(#93a1a1)', @inactive_ws_pre);

	$active_workspace = "^fg(#fdf6e3) $workspace_icons_active{$active_workspace} ";
	
	for (my $i = 0; $i <= $#inactive_ws_post; $i++)
	{
		$inactive_ws_post[$i] = "^ca(1, bspc desktop $inactive_ws_post[$i] -f)^fg(#fdf6e3) $workspace_icons_inactive{$inactive_ws_post[$i]} ^ca()";
	}
	my $inactive_ws_post = join('^fg(#93a1a1)', @inactive_ws_post);

	if ($#inactive_ws_pre < 0)
	{
		$workspace_widget = "^fg(#002b36)^bg(#839496)$active_workspace";
	}
	else
	{
		$workspace_widget = "^fg(#002b36)^bg(#657b83)$inactive_ws_pre^fg(#657b83)^bg(#839496)$active_workspace";
	}

	if ($#inactive_ws_post < 0)
	{
		$workspace_widget = "$workspace_widget^fg(#839496)^bg()";
	}
	else
	{
		$workspace_widget = "$workspace_widget^fg(#839496)^bg(#657b83)$inactive_ws_post^fg(#657b83)^bg()";
	}

	calc_width_workspace_widget();
}

sub print_line
{
	$status_widget = $i3s_output;

	if ($use_nice_time)
	{
		$status_widget =~ s/\{\{\/?LOCAL\}\}//g;
		$status_widget =~ s/\{\{UTC\}\}.*\{\{\/UTC\}\}//;
	}
	else
	{
		$status_widget =~ s/\{\{\/?UTC\}\}//g;
		$status_widget =~ s/\{\{LOCAL\}\}.*\{\{\/LOCAL\}\}//;
	}

	calc_width_status_widget();
	my $offset = $monitor_width - $workspace_width - $status_width;
	print $dzen2 "$workspace_pre$workspace_widget$workspace_post^p($offset)$status_pre$status_widget$status_post\n";
}

sub _main
{
	$ENV{'LC_ALL'} = 'en_US.UTF-8';
	$ENV{'SIG_PID'} = "$$";
	$SIG{'HUP'} = \&handle_sighup;
	$SIG{'USR1'} = \&handle_sigusr1;
	$SIG{'USR2'} = \&handle_sigusr2;

	my $xs = `xrandr --listmonitors | awk -F'[: \t]' "/$monitor/ { print \\\$2 }"`;
	if ($xs ne '')
	{
		$xs++;
	}
	else
	{
		print("[!] monitor not found: $monitor\n");
		exit(2);
	}
	$dzen2_cmd = "$dzen2_cmd -xs $xs";

	$monitor_width = `xrandr --listactivemonitors | grep "$monitor"`;
	chomp $monitor_width;
	$monitor_width =~ s/^.+ (\d+)(\/\d+)x\d+.+$/$1/;
	$monitor_width_half = $monitor_width / 2;

	parse_workspaces();
	build_workspace_widget();

	open(my $i3status, '-|:utf8', 'i3status');
	open($dzen2, '|-:utf8', $dzen2_cmd);
	$dzen2->autoflush(1);
	while (<$i3status>)
	{
		chomp;
		$i3s_output = $_;
		print_line();
	}
	close($i3status);
	close($dzen2);
}


unless (caller)
{
	if ($#ARGV != 0)
	{
		print("Usage: ./statusbar.pl <MONITOR_NAME>\n");
		exit(1);
	}
	$monitor = $ARGV[0];
	_main();
}

