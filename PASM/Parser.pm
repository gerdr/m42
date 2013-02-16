use v6;
role PASM::Parser;

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

method reg-def($/) {
	make $<reg-name>.ast
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

method number($/) {
	make :number(~$/).item
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
