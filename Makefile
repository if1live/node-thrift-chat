all:
	thrift -r --gen js:node shared/tutorial.thrift
