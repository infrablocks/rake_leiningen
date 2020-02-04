require 'rake_dependencies'
require 'rake_leiningen/version'
require 'rake_leiningen/tasks'
require 'rake_leiningen/task_sets'

module RakeLeiningen
  def self.define_check_tasks(opts = {}, &block)
    RakeLeiningen::TaskSets::Checks.define(opts, &block)
  end

  def self.define_build_task(opts = {}, &block)
    RakeLeiningen::Tasks::Build.define(opts, &block)
  end

  def self.define_installation_tasks(opts = {})
    namespace = opts[:namespace] || :leiningen
    dependency = 'lein'
    version = opts[:version] || '2.9.1'
    path = opts[:path] || File.join(Dir.pwd, 'vendor', 'leiningen')
    type = :uncompressed
    uri_template = "https://raw.githubusercontent.com/technomancy/" +
        "leiningen/<%= @version %>/bin/lein"
    file_name_template = "lein"

    needs_fetch_checker = lambda do |t|
      binary = File.join(t.path, t.binary_directory, 'lein')
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

    RubyLeiningen.configure do |c|
      c.binary = File.join(path, 'bin', 'lein')
    end

    RakeDependencies::TaskSets::All.define(
        namespace: namespace,
        dependency: dependency,
        version: version,
        path: path,
        type: type,
        uri_template: uri_template,
        file_name_template: file_name_template,
        needs_fetch: needs_fetch_checker)
  end
end
