require 'shellwords'

module RuboCop
  module Git
    # ref. https://github.com/thoughtbot/hound/blob/d2f3933/app/services/build_runner.rb
    class Runner
      def initialize(exit_on_offence: true)
        @exit_on_offence = exit_on_offence
      end

      def run(options = {})
        options = Options.new(options) unless options.is_a?(Options)

        @options = options
        @files = DiffParser.parse(git_diff(options))

        display_violations($stdout)

        ok = violations_with_valid_offences.none?
        exit(1) if @exit_on_offence && !ok
        ok
      end

      private

      def violations
        @violations ||= style_checker.violations
      end

      def violations_with_valid_offences
        @violations_with_valid_offences ||= violations.select { |v| valid_offences(v).any? }
      end

      def valid_offences(violation)
        offenses = violation.offenses
        offenses = offenses.reject(&:disabled?) if offenses.first.respond_to?(:disabled?)
        offenses.compact.sort.freeze
      end

      def style_checker
        StyleChecker.new(
          pull_request.pull_request_files,
          @options.rubocop,
          @options.config_file,
          pull_request.config
        )
      end

      def pull_request
        @pull_request ||= PseudoPullRequest.new(@files, @options)
      end

      def git_diff(options)
        args = %w(diff --diff-filter=AMCR --find-renames --find-copies)

        args << '--cached' if options.cached
        args << options.commit_first.shellescape if options.commit_first
        args << options.commit_last.shellescape if options.commit_last

        `git #{args.join(' ')}`
      end

      def display_violations(io)
        formatter = @options.format.new(io)
        formatter.started(@files)

        violations.map do |violation|
          formatter.file_finished(violation.filename, valid_offences(violation))
        end

        formatter.finished(@files.map(&:filename).freeze)
      end
    end
  end
end
