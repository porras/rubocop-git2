require 'rubocop'

module RuboCop::Git
  autoload :CLI,               "#{__dir__}/git/cli"
  autoload :Commit,            "#{__dir__}/git/commit"
  autoload :CommitFile,        "#{__dir__}/git/commit_file"
  autoload :DiffParser,        "#{__dir__}/git/diff_parser"
  autoload :FileViolation,     "#{__dir__}/git/file_violation"
  autoload :Line,              "#{__dir__}/git/line"
  autoload :Options,           "#{__dir__}/git/options"
  autoload :Patch,             "#{__dir__}/git/patch"
  autoload :PseudoPullRequest, "#{__dir__}/git/pseudo_pull_request"
  autoload :PseudoResource,    "#{__dir__}/git/pseudo_resource"
  autoload :Runner,            "#{__dir__}/git/runner"
  autoload :StyleChecker,      "#{__dir__}/git/style_checker"
  autoload :StyleGuide,        "#{__dir__}/git/style_guide"
  autoload :VERSION,           "#{__dir__}/git/version"
end
