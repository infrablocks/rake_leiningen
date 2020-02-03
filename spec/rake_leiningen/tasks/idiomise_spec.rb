require 'spec_helper'

describe RakeLeiningen::Tasks::Idiomise do
  include_context :rake

  before(:each) do
    namespace :leiningen do
      task :ensure
    end
  end

  it 'adds an idiomise task in the namespace in which it is created' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task.task_defined?('something:idiomise')).to(be(true))
  end

  it 'gives the idiomise task a description' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task["something:idiomise"].full_comment)
        .to(eq("Transform all clojure files to be more idiomatic."))
  end

  it 'allows the task name to be overridden' do
    namespace :something do
      subject.define(name: :kibit)
    end

    expect(Rake::Task.task_defined?("something:kibit")).to(be(true))
  end

  it 'allows multiple idiomise tasks to be declared' do
    namespace :something1 do
      subject.define
    end

    namespace :something2 do
      subject.define
    end

    expect(Rake::Task.task_defined?("something1:idiomise")).to(be(true))
    expect(Rake::Task.task_defined?("something2:idiomise")).to(be(true))
  end

  it 'depends on the leiningen:ensure task by default' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task["something:idiomise"].prerequisite_tasks)
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

    expect(Rake::Task["something:idiomise"].prerequisite_tasks)
        .to(include(Rake::Task["tools:leiningen:ensure"]))
  end

  it 'configures the task with the provided arguments if specified' do
    argument_names = [:deployment_identifier, :region]

    namespace :something do
      subject.define(argument_names: argument_names)
    end

    expect(Rake::Task['something:idiomise'].arg_names)
        .to(eq(argument_names))
  end

  it 'executes kibit on invocation' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:kibit)
            .with(
                replace: nil,
                interactive: nil,
                reporter: nil,
                paths: nil,
                profile: nil))

    namespace :something do
      subject.define
    end

    Rake::Task["something:idiomise"].invoke
  end

  it 'uses the provided value for replace when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:kibit)
            .with(
                replace: true,
                interactive: nil,
                reporter: nil,
                paths: nil,
                profile: nil))

    namespace :something do
      subject.define(replace: true)
    end

    Rake::Task["something:idiomise"].invoke
  end

  it 'uses the provided value for interactive when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:kibit)
            .with(
                replace: nil,
                interactive: true,
                reporter: nil,
                paths: nil,
                profile: nil))

    namespace :something do
      subject.define(interactive: true)
    end

    Rake::Task["something:idiomise"].invoke
  end

  it 'uses the provided reporter when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:kibit)
            .with(
                replace: nil,
                interactive: nil,
                reporter: "markdown",
                paths: nil,
                profile: nil))

    namespace :something do
      subject.define(reporter: "markdown")
    end

    Rake::Task["something:idiomise"].invoke
  end

  it 'uses the provided paths when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:kibit)
            .with(
                replace: nil,
                interactive: nil,
                reporter: nil,
                paths: ["path/to/src/clj/", "path/to/src/cljs/util.cljs"],
                profile: nil))

    namespace :something do
      subject.define(paths: ["path/to/src/clj/", "path/to/src/cljs/util.cljs"])
    end

    Rake::Task["something:idiomise"].invoke
  end

  it 'uses the provided profile when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:kibit)
            .with(
                replace: nil,
                interactive: nil,
                reporter: nil,
                paths: nil,
                profile: "test"))

    namespace :something do
      subject.define(profile: "test")
    end

    Rake::Task["something:idiomise"].invoke
  end

  it 'changes directory if the directory parameter is specified' do
    stub_puts
    
    directory = "some/other/directory"

    expect(Dir).to(receive(:chdir).with(directory).and_yield)

    expect(RubyLeiningen)
        .to(receive(:kibit))

    namespace :something do
      subject.define(directory: directory)
    end

    Rake::Task["something:idiomise"].invoke
  end

  def stub_chdir
    allow(Dir).to(receive(:chdir).and_yield)
  end

  def stub_puts
    allow_any_instance_of(Kernel).to(receive(:puts))
  end
end
