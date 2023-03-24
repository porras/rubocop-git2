require_relative '../../test_helper'
require 'rubocop/git/runner'

describe RuboCop::Git::Runner do
  it 'exit with violations' do
    options = RuboCop::Git::Options.new
    options.commits = ["v0.0.4", "v0.0.5"]
    _ do
      capture_io do
        RuboCop::Git::Runner.new.run(options)
      end
    end.must_raise(SystemExit)
  end

  it 'enables cops passed via --only flag' do
    options = RuboCop::Git::Options.new
    options.commits = ["v0.0.0"]
    out, _err = capture_io do
      res = RuboCop::Git::Runner.new(exit_on_offence: false).run(options)
      res.must_equal(false)
    end
    _(out).must_match('Style/MutableConstant')
    _(out).wont_match('Style/FrozenStringLiteralComment')
    _(out).wont_match('bad_ruby.txt') # check that default `Include:` applies

    options.rubocop[:only] = ['Style/FrozenStringLiteralComment']
    out, _err = capture_io do
      res = RuboCop::Git::Runner.new(exit_on_offence: false).run(options)
      res.must_equal(false)
    end
    _(out).wont_match('Style/MutableConstant')
    _(out).must_match('Style/FrozenStringLiteralComment')
    _(out).must_match('Rakefile') # check that default `Include:` applies
  end

  it 'fail with no options' do
    _ do
      _out, _err = capture_io do
        RuboCop::Git::Runner.new.run({})
      end
    end.must_raise(RuboCop::Git::Options::Invalid)
  end
end
