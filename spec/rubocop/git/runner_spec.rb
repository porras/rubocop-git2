describe RuboCop::Git::Runner do
  it "exits with violations" do
    options = RuboCop::Git::Options.new
    options.commits = ["v0.0.4", "v0.0.5"]
    expect { RuboCop::Git::Runner.new.run(options) }
      .to output(%r{Layout/TrailingWhitespace}).to_stdout
      .and raise_error(SystemExit)
  end

  it "enables cops passed via --only flag" do
    # WITHOUT only flag
    options = RuboCop::Git::Options.new
    options.commits = ["v0.0.0"]
    output = RSpec::Matchers::BuiltIn::CaptureStdout.capture -> do
      res = RuboCop::Git::Runner.new(exit_on_offence: false).run(options)
      expect(res).to eq false
    end
    # check that rubocop's default `Include:` applies
    expect(output).not_to include 'bad_ruby.txt'
    # check that cop disabled via rubocop.yml isn't used
    expect(output).not_to include 'Style/FrozenStringLiteralComment'
    # check that enabled cop is used
    expect(output).to include 'Style/MutableConstant'

    # WITH only flag
    options.rubocop[:only] = ["Style/FrozenStringLiteralComment"]
    output = RSpec::Matchers::BuiltIn::CaptureStdout.capture -> do
      res = RuboCop::Git::Runner.new(exit_on_offence: false).run(options)
      expect(res).to eq false
    end
    # check that rubocop's default `Include:` applies
    expect(output).to include 'Rakefile'
    # check that passed cop is used despite being disabled in rubocop.yml
    expect(output).to include 'Style/FrozenStringLiteralComment'
    # check that other enabled cop isn't used
    expect(output).not_to include 'Style/MutableConstant'
  end

  it "fails with no options" do
    expect { RuboCop::Git::Runner.new.run({}) }.to raise_error(/invalid/)
  end
end
