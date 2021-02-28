## Buildkite Spell Checker

This plugin runs [markdown-spellcheck](https://hub.docker.com/r/tmaier/markdown-spellcheck/)
on all the markdown files in your repository.

A warning annotation is added to the build if any spelling errors are found.

```yml
steps:
  - command: ls
    plugins:
      - malclocke/spell-checker#v1.0.0:
          pattern: '**/*.md'
```
