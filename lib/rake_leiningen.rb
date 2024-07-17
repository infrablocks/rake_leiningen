# frozen_string_literal: true

require 'rake_dependencies'
require 'rake_leiningen/version'
require 'rake_leiningen/tasks'
require 'rake_leiningen/task_sets'

module RakeLeiningen
  def self.define_check_tasks(opts = {}, &)
    RakeLeiningen::TaskSets::Checks.define(opts, &)
  end

  def self.define_build_task(opts = {}, &)
    RakeLeiningen::Tasks::Build.define(opts, &)
  end

  def self.define_release_task(opts = {}, &)
    RakeLeiningen::Tasks::Release.define(opts, &)
  end

  def self.define_start_task(opts = {}, &)
    RakeLeiningen::Tasks::Start.define(opts, &)
  end

  def self.define_test_task(opts = {}, &)
    RakeLeiningen::Tasks::Test.define(opts, &)
  end

  def self.define_installation_tasks(opts = {})
    RubyLeiningen.configure do |c|
      c.binary = leiningen_binary_path(opts)
    end

    RakeDependencies::TaskSets::All.define(
      installation_task_set_options(opts)
    )
  end

  class << self
    private

    def installation_task_set_options(opts)
      {
        namespace: namespace(opts),
        dependency: dependency(opts),
        version: version(opts),
        path: path(opts),
        type: type(opts),
        uri_template: uri_template(opts),
        file_name_template: file_name_template(opts),
        needs_fetch: needs_fetch_check_function(opts)
      }
    end

    def leiningen_binary_path(opts)
      File.join(path(opts), 'bin', 'lein')
    end

    def namespace(opts)
      opts[:namespace] || :leiningen
    end

    def dependency(_)
      'lein'
    end

    def version(opts)
      opts[:version] || '2.9.1'
    end

    def path(opts)
      opts[:path] || File.join(Dir.pwd, 'vendor', 'leiningen')
    end

    def type(_)
      :uncompressed
    end

    def uri_template(_)
      'https://raw.githubusercontent.com/technomancy/' \
        'leiningen/<%= @version %>/bin/lein'
    end

    def file_name_template(_)
      'lein'
    end

    def needs_fetch_check_function(opts)
      lambda do |t|
        binary = File.join(t.path, t.binary_directory, 'lein')

        if File.exist?(binary) && get_version(binary) =~ /#{version(opts)}/
          return false
        end

        true
      end
    end

    def get_version(binary)
      stdout = Tempfile.new
      version_command(binary).execute(stdout:)
      stdout.rewind
      version_string = stdout.read
      version_string.lines.first
    end

    def version_command(binary)
      Lino::CommandLineBuilder
        .for_command(binary)
        .with_flag('-version')
        .build
    end
  end
end
