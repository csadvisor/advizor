test:
	@NODE_PATH=. \
		./node_modules/.bin/mocha \
			--compilers coffee:coffee-script/register \
			--reporter spec \
			./test/*.coffee

.PHONY: test

