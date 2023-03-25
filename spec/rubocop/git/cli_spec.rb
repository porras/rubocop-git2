describe RuboCop::Git::CLI do
  it "fails with invalid options" do
    expect { subject.run(["--gru\u00DF"]) }
      .to output(/Usage/).to_stderr
      .and raise_error(SystemExit)
  end
end
