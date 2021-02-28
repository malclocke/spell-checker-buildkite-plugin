FIXTURE_DEPS = hooks/command Makefile

SPELLCHECK_COMAND = docker run --rm -v $(CURDIR):/workdir tmaier/markdown-spellcheck:latest --report

test:
	docker-compose run --rm tests

lint:
	docker-compose run --rm lint

fixtures: tests/fixtures/default-pattern \
					tests/fixtures/custom-pattern-with-failures \
					tests/fixtures/custom-pattern-without-failures


tests/fixtures/default-pattern: $(FIXTURE_DEPS)
	-$(SPELLCHECK_COMAND) "*.md" > $@

tests/fixtures/custom-pattern-with-failures: $(FIXTURE_DEPS)
	-$(SPELLCHECK_COMAND) "**/*.bad.md" > $@

tests/fixtures/custom-pattern-without-failures: $(FIXTURE_DEPS)
	-$(SPELLCHECK_COMAND) "**/*.good.md" > $@
