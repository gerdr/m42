use v6;
module float16;

my sub frac($bits) {
	state @fracs = map 0.5e0 / 2e0 ** *, reverse ^10;
	[+] @fracs.kv.map({ $bits +& (1 +< $^k) ?? $^v !! 0e0 })
}

our sub enc(Num $num --> Int) {
	!!!
}

our sub dec(Int $bits --> Num) {
	my $sign = $bits +> 15;
	my $exp = ($bits +> 10) +& 0x1F;
	my $frac = $bits +& 0x3FF;

	my $num = do given $exp {
		when 0x1F { $frac ?? NaN !! Inf }
		when 0x00 { $frac ?? frac($frac) * 2e0 ** -14 !! 0e0 }
		default   { (1e0 + frac($frac)) * 2e0 ** ($exp - 15) }
	}

	$sign ?? -$num !! $num
}

our sub is(Num $num --> Bool) {
	$num.isNaN || $num == dec(enc($num))
}
