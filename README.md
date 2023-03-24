**NOTE: this is a drop-in replacement for the unmaintained https://github.com/m4i/rubocop-git**

[![Gem Version](https://badge.fury.io/rb/rubocop-git2.svg)](http://badge.fury.io/rb/rubocop-git2)
[![Build Status](https://github.com/jaynetics/rubocop-git2/workflows/tests/badge.svg)](https://github.com/jaynetics/rubocop-git2/actions)

# RuboCop::Git

RuboCop for git diff.

## Installation

Add or install `rubocop-git2`. NOT YET RELEASED - will happen soon!

## Usage

    Usage: rubocop-git [options] [[commit] commit]
        -c, --config FILE                Specify configuration file
        -r, --require FILE               Require Ruby file
        -d, --debug                      Display debug info
        -D, --display-cop-names          Display cop names in offense messages
            --only COP1,COP2             Run only specific cops or departments
            --cached                     git diff --cached
            --staged                     synonym of --cached
            --hound                      Hound compatibility mode
