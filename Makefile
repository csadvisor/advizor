test:
	@NODE_PATH=/home/sholbert/Dropbox/Developer/course_advisor/advizor \
		./node_modules/.bin/mocha \
			--compilers coffee:coffee-script \
			--reporter spec \
			./test/*.coffee

.PHONY: test

