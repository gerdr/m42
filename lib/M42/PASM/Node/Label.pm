use v6;

module M42::PASM::Node::Label;

role Grammar {
	token label {
		'@.' <name> ':'
	}
}

role Parser {
	method label($/) {
		make self.compose($/, label => ~$<name>)
	}
}
