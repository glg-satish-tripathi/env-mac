project=env-ubuntu
main: build run

run:
	docker run \
		--interactive \
		--tty \
		--rm \
		"$(project):latest" \
		"/bin/bash"

build:
	docker build \
		--network host \
		--tag "$(project):latest" \
		.

rebuild:
	docker build \
		--network host \
		--tag "$(project):latest" \
		--no-cache \
		.

lint:
	docker pull "github/super-linter:latest"
	docker run \
		-e RUN_LOCAL=true \
		-e FILTER_REGEX_EXCLUDE='home/.vim/pack/.*' \
		-v "$(shell pwd):/tmp/lint:ro" \
		"github/super-linter" 2>&1 | tee "/tmp/super-linter.log"

lint_one:
ifdef file
	docker pull "github/super-linter:latest"
	docker run \
		-e RUN_LOCAL=true \
		-e FILTER_REGEX_EXCLUDE='home/.vim/pack/.*' \
		-v "$(shell pwd)/$(file):/tmp/lint/$(file):ro" \
		"github/super-linter" 2>&1 tee "/tmp/super-linter.log"
else
	@echo "No file provided"
endif

.PHONEY: main build rebuild run lint lint_one
