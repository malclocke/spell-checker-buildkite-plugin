#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

@test "Default pattern" {
  stub docker "run --rm -v $PWD:/workdir tmaier/markdown-spellcheck:latest --report \"*.md\" : cat tests/fixtures/default-pattern"
  stub buildkite-agent 'annotate --style "success" : echo "Annotated success"'

  run "$PWD/hooks/post-checkout"

  assert_success
  assert_line ">> 1 file is free from spelling errors"

  unstub docker
  unstub buildkite-agent
}

@test "Custom pattern with failures" {
  export BUILDKITE_PLUGIN_SPELL_CHECKER_PATTERN="*.bad.md"

  stub docker "run --rm -v $PWD:/workdir tmaier/markdown-spellcheck:latest --report \"*.bad.md\" : cat tests/fixtures/custom-pattern-with-failures ; exit 1"
  stub buildkite-agent 'annotate --style "warning" : echo "Annotated error"'

  run "$PWD/hooks/post-checkout"

  assert_success
  assert_line ">> 6 spelling errors found in 1 file"

  unstub docker
  unstub buildkite-agent
}

@test "Custom pattern without failures" {
  export BUILDKITE_PLUGIN_SPELL_CHECKER_PATTERN="*.good.md"

  stub docker "run --rm -v $PWD:/workdir tmaier/markdown-spellcheck:latest --report \"*.good.md\" : cat tests/fixtures/default-pattern"
  stub buildkite-agent 'annotate --style "success" : echo "Annotated success"'

  run "$PWD/hooks/post-checkout"

  assert_success
  assert_line ">> 1 file is free from spelling errors"

  unstub docker
  unstub buildkite-agent
}
