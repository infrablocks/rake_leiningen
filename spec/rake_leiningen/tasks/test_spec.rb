require 'spec_helper'

describe RakeLeiningen::Tasks::Test do
  include_context :rake

  before(:each) do
    namespace :leiningen do
      task :ensure
    end
  end

  it 'adds a test task in the namespace in which it is created' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task.task_defined?('something:test')).to(be(true))
  end

  it 'gives the test task a description' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task["something:test"].full_comment)
        .to(eq("Run all tests."))
  end

  it 'uses the type in the task description when available' do
    namespace :something do
      subject.define(type: 'unit')
    end

    expect(Rake::Task["something:test"].full_comment)
        .to(eq("Run all unit tests."))
  end

  it 'allows the task name to be overridden' do
    namespace :something do
      subject.define(name: :unit)
    end

    expect(Rake::Task.task_defined?("something:unit")).to(be(true))
  end

  it 'allows multiple test tasks to be declared' do
    namespace :something1 do
      subject.define
    end

    namespace :something2 do
      subject.define
    end

    expect(Rake::Task.task_defined?("something1:test")).to(be(true))
    expect(Rake::Task.task_defined?("something2:test")).to(be(true))
  end

  it 'depends on the leiningen:ensure task by default' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task["something:test"].prerequisite_tasks)
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

    expect(Rake::Task["something:test"].prerequisite_tasks)
        .to(include(Rake::Task["tools:leiningen:ensure"]))
  end

  it 'configures the task with the provided arguments if specified' do
    argument_names = [:deployment_identifier, :region]

    namespace :something do
      subject.define(argument_names: argument_names)
    end

    expect(Rake::Task['something:test'].arg_names)
        .to(eq(argument_names))
  end

  it 'executes run on invocation' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:eftest)
            .with(
                only: nil,
                test_selectors: nil,
                namespaces: nil,
                files: nil,
                profile: nil,
                environment: nil))

    namespace :something do
      subject.define
    end

    Rake::Task["something:test"].invoke
  end

  it 'uses the provided only when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:eftest)
            .with(
                only: 'some.namespace/test-something',
                test_selectors: nil,
                namespaces: nil,
                files: nil,
                profile: nil,
                environment: nil))

    namespace :something do
      subject.define(only: 'some.namespace/test-something')
    end

    Rake::Task["something:test"].invoke
  end

  it 'uses the provided test selectors when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:eftest)
            .with(
                only: nil,
                test_selectors: [:unit, :integration],
                namespaces: nil,
                files: nil,
                profile: nil,
                environment: nil))

    namespace :something do
      subject.define(test_selectors: [:unit, :integration])
    end

    Rake::Task["something:test"].invoke
  end

  it 'uses the provided namespaces when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:eftest)
            .with(
                only: nil,
                test_selectors: nil,
                namespaces: ["mylib.core", "mylib.helpers"],
                files: nil,
                profile: nil,
                environment: nil))

    namespace :something do
      subject.define(namespaces: ["mylib.core", "mylib.helpers"])
    end

    Rake::Task["something:test"].invoke
  end

  it 'uses the provided files when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:eftest)
            .with(
                only: nil,
                test_selectors: nil,
                namespaces: nil,
                files: ["src/mylib/core.clj", "src/mylib/helpers.clj"],
                profile: nil,
                environment: nil))

    namespace :something do
      subject.define(files: ["src/mylib/core.clj", "src/mylib/helpers.clj"])
    end

    Rake::Task["something:test"].invoke
  end

  it 'uses the provided profile when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:eftest)
            .with(
                only: nil,
                test_selectors: nil,
                namespaces: nil,
                files: nil,
                profile: "test",
                environment: nil))

    namespace :something do
      subject.define(profile: "test")
    end

    Rake::Task["something:test"].invoke
  end

  it 'uses the provided environment when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:eftest)
            .with(
                only: nil,
                test_selectors: nil,
                namespaces: nil,
                files: nil,
                profile: nil,
                environment: {"VAR" => "val"}))

    namespace :something do
      subject.define(environment: {"VAR" => "val"})
    end

    Rake::Task["something:test"].invoke
  end

  it 'changes directory if the directory parameter is specified' do
    stub_puts

    directory = "some/other/directory"

    expect(Dir).to(receive(:chdir).with(directory).and_yield)

    expect(RubyLeiningen)
        .to(receive(:eftest))

    namespace :something do
      subject.define(directory: directory)
    end

    Rake::Task["something:test"].invoke
  end

  def stub_chdir
    allow(Dir).to(receive(:chdir).and_yield)
  end

  def stub_puts
    allow_any_instance_of(Kernel).to(receive(:puts))
  end
end
