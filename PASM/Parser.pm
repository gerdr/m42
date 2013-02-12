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
	make ~$<name>
}

method reg-def($/) {
	make {
		name => $<reg-name>.ast
	}
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
