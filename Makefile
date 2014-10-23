test:
	@NODE_PATH=. \
		./node_modules/.bin/mocha \
			--compilers coffee:coffee-script \
			--reporter spec \
			./test/*.coffee

.PHONY: test

