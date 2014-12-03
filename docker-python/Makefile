all:
	(cd src && landslide presentation.md -o > $(shell pwd)/presentation.html)

watch:
	if which fswatch > /dev/null; then
		fswatch ./src make
	else
		while inotifywait -re close_write ./src; do make; done
	fi

clean:
	rm presentation.html
