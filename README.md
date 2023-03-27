**NOTE: this is a drop-in replacement for the unmaintained https://github.com/m4i/rubocop-git**

[![Gem Version](https://badge.fury.io/rb/rubocop-git2.svg)](http://badge.fury.io/rb/rubocop-git2)
[![Build Status](https://github.com/jaynetics/rubocop-git2/workflows/tests/badge.svg)](https://github.com/jaynetics/rubocop-git2/actions)

# RuboCop::Git

RuboCop for git diff.

## Installation

Add or install `rubocop-git2`.

## Usage

### Examples

```sh
# check unstaged changes
rubocop-git

# check staged changes
rubocop-git --staged

# positional arguments are passed as git refs to git diff, e.g.:

# check both staged and unstaged changes
rubocop-git HEAD

# check the previous commit
rubocop-git HEAD~1 HEAD

# check changes between two tags
rubocop-git v1.0.0 v1.0.1

# check all changes in a branch in github actions
bundle exec rubocop-git origin/${{ github.base_ref }}
```

### Options

Output of `rubocop-git --help`:

    Usage: rubocop-git [options] [[commit] commit]
        -c, --config FILE                Specify configuration file
        -d, --debug                      Display debug info
        -D, --display-cop-names          Display cop names in offense messages
        -f, --format FORMAT              Set output format (see rubocop --help)
            --hound                      Hound compatibility mode
            --only COP1,COP2             Run only specific cops or departments
        -r, --require FILE               Require Ruby file
            --staged                     Inspect staged changes
            --version                    Display version
