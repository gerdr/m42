use v6;

sub panic($/, $msg = 'panic') is export is hidden_from_backtrace {
	my $no = +$/.orig.substr(0, $/.to).lines;
	my $line = $/.orig.lines[$no-1];
	die "$msg:\n[$no] $line";
}
