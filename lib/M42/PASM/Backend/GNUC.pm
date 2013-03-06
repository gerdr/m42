use v6;
use M42::Compiler;
use M42::PASM::Grammar;
use M42::PASM::Composer;

class M42::PASM::Backend::GNUC {
	also does M42::Compiler;

	has $.grammar = M42::PASM::Grammar;
	has $.parser = M42::PASM::Composer.new;

	method dump {
		print "#include <m42/base.h>\n",
			self.parser.world.chunks.values.map(&chunk)
	}

	my %TYPEMAP = (
		'i8' => {
			ctype => 'uint8_t',
			vtype => Nil,
		},
		'i64' => {
			ctype => 'uint64_t',
			vtype => 'u',
		},
		'f64' => {
			ctype => 'double',
			vtype => 'f',
		},
		'ptr' => {
			ctype => 'void*',
			vtype => 'p',
		},
		'val' =>  {
			ctype => 'm42_val',
			vtype => Nil,
		},
		'size' => {
			ctype => 'size_t',
			vtype => 'sz',
		},
		'ptrdiff' => {
			ctype => 'ptrdiff_t',
			vtype => 'pd',
		}
	);

	my %BINMAP = :add<+>, :mul<*>, :fadd<+>;

	my sub chunk(Chunk $chunk (:$name, :@paras, :%regs, :%labels, *%)) {
		my $paras = @paras.kv.map(-> $index, $reg {
			"{ %TYPEMAP{%regs{$reg}.type}<ctype> } a_$index"
		}).join(', ') || 'void';

		my @statements := gather {
			take labels($chunk) if %labels;
			take registers($chunk) if %regs;
			take blocks($chunk);
		}

		"\nm42_val $name\($paras)\n\{\n\t {
			@statements.join("\n\t")
		}\n\}\n"
	}

	my sub labels(Chunk $ (:$name, :%labels, *%)) {
		my @labels = %labels.values>>.name;
		"static const void *const LABELS_[] = \{ {
			@labels.map({ "&&{ $name }__$_" }).join(', ')
		} \};",
		"__asm__ __volatile__ (\"{
			@labels.map({ ".global { $name }__$_" }).join('\n')
		}\");",
		"(void)LABELS_;", ''
	}

	my sub registers(Chunk $ (:%regs, :@paras, *%)) {
		my @regs = %regs.values;
		my %paras = @paras.pairs>>.invert;
		@regs.map(-> $ (:$name, :$type) {
			my $ctype = %TYPEMAP{$type}<ctype>;
			$name ~~ %paras
				?? "register $ctype r_$name = a_{ %paras{$name} };"
				!! "register $ctype r_$name;"
		}), ''
	}

	my sub blocks(Chunk $chunk (:$name, :%labels, :@ops, :%regs, *%)) {
		my %map = %labels.values.map({; .offset => .name });
		@ops.kv.map(-> $offset, $op {
			my $code = op($chunk, $op);
			if $offset ~~ %map {
				my $label = "{ $name }__{ %map{$offset} }";
				"\n$label:\n\t__asm__ __volatile__ (\"$label:\");", $code
			}
			else { $code }
		});
	}

	my multi val(Chunk $chunk, $ (:$conv, Regval :$value)) {
		"(m42_val)\{ .{ regvtype($chunk, $value) } "
			~ "= { regval($chunk, $value) } \}"
	}

	my multi regval(Chunk $chunk, Regval $ (:$name)) {
		"r_$name"
	}

	my multi regvtype(Chunk $chunk, Regval $ (:$name)) {
		%TYPEMAP{$chunk.regs{$name}.type}<vtype>
	}

	my multi arg(Chunk $chunk, Arg $ (:$conv, IV :$value)) {
		# TODO conversion
		iv($chunk, $value)
	}

	my multi arg(Chunk $chunk, Arg $ (:$conv, Regval :$value)) {
		# TODO conversion
		regval($chunk, $value)
	}

	my multi arg(Chunk $chunk, Arg $arg) {
		die $arg.perl
	}

	my multi iv(Chunk $chunk, IV $ (:$type, Regval :$base, Nil :$offset)) {
		my $ctype = %TYPEMAP{$type}<ctype>;
		"*($ctype*){ regval($chunk, $base) }"
	}

	my multi iv(Chunk $chunk, IV $ (:$type, Regval :$base, Any :$offset)) {
		my $ctype = %TYPEMAP{$type}<ctype>;
		my $index = do given $offset {
			when Intval { $offset.value }
			when Regval { regval($chunk, $offset) }
			default { die $offset.perl }
		}

		"(($ctype*){ regval($chunk, $base) })[{ $index }]"
	}

	my multi op(Chunk $chunk, Op $ (:$name where 'ret', :@args)) {
		"return { val($chunk, @args[0]) };"
	}

	my multi op(Chunk $chunk, Op $ (:$name where 'jmp', :@args)) {
		"goto *{ arg($chunk, @args[0]) };";
	}

	my multi op(Chunk $chunk, Op $ (:$name where any(%BINMAP.keys), :@args)) {
		sprintf "%s = %s { %BINMAP{$name} } %s;",
			@args.map({ arg($chunk, $_) })
	}

	my multi op(Chunk $chunk, Op $ (:$name where any(<mov lea>), :@args)) {
		my $prefix = do given $name {
			when 'mov' { '' }
			when 'lea' { '&' }
		}

		"{ arg($chunk, @args[0]) } = { $prefix }{ arg($chunk, @args[1]) };"
	}

	my multi op(Chunk $chunk, $ (:$name, :@args)) {
		"#error \"unsupported op '$name'\""
	}
}
