require 'rake_dependencies'
require 'rake_leiningen/version'

module RakeLeiningen
  def self.define_installation_tasks(opts = {})
    namespace = opts[:namespace] || :leiningen
    version = opts[:version] || '2.9.1'
    path = opts[:path] || File.join('vendor', 'leiningen')

    RakeDependencies::Tasks::All.new do |t|
      t.namespace = namespace
      t.dependency = 'lein'
      t.version = version
      t.path = path
      t.type = :uncompressed

      t.uri_template = "https://raw.githubusercontent.com/technomancy/leiningen/<%= @version %>/bin/lein"
      t.file_name_template = "lein"

      t.needs_fetch = lambda do |parameters|
        binary = File.join(parameters[:path], parameters[:binary_directory], 'lein')
        version_string = StringIO.new

        if File.exist?(binary)
          Lino::CommandLineBuilder.for_command(binary)
              .with_flag('-version')
              .build
              .execute(stdout: version_string)

          if version_string.string.lines.first =~ /#{version}/
            return false
          end
        end

        return true
      end
    end
  end
end
