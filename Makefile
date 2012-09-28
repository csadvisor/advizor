test:
	@NODE_PATH=. \
		DEBUG=advisor* \
		./node_modules/.bin/mocha \
			--compilers coffee:coffee-script \
			--reporter spec \
			./test/*.coffee

.PHONY: test

