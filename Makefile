build:
	mkdir -p build
test: build
	mkdir -p build/test
test/Buffer: test Buffer/test/*.pony
	stable fetch
	stable env ponyc Buffer/test -o build/test --debug
test/execute: test/Buffer
	./build/test/test
clean:
	rm -rf build

.PHONY: clean test
