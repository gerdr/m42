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

# assumes big-endian byte order
role Reader {
	has $!buf;
	has $!pos;

	submethod BUILD(:$buf, :$pos) {
		$!buf = $buf;
		$!pos = $pos;
	}

	method read-byte {
		$!buf[$!pos++]
	}

	method read-uint16 {
		self.read-byte +< 8 +| self.read-byte
	}

	method read-int16 {
		my $bits = self.read-uint16;
		$bits <= 0x7FFF ?? $bits !! $bits - 0x10000
	}

	method read-float16 {
		float16::dec(self.read-uint16)
	}

	method read-bigint {
		my $head = self.read-byte;
		my $sign = $head +> 7;
		my $count = $head +& 0x7F;
		my $int = 0;
		$int = ($int +< 8) +| self.read-byte while $count--;
		$sign ?? -$int !! $int
	}

	method read-bigfloat {
		die 'TODO'
	}
}

class Parser does Reader {
	method parse-magic {
		unless self.read-byte == ord('m')
			&& self.read-byte == 0x42
			&& self.read-byte == 0xBC {
			take :fail('incorrect magic number').item;
			last;
		}

		take :version(self.read-byte).item;
	}

	method parse-op {
		my $code = self.read-byte;
		my $args = self.read-byte;
		my @args = do gather while $args > 0 {
			take do given $args mod 6 {
				when REGISTER { :register(self.read-uint16).item }
				when CONSTANT { :constant(self.read-uint16).item }
				when IMM_INT { :int(self.read-int16).item }
				when IMM_FLOAT { :float(self.read-float16).item }
				when IMM_SYMBOL { :symbol(self.read-uint16).item }
				default { die 'unsupported op argument' }
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
