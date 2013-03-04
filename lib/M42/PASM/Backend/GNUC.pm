use v6;
use M42::Compiler;
use M42::PASM::Grammar;
use M42::PASM::Composer;

class M42::PASM::Backend::GNUC {
	also does M42::Compiler;

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

	my sub chunk($chunk (:$name, :@paras, :%regs, :%labels, *%)) {
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

	my sub labels($ (:$name, :%labels, *%)) {
		my @labels = %labels.values>>.name;
		"static const void *const LABELS_[] = \{ {
			@labels.map({ "&&{ $name }__$_" }).join(', ')
		} \};",
		"__asm__ __volatile__ (\"{
			@labels.map({ ".global $_" }).join('\n')
		}\");",
		"(void)LABELS_;", ''
	}

	my sub registers($ (:%regs, :@paras, *%)) {
		my @regs = %regs.values;
		my %paras = @paras.pairs>>.invert;
		@regs.map(-> $ (:$name, :$type) {
			"register { %TYPEMAP{$type}<ctype> } r_{ $name }{
				$name ~~ %paras ?? " = a_{ %paras{$name} }" !! ''
			};"
		}), ''
	}

	my sub blocks($ (:name($chunk), :%labels, :@ops, :%regs, *%)) {
		my %map = %labels.values.map({; .offset => .name });
		@ops.kv.map(-> $offset, $op {
			my $code = $op.name;
			if $offset ~~ %map {
				my $label = "{ $chunk }__{ %map{$offset} }";
				"\n$label:\n\t__asm__ __volatile__ (\"$label:\");", $code
			}
			else { $code }
		});
	}

	has $.grammar = M42::PASM::Grammar;
	has $.parser = M42::PASM::Composer.new;

	method dump {
		print "#include <m42/base.h>\n",
			self.parser.world.chunks.values.map(&chunk)
	}
}

#multi compile-constant($ (:$key where 'integer', :$value)) {
#	$value
#}
#
#multi compile-constant($ (:$key, *%)) {
#	die "unsupported constant type '$key'"
#}
#
#multi compile-base($ (:$sigil where '%', :$name, *%)) {
#	"r_$name"
#}
#
#multi compile-base($ (:$sigil, *%)) {
#	die "unsupported argument sigil '$sigil'"
#}
#
#multi compile-arg-to-val($arg (:$key where 'dv',
#	:$value (:$sigil where '%', :$name,
#		:$type where %TYPEMAP{$type}<vtype> eq any(<i u p f>), *%))) {
#	my $vtype = %TYPEMAP{$type}<vtype>;
#	"(m42_val)\{ .$vtype = { compile-arg $arg } \}"
#}
#
#multi compile-index($ (:$key where 'register', :$value)) {
#	compile-base $value
#}
#
#multi compile-index($index) {
#	compile-constant $index
#}
#
#multi compile-arg($ (:$key where 'iv', :value($_))) {
#	"(({ %TYPEMAP{.<type>}<ctype> }*){ compile-base .<base> })[{
#		.<index> ?? compile-index(.<index>) !! 0
#	}]"
#}
#
#multi compile-arg($arg (:$key where 'dv', :value($_))) {
#	compile-base $_
#}
#
#multi compile-op($op (:$name where 'jmp', *%)) {
#	"goto *{ compile-arg $op<args>[0] };";
#}
#
#multi compile-op($op (:$name where 'ret', *%)) {
#	"return { compile-arg-to-val $op<args>[0] };"
#}
#
#multi compile-op($op (:$name where 'lea', *%)) {
#	"{ compile-arg $op<args>[0] } = \&{ compile-arg $op<args>[1] };";
#}
#
#multi compile-op($op (:$name where 'mov', *%)) {
#	"{ compile-arg $op<args>[0] } = { compile-arg $op<args>[1] };";
#}
#
#multi compile-op($ (:$name where 'add', :@args)) {
#	sprintf '%s = %s + %s;', @args.map(&compile-arg)
#}
#
#multi compile-op($ (:$name where 'mul', :@args)) {
#	sprintf '%s = %s * %s;', @args.map(&compile-arg)
#}
#
#multi compile-op($ (:$name where 'fadd', :@args)) {
#	sprintf '%s = %s + %s;', @args.map(&compile-arg)
#}
#
#multi compile-op($op (:$name, *%)) {
#	die "unsupported op '$op<name>'"
#}
#
#multi compile-code($ (:key($type) where 'op', :value($op))) {
#	compile-op $op
#}
#
#multi compile-code($ (:key($type), :$value)) {
#	die "unsupported code type $type"
#}
#
