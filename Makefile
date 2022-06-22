.PHONY = all build

all: build

build:
	docker build -t sckyzo/apache-php:8 -t sckyzo/apache-php:latest 8

publish:
	docker push sckyzo/apache-php
