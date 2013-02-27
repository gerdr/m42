use v6;
module M42::PASM;

enum Types <
	i8 i16 i32 i64
	f16 f32 f64
	ptr ref val
	char int short long llong
	float double ldouble
	size ptrdiff intmax intptr
>;

my @OPS;
my %OPS;
my @OPS_BY_ARITY;

sub op($arity, *@ops) {
	@OPS.push(@ops);
	@OPS_BY_ARITY[$arity].push(@ops);
}

# op defs
op 0, <noop>;
op 1, <jmp ret>;
op 2, <lea mov>;
op 3, <add mul fadd fmul>;

%OPS{@OPS} = ^@OPS;

our sub types { Types.enums.keys }

our sub opcode(*@ops) { %OPS{@ops} }

our proto ops(|) { * }
multi ops($arity) { @OPS_BY_ARITY[$arity] }
multi ops { @OPS }
