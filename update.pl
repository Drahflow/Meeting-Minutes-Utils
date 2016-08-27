#!/usr/bin/perl

use strict;
use warnings;
use IO::Handle;

my $in = $ARGV[0];
my $out = $ARGV[1];
my $length = $ARGV[2];
my $mode = $ARGV[3];
my $http = '';
my $style = '';

die "usage: update.pl <in> <out> [length] [(http)?(mobile)?(raw)?]" unless defined $in and defined $out;

my $refresh = 10;
if(defined $length and $length < 16000) {
	$refresh = 1;
}
if($mode =~ /http/) {
	$http = <<"EOHTTP";
HTTP/1.0 200 OK
Content-type: text/html; charset=utf-8
Refresh: $refresh

EOHTTP
}
if($mode =~ /mobile/) {
	$style = <<"EOCSS";
<style type="text/css">
body {
font-size: 300%;
}
</style>
EOCSS
}
if($mode =~ /streamoverlay/) {
	$style = <<"EOCSS";
<style type="text/css">
body {
font-size: 300%;
color: #ffffff;
background-color: #00ff00;
margin: 0px;
padding: 40px;
}
</style>
EOCSS
}

my $html1 = <<"EOHTML";
<html><head>
<meta http-equiv="Content-type" content="text/html; charset=UTF-8" />
<meta http-equiv="Refresh" content="$refresh" />
EOHTML
my $html2 = '</head><body onload="document.body.scrollTop = document.body.scrollHeight;">';
my $html3 = '</body></html>';

if($mode =~ /raw/) {
  $html1 = $html2 = $html3 = '';
}

open OUT, ">", $out or die "cannot open $out: $!";

while(1) {
	my $output = <<"EOHTTP";
$http$html1$style$html2
EOHTTP

	my $size = [stat $in]->[7];
	open IN, "<", $in or warn "cannot open $in: $!";
	if(defined $length) {
		seek IN, $size - $length, 0;
}
	$output .= join "", <IN>;
	$output .= " " x 40;
	close IN;

	$output .= $html3;

	seek OUT, 0, 0;
	print OUT $output;
	OUT->flush();

	system("date");

	select undef, undef, undef, 0.2;
}

close OUT;
