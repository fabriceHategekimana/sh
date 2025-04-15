#!/home/fabrice/.cargo/bin/nu

export def "assert equal" [A, B, message] {
	if $A != $B {
	  error make -u {msg: $message}
	}
}

