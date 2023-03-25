# c.f. https://github.com/thoughtbot/hound/blob/d2f3933/app/models/commit_file.rb
class RuboCop::Git::CommitFile
  def initialize(file, commit)
    @file = file
    @commit = commit
  end

  def absolute_path
    @file.absolute_path
  end

  def filename
    @file.filename
  end

  def content
    @content ||= unless removed?
                   @commit.file_content(filename)
                 end
  end

  def relevant_line?(line_number)
    !modified_line_at(line_number).nil?
  end

  def removed?
    @file.status == 'removed'
  end

  def modified_lines
    @modified_lines ||= patch.changed_lines
  end

  def modified_line_at(line_number)
    modified_lines[line_number]
  end

  private

  def patch
    RuboCop::Git::Patch.new(@file.patch)
  end
end
