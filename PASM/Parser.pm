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

method op($/) {
	make {
		name => ~$<op><name>,
		args => [ $<op><value>>>.ast ]
	}
}

method value($/) {
	make $<value>.ast
}
