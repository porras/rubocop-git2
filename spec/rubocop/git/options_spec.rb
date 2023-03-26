describe RuboCop::Git::Options do
  it "fails with no options" do
    expect { RuboCop::Git::Options.new({}) }.to raise_error(/invalid/)
  end

  it "fails with unknown options" do
    expect { RuboCop::Git::Options.new({ foo: 1 }) }.to raise_error(/invalid/)
  end

  it "can pass string hash options" do
    RuboCop::Git::Options.new("rubocop" => {}, "commits" => [])
  end

  it "can pass symbol hash options" do
    RuboCop::Git::Options.new(rubocop: {}, commits: [])
  end
end
