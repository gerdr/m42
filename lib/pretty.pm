use v6;

sub pretty($perl, :$indent = '  ') is export {
	my ($pc, $depth, $string, $esc) = '', 0, False, False;

	join '', gather for $perl.comb -> $cc {
		NEXT $pc = $cc;

		unless $string {
			given \($pc, $cc) {
				when :('(', ')') {}
				when :($, ')') {
					take "\n", $indent x --$depth;
				}
				when :('(', $) {
					take "\n", $indent x ++$depth
				}
				when :(',', ' ') {
					take "\n", $indent x $depth;
					next;
				}
			}
		}

		$esc = !$esc && $pc eq '\\';
		$string ^^= $cc eq '"' unless $esc;

		take $cc;
	}
}
