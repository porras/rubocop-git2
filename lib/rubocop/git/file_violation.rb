# ref. https://github.com/thoughtbot/hound/blob/d2f3933/app/models/file_violation.rb
RuboCop::Git::FileViolation = Struct.new(:filename, :offenses)
