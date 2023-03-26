class RuboCop::Git::DiffParser
  def self.parse(diff)
    new.parse(diff)
  end

  def parse(diff) # rubocop:disable Metrics/MethodLength
    files    = []
    in_patch = false

    diff.each_line do |line|
      case line
      when /^diff --git/
        in_patch = false
      when %r{^\+{3} b/(?<path>[^\t\n\r]+)}
        files << RuboCop::Git::PseudoResource.new(Regexp.last_match[:path])
      when /^@@/
        in_patch = true
      end

      files.last.patch << line if in_patch
    end

    files
  end
end
