use v6;
use float16;
module M42::Bytecode;

enum Args <
	VOID
	REGISTER
	CONSTANT
	IMM_INT
	IMM_FLOAT
	IMM_SYMBOL
>;

class Parser {
	has $.buf;
	has $.pos;

	# big-endian uint
	method read-uint {
		$!buf[$!pos++] +< 8 +| $!buf[$!pos++]
	}

	# two's complement int
	method read-int {
		my $bits = self.read-uint;
		$bits <= 0x7FFF ?? $bits !! $bits - 0x10000
	}

	# half-precision float
	method read-float {
		float16::dec(self.read-uint)
	}

	method parse-magic {
		unless $!buf[$!pos++] == ord('m')
			&& $!buf[$!pos++] == 0x42
			&& $!buf[$!pos++] == 0xBC {
			take :fail('incorrect magic number').item;
			last;
		}

		take :version($!buf[$!pos++]).item;
	}

	method parse-op {
		my $code = $!buf[$!pos++];
		my $args = $!buf[$!pos++];
		my @args;
		while $args > 0 {
			given $args mod 6 {
				when REGISTER {
					@args.push(:register(self.read-uint).item)
				}
				when CONSTANT {
					@args.push(:constant(self.read-uint).item)
				}
				when IMM_INT {
					@args.push(:int(self.read-int).item)
				}
				when IMM_FLOAT {
					@args.push(:float(self.read-float).item)
				}
				when IMM_SYMBOL {
					@args.push(:symbol(self.read-uint).item)
				}
				default {
					die 'unsupported op argument'
				}
			}
			$args div= 6
		}

		take :op({ :$code, :@args }).item
	}

	method parse {
		gather loop {
			self.parse-magic;
			self.parse-op;
			last;
		}
	}
}

our sub parse($buf, $offset = 0) {
	Parser.new(:$buf, :pos($offset)).parse
}
