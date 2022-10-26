prepare:
	mkdir -p build
	mkdir -p build/test
build: prepare Buffer/test/*.pony
	corral run -- ponyc Buffer/test -o build/test --debug
test: build
	./build/test/test
clean:
	rm -rf build

.PHONY: clean test
