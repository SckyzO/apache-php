.PHONY = all build

all: build

build:
	docker build -t sckyzo/apache-php:7.3 -t sckyzo/apache-php:latest 7.3

publish:
	docker push sckyzo/apache-php
