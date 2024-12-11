#!/bin/bash
U='./urls'
T='./urls.temp'

touch "$T"

while IFS= read -r url; do
	if curl --output /dev/null --silent --head --fail "$url"; then
		echo "$url" >> "$T"
	else
		echo "unaccessable url: $url"
	fi
done < "$U"


