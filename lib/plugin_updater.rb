class PluginUpdater
  BANNED_PLUGINS = %w(
    lita-boobs
    lita_chm
    lita-console
    lita-kitchen
    lita-slack-handler
  )
  RUBYGEMS_API_URL = 'https://rubygems.org/api/v1/gems/lita/reverse_dependencies.json'

  attr_accessor :plugins

  def initialize
    self.plugins = {}
  end

  def update
    fetch_reverse_dependencies
    determine_plugin_types
    update_plugins
  end

  private

  def determine_plugin_types
    pwd = Dir.pwd
    Dir.mktmpdir do |tmpdir|
      Dir.chdir(tmpdir)
      fetch_gemspecs
      read_gemspecs
    end
  ensure
    Dir.chdir(pwd)
  end

  def fetch_gemspecs
    system("gem fetch #{plugins.keys.join(' ')} 1>/dev/null")
  end

  def fetch_reverse_dependencies
    response = Faraday.get(RUBYGEMS_API_URL)
    plugin_names = MultiJson.load(response.body)
    plugin_names = plugin_names.reject { |name| BANNED_PLUGINS.include?(name) }
    plugin_names.each { |name| plugins[name] = nil }
  end

  def homepage(spec)
    if spec.homepage.blank?
      "https://rubygems.org/gems/#{spec.name}"
    else
      spec.homepage
    end
  end

  def plugins_with_attributes
    plugins.select { |name, attributes| !attributes.nil? }
  end

  def read_gemspecs
    Dir['*'].each do |file|
      Open4.popen4('sh') do |pid, stdin, stdout, stderr|
        stdin.puts("gem spec #{file}")
        stdin.close
        spec = YAML.load(stdout.read.chomp)
        plugins[spec.name] = {
          plugin_type: spec.metadata["lita_plugin_type"],
          description: spec.description,
          authors: spec.authors.join(', '),
          version: spec.version.to_s,
          requirements_list: requirements_list_for(spec),
          homepage: homepage(spec)
        }
      end
    end
  end

  def requirements_list_for(spec)
    dep = spec.dependencies.find { |dep| dep.name == 'lita' }
    dep.requirements_list.join(', ')
  end

  def update_plugins
    plugins_with_attributes.each do |name, attributes|
      plugin = Plugin.where(name: name).first

      if plugin
        plugin.update_attributes!(attributes)
      else
        Plugin.create!(attributes.merge(name: name))
      end
    end
  end
end

