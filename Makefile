main: build run

run:
	docker run \
		--interactive \
		--tty \
		--rm \
		"env-ubuntu:latest" \
		"/bin/bash"

build:
	docker build -t env-ubuntu:latest .

rebuild:
	docker build --no-cache -t env-ubuntu:latest .
