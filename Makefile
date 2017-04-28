default: build

SRC = $(shell find src -name "*.ls" -type f | sort)
LIB = $(SRC:src/%.ls=lib/%.js)

lib:
	mkdir lib/

lib/%.js: src/%.ls lib node_modules
	node node_modules/livescript/bin/lsc --output "$(@D)" --compile "$<"

lib/atlas.js: lib/app.js
	node node_modules/browserify/bin/cmd.js -e $< -o $@ --im

lib/index.html: src/index.html lib
	cp src/index.html lib/

lib/styles.css: src/styles.sass lib
	node node_modules/node-sass/bin/node-sass --output-style compressed $< > $@

node_modules:
	npm install

build: $(LIB) lib/index.html lib/styles.css lib/atlas.js

clean:
	rm -rf lib

