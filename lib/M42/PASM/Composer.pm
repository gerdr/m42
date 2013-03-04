use v6;
use M42::PASM::Nodes;

my class World {}

class M42::PASM::Composer {
	also does M42::PASM::Nodes::Parser;

	has $.world = World.new;

	multi method compose($/, *%args where 1) {
		%args.pairs[0]
	}
}

#role ASG {
#	method regdecl($/) {
#		my ($type, $defs) = callsame.value<type defs>;
#		my $chunk = self.asg.chunk;
#
#		sink for $defs>>.value.list {
#			my ($name, $init) = .<name init>;
#			self.cry($/, 'register redeclaration')
#				if $name ~~ $chunk.regs;
#
#			$chunk.regs{$name} = $type;
#
#			next unless defined $init;
#			given $init.key {
#				when 'arg' {
#					my $arg = +$init.value;
#					self.cry($/, 'argument redeclaration')
#						if defined $chunk.args[$arg];
#
#					$chunk.args[$arg] = $name;
#				}
#			}
#		}
#	}
#}
