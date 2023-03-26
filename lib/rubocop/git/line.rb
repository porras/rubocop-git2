# similar to https://github.com/thoughtbot/hound/blob/d2f3933/app/models/line.rb
RuboCop::Git::Line = Struct.new(:content, :line_number, :patch_position) do
  def ==(other)
    content == other.content
  end
end
