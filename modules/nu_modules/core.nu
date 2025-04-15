export def read [] {
	bash -c "read entry && echo $entry"
}

export def myhello [] {
	echo "my hello"
}
