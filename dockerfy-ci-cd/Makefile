all:
	(cd src && landslide presentation.md -o > $(shell pwd)/presentation.html)

watch:
	fswatch ./src make

clean:
	rm presentation.html
