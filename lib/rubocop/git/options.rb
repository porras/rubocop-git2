class RuboCop::Git::Options
  class Invalid < StandardError; end

  HOUND_DEFAULT_CONFIG_FILE =
    File.expand_path('../../../hound.yml', __dir__)

  attr_accessor :config
  attr_reader   :cached, :hound, :rubocop, :format

  def initialize(hash_options = nil)
    @config  = nil
    @cached  = false
    @hound   = false
    @format = RuboCop::Formatter::ClangStyleFormatter
    @rubocop = {}
    @commits = []

    from_hash(hash_options) if hash_options
  end

  def cached=(cached_)
    if cached_ && !@commits.empty?
      raise Invalid, 'cached and commit cannot be specified together'
    end

    @cached = !!cached_
  end

  def hound=(hound_)
    @hound = !!hound_
  end

  def rubocop=(rubocop_)
    unless rubocop_.nil? || rubocop_.is_a?(Hash)
      raise Invalid, "invalid rubocop: #{rubocop_.inspect}"
    end

    @rubocop = rubocop_.to_h
  end

  def commits=(commits)
    unless commits.is_a?(Array) && commits.length <= 2
      raise Invalid, "invalid commits: #{commits.inspect}"
    end
    if !commits.empty? && cached
      raise Invalid, 'cached and commit cannot be specified together'
    end

    @commits = commits
  end

  def format=(format)
    formatters =
      RuboCop::Formatter::FormatterSet::BUILTIN_FORMATTERS_FOR_KEYS
    formatter_key = formatters.keys.find do |key|
      key.start_with?(format)
    end
    @format = formatters[formatter_key] if formatter_key
  end

  def config_file
    if hound
      HOUND_DEFAULT_CONFIG_FILE
    elsif config
      config
    elsif File.exist?(RuboCop::ConfigLoader::DOTFILE)
      RuboCop::ConfigLoader::DOTFILE
    else
      RuboCop::ConfigLoader::DEFAULT_FILE
    end
  end

  def commit_first
    @commits.first
  end

  def commit_last
    @commits.length == 1 ? false : @commits.last
  end

  private

  def from_hash(hash_options)
    hash_options = hash_options.dup
    %w[config cached hound rubocop commits].each do |key|
      value = hash_options.delete(key) || hash_options.delete(key.to_sym)
      public_send("#{key}=", value)
    end
    return if hash_options.empty?

    raise Invalid, "invalid keys: #{hash_options.keys.join(' ')}"
  end
end
