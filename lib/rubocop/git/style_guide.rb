module RuboCop::Git
# ref. https://github.com/thoughtbot/hound/blob/d2f3933/app/models/style_guide.rb
class StyleGuide
  def initialize(rubocop_options, config_file, override_config_content = nil)
    @rubocop_options = rubocop_options
    @config_file = config_file
    @override_config_content = override_config_content
  end

  def violations(file)
    if ignored_file?(file)
      []
    else
      parsed_source = parse_source(file)
      team = RuboCop::Cop::Team.new(enabled_cops, config, rubocop_options)
      team.inspect_file(parsed_source)
    end
  end

  def inspect
    "#<#{self.class.name}>"
  end

  private

  def enabled_cops
    registry.enabled(config)
  end

  def registry
    @registry ||= begin
      cops = RuboCop::Cop::Registry.all
      if (only = rubocop_options[:only])
        cops = cops.select { |c| c.match?(only) }
      end
      RuboCop::Cop::Registry.new(cops, rubocop_options)
    end
  end

  def ignored_file?(file)
    !included_file?(file) || file.removed? || excluded_file?(file)
  end

  def included_file?(file)
    config.file_to_include?(file.absolute_path)
  end

  def excluded_file?(file)
    config.file_to_exclude?(file.absolute_path)
  end

  def parse_source(file)
    source = RuboCop::ProcessedSource.new(
      file.content,
      config.target_ruby_version,
      file.absolute_path
    )
    source.config = config
    source.registry = registry
    source
  end

  def config
    @config ||= begin
      config = RuboCop::ConfigLoader.configuration_from_file(@config_file)
      combined_config = RuboCop::ConfigLoader.merge(config, override_config)
      RuboCop::Config.new(combined_config, "")
    end
  end

  def rubocop_options
    if config["ShowCopNames"]
      { debug: true }
    else
      {}
    end.merge(@rubocop_options)
  end

  def override_config
    if @override_config_content
      config_content = YAML.load(@override_config_content)
      override_config = RuboCop::Config.new(config_content, "")
      override_config.add_missing_namespaces
      override_config.make_excludes_absolute
      override_config
    else
      {}
    end
  end
end
end
