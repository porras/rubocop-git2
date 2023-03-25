require_relative '../git'
require 'optparse'

class RuboCop::Git::CLI
  def run(args = ARGV.dup)
    @options = RuboCop::Git::Options.new
    parse_arguments(args)
    RuboCop::Git::Runner.new.run(@options)
  end

  private

  def parse_arguments(args)
    args << '--staged' if args.delete('--cached') # support synonymous flag
    @options.commits = option_parser.parse(args)
  rescue OptionParser::InvalidOption, Options::Invalid => e
    warn "ERROR: #{e.message}"
    $stderr.puts
    warn option_parser
    exit 1
  end

  # rubocop:disable Metrics
  def option_parser
    @option_parser ||= OptionParser.new do |opt|
      opt.banner << ' [[commit] commit]'

      opt.on('-c', '--config FILE',
             'Specify configuration file') do |config|
        @options.config = config
      end

      opt.on('-d', '--debug', 'Display debug info') do
        @options.rubocop[:debug] = true
      end

      opt.on('-D', '--display-cop-names',
             'Display cop names in offense messages') do
        @options.rubocop[:display_cop_names] = true
      end

      opt.on('-f', '--format FORMAT',
             'Set output format (see rubocop --help)') do |format|
        @options.format = format
      end

      opt.on('--hound', 'Hound compatibility mode') do
        @options.hound = true
      end

      opt.on('--only COP1,COP2', Array,
             'Run only specific cops or departments') do |args|
        @options.rubocop[:only] = args
      end

      opt.on('-r', '--require FILE',
             'Require Ruby file') do |file|
        require file
      end

      opt.on('--staged', 'Inspect staged changes') do
        @options.cached = true
      end

      opt.on('--version', 'Display version') do
        puts RuboCop::Git::VERSION
        exit 0
      end
    end
  end
  # rubocop:enable Metrics
end
