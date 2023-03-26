# copy from https://github.com/thoughtbot/hound/blob/5269fa5/app/models/patch.rb
class RuboCop::Git::Patch
  RANGE_INFORMATION_LINE = /^@@ .+\+(?<line_number>\d+),/.freeze
  MODIFIED_LINE = /^\+(?!\+|\+)/.freeze
  NOT_REMOVED_LINE = /^[^-]/.freeze

  def initialize(body)
    @body = body || ''
  end

  def changed_lines # rubocop:disable Metrics/MethodLength
    line_number = 0
    lines.
      each_with_object({}).
      with_index do |(content, hash), patch_position|
      case content
      when RANGE_INFORMATION_LINE
        line_number = Regexp.last_match[:line_number].to_i
      when MODIFIED_LINE
        line = RuboCop::Git::Line.new(content, line_number, patch_position)
        hash[line_number] = line
        line_number += 1
      when NOT_REMOVED_LINE
        line_number += 1
      end
    end
  end

  private

  def lines
    @body.each_line
  end
end
