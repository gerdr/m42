use v6;
module float16;

my sub frac($bits) {
	state @fracs = map 0.5e0 / 2e0 ** *, reverse ^10;
	[+] @fracs.kv.map({ $bits +& (1 +< $^k) ?? $^v !! 0e0 })
}

our proto enc(Num $num, Bool :$exact --> Int) { * }

my multi enc(Num $num, Bool :$exact! --> Int) {
	my $enc = enc($num);
	my $dec = dec($enc);

	$num == $dec || ($num.isNaN && $dec.isNaN)
		?? $enc !! Int
}

my multi enc(Num $_ --> Int) {
	state $subnormal = dec(:2<1_00000_1111111111>)..dec(:2<0_00000_1111111111>);
	state $normal    = dec(:2<1_11110_1111111111>)..dec(:2<0_11110_1111111111>);

	when *.isNaN { :2<0_11111_1000000000> }
	when ~(+0e0) { :2<0_00000_0000000000> }
	when ~(-0e0) { :2<1_00000_0000000000> }
	when $subnormal {
		!!!
	}
	when $normal {
		!!!
	}
	when * > 0e0 { :2<0_11111_0000000000> }
	when * < 0e0 { :2<1_11111_0000000000> }
	default { !!! }
}

our sub dec(Int $bits --> Num) {
	my $sign = $bits +> 15;
	my $exp  = ($bits +> 10) +& 0x1F;
	my $frac = $bits +& 0x3FF;

	my $num = do given $exp {
		when 0x1F { $frac ?? NaN !! Inf }
		when 0x00 { $frac ?? frac($frac) * 2e0 ** -14 !! 0e0 }
		default   { (1e0 + frac($frac)) * 2e0 ** ($exp - 15) }
	}

	$sign ?? -$num !! $num
}
