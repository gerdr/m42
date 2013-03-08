use v6;

module M42::PASM::Node::Struct;

role Grammar {
	token struct {
		$<tag>=[ struct | union ] \h+ <name=.usertype> \h*
		'{' [ <.sep> | \h+ ]?
		<member=.struct-member>+ % <.sep>
		[ <.sep> | \h+ ]? '}'
	}

	token struct-member {
		<type> \h+ <name=.username>
	}
}

role Parser {
	method struct($/) {
		make self.compose($/, |(~$<tag> => {
			name => ~$<name><name>,
			members => [ $<member>>>.ast ]
		}))
	}

	method struct-member($/) {
		make :member({
			type => ~$<type>,
			name => ~$<name><name>
		}).item
	}
}
