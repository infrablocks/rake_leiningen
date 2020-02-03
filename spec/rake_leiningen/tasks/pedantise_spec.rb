require 'spec_helper'

describe RakeLeiningen::Tasks::Pedantise do
  include_context :rake

  before(:each) do
    namespace :leiningen do
      task :ensure
    end
  end

  it 'adds an pedantise task in the namespace in which it is created' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task.task_defined?('something:pedantise')).to(be(true))
  end

  it 'gives the pedantise task a description' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task["something:pedantise"].full_comment)
        .to(eq("Hunt for 'bad' code in all clojure files."))
  end

  it 'allows the task name to be overridden' do
    namespace :something do
      subject.define(name: :bikeshed)
    end

    expect(Rake::Task.task_defined?("something:bikeshed")).to(be(true))
  end

  it 'allows multiple pedantise tasks to be declared' do
    namespace :something1 do
      subject.define
    end

    namespace :something2 do
      subject.define
    end

    expect(Rake::Task.task_defined?("something1:pedantise")).to(be(true))
    expect(Rake::Task.task_defined?("something2:pedantise")).to(be(true))
  end

  it 'depends on the leiningen:ensure task by default' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task["something:pedantise"].prerequisite_tasks)
        .to(include(Rake::Task["leiningen:ensure"]))
  end

  it 'depends on the provided task if specified' do
    namespace :tools do
      namespace :leiningen do
        task :ensure
      end
    end

    namespace :something do
      subject.define(ensure_task_name: "tools:leiningen:ensure")
    end

    expect(Rake::Task["something:pedantise"].prerequisite_tasks)
        .to(include(Rake::Task["tools:leiningen:ensure"]))
  end

  it 'configures the task with the provided arguments if specified' do
    argument_names = [:deployment_identifier, :region]

    namespace :something do
      subject.define(argument_names: argument_names)
    end

    expect(Rake::Task['something:pedantise'].arg_names)
        .to(eq(argument_names))
  end

  it 'executes kibit on invocation' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:bikeshed)
            .with(
                show_help: nil,
                verbose: nil,
                maximum_line_length: nil,
                long_lines: nil,
                trailing_whitespace: nil,
                trailing_blank_lines: nil,
                var_redefs: nil,
                docstrings: nil,
                name_collisions: nil,
                exclude_profiles: nil,
                profile: nil))

    namespace :something do
      subject.define
    end

    Rake::Task["something:pedantise"].invoke
  end

  it 'uses the provided value for show help when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:bikeshed)
            .with(
                show_help: true,
                verbose: nil,
                maximum_line_length: nil,
                long_lines: nil,
                trailing_whitespace: nil,
                trailing_blank_lines: nil,
                var_redefs: nil,
                docstrings: nil,
                name_collisions: nil,
                exclude_profiles: nil,
                profile: nil))

    namespace :something do
      subject.define(show_help: true)
    end

    Rake::Task["something:pedantise"].invoke
  end

  it 'uses the provided value for verbose when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:bikeshed)
            .with(
                show_help: nil,
                verbose: true,
                maximum_line_length: nil,
                long_lines: nil,
                trailing_whitespace: nil,
                trailing_blank_lines: nil,
                var_redefs: nil,
                docstrings: nil,
                name_collisions: nil,
                exclude_profiles: nil,
                profile: nil))

    namespace :something do
      subject.define(verbose: true)
    end

    Rake::Task["something:pedantise"].invoke
  end

  it 'uses the provided maximum line length when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:bikeshed)
            .with(
                show_help: nil,
                verbose: nil,
                maximum_line_length: 120,
                long_lines: nil,
                trailing_whitespace: nil,
                trailing_blank_lines: nil,
                var_redefs: nil,
                docstrings: nil,
                name_collisions: nil,
                exclude_profiles: nil,
                profile: nil))

    namespace :something do
      subject.define(maximum_line_length: 120)
    end

    Rake::Task["something:pedantise"].invoke
  end

  it 'uses the provided value for long lines when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:bikeshed)
            .with(
                show_help: nil,
                verbose: nil,
                maximum_line_length: nil,
                long_lines: true,
                trailing_whitespace: nil,
                trailing_blank_lines: nil,
                var_redefs: nil,
                docstrings: nil,
                name_collisions: nil,
                exclude_profiles: nil,
                profile: nil))

    namespace :something do
      subject.define(long_lines: true)
    end

    Rake::Task["something:pedantise"].invoke
  end

  it 'uses the provided value for trailing whitespace when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:bikeshed)
            .with(
                show_help: nil,
                verbose: nil,
                maximum_line_length: nil,
                long_lines: nil,
                trailing_whitespace: true,
                trailing_blank_lines: nil,
                var_redefs: nil,
                docstrings: nil,
                name_collisions: nil,
                exclude_profiles: nil,
                profile: nil))

    namespace :something do
      subject.define(trailing_whitespace: true)
    end

    Rake::Task["something:pedantise"].invoke
  end

  it 'uses the provided value for trailing blank lines when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:bikeshed)
            .with(
                show_help: nil,
                verbose: nil,
                maximum_line_length: nil,
                long_lines: nil,
                trailing_whitespace: nil,
                trailing_blank_lines: true,
                var_redefs: nil,
                docstrings: nil,
                name_collisions: nil,
                exclude_profiles: nil,
                profile: nil))

    namespace :something do
      subject.define(trailing_blank_lines: true)
    end

    Rake::Task["something:pedantise"].invoke
  end

  it 'uses the provided value for var redefs when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:bikeshed)
            .with(
                show_help: nil,
                verbose: nil,
                maximum_line_length: nil,
                long_lines: nil,
                trailing_whitespace: nil,
                trailing_blank_lines: nil,
                var_redefs: true,
                docstrings: nil,
                name_collisions: nil,
                exclude_profiles: nil,
                profile: nil))

    namespace :something do
      subject.define(var_redefs: true)
    end

    Rake::Task["something:pedantise"].invoke
  end

  it 'uses the provided value for docstrings when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:bikeshed)
            .with(
                show_help: nil,
                verbose: nil,
                maximum_line_length: nil,
                long_lines: nil,
                trailing_whitespace: nil,
                trailing_blank_lines: nil,
                var_redefs: nil,
                docstrings: true,
                name_collisions: nil,
                exclude_profiles: nil,
                profile: nil))

    namespace :something do
      subject.define(docstrings: true)
    end

    Rake::Task["something:pedantise"].invoke
  end

  it 'uses the provided value for name collisions when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:bikeshed)
            .with(
                show_help: nil,
                verbose: nil,
                maximum_line_length: nil,
                long_lines: nil,
                trailing_whitespace: nil,
                trailing_blank_lines: nil,
                var_redefs: nil,
                docstrings: nil,
                name_collisions: true,
                exclude_profiles: nil,
                profile: nil))

    namespace :something do
      subject.define(name_collisions: true)
    end

    Rake::Task["something:pedantise"].invoke
  end

  it 'uses the provided value for exclude profiles when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:bikeshed)
            .with(
                show_help: nil,
                verbose: nil,
                maximum_line_length: nil,
                long_lines: nil,
                trailing_whitespace: nil,
                trailing_blank_lines: nil,
                var_redefs: nil,
                docstrings: nil,
                name_collisions: nil,
                exclude_profiles: ["test"],
                profile: nil))

    namespace :something do
      subject.define(exclude_profiles: ["test"])
    end

    Rake::Task["something:pedantise"].invoke
  end

  it 'uses the provided profile when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:bikeshed)
            .with(
                show_help: nil,
                verbose: nil,
                maximum_line_length: nil,
                long_lines: nil,
                trailing_whitespace: nil,
                trailing_blank_lines: nil,
                var_redefs: nil,
                docstrings: nil,
                name_collisions: nil,
                exclude_profiles: nil,
                profile: "test"))

    namespace :something do
      subject.define(profile: "test")
    end

    Rake::Task["something:pedantise"].invoke
  end

  it 'changes directory if the directory parameter is specified' do
    stub_puts
    
    directory = "some/other/directory"

    expect(Dir).to(receive(:chdir).with(directory).and_yield)

    expect(RubyLeiningen)
        .to(receive(:bikeshed))

    namespace :something do
      subject.define(directory: directory)
    end

    Rake::Task["something:pedantise"].invoke
  end

  def stub_chdir
    allow(Dir).to(receive(:chdir).and_yield)
  end

  def stub_puts
    allow_any_instance_of(Kernel).to(receive(:puts))
  end
end
