use v6;
role M42::PASM::Parser;

method chunk-decl($/) {
	make ~$<name>
}

method label-decl($/) {
	make $<label>.ast
}

method label($/) {
	make {
		local => ?$<dot>,
		name => ~$<name>
	}
}

method reg-name($/) {
	make {
		sigil => '%',
		name => ~$<name>
	}
}

method arg-name($/) {
	make {
		sigil => '$',
		name => ~$<integer>
	}
}

method struct-name($/) {
	make {
		sigil => ':',
		name => ~$<name>
	}
}

method reg-def($/) {
	my $def = $<reg-name>.ast;
	# TODO
	$def<init> = $<reg-init>[0].ast if $<reg-init>;
	make $def;
}

method reg-decl($/) {
	make [ $<reg-def>>>.ast.map({ .<type> = ~$<type>; $_ }) ]
}

method op($/) {
	make {
		name => ~$<op><name>,
		args => [ $<op><value>>>.ast ]
	}
}

method value($/) {
	make $<value>.ast
}

method constant($/) {
	make $<constant>.ast
}

method sizeof($/) {
	make :sizeof(~$<type>).item
}

method integer($/) {
	make :integer(~$/).item
}

method index($/) {
	make $<reg-name>
		?? :register($<index>.ast).item
		!! $<index>.ast
}

method direct-value($/) {
	make :dv($<value>.ast).item
}

method indirect-value($/) {
	make :iv({
		type => ~$<type>,
		base => $<reg-name>.ast,
		index => $<index> ?? $<index>[0].ast !! Nil,
		multi => :sizeof(~$<type>).item
	}).item
}
