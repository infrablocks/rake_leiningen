require 'spec_helper'

describe RakeLeiningen::Tasks::Style do
  include_context :rake

  before(:each) do
    namespace :leiningen do
      task :ensure
    end
  end

  it 'adds a style task in the namespace in which it is created' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task.task_defined?('something:style')).to(be(true))
  end

  it 'gives the style task a description' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task["something:style"].full_comment)
        .to(eq("Make all clojure files conform to a style."))
  end

  it 'allows the task name to be overridden' do
    namespace :something do
      subject.define(name: :cljstyle)
    end

    expect(Rake::Task.task_defined?("something:cljstyle")).to(be(true))
  end

  it 'allows multiple style tasks to be declared' do
    namespace :something1 do
      subject.define
    end

    namespace :something2 do
      subject.define
    end

    expect(Rake::Task.task_defined?("something1:style")).to(be(true))
    expect(Rake::Task.task_defined?("something2:style")).to(be(true))
  end

  it 'depends on the leiningen:ensure task by default' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task["something:style"].prerequisite_tasks)
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

    expect(Rake::Task["something:style"].prerequisite_tasks)
        .to(include(Rake::Task["tools:leiningen:ensure"]))
  end

  it 'configures the task with the provided arguments if specified' do
    argument_names = [:deployment_identifier, :region]

    namespace :something do
      subject.define(argument_names: argument_names)
    end

    expect(Rake::Task['something:style'].arg_names)
        .to(eq(argument_names))
  end

  it 'executes cljstyle on invocation' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:cljstyle)
            .with(
                mode: nil,
                paths: nil))

    namespace :something do
      subject.define
    end

    Rake::Task["something:style"].invoke
  end

  it 'uses the provided mode when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:cljstyle)
            .with(
                mode: :fix,
                paths: nil))

    namespace :something do
      subject.define(mode: :fix)
    end

    Rake::Task["something:style"].invoke
  end

  it 'uses the provided paths when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:cljstyle)
            .with(
                mode: nil,
                paths: ["src/", "generated/"]))

    namespace :something do
      subject.define(paths: ["src/", "generated/"])
    end

    Rake::Task["something:style"].invoke
  end

  it 'changes directory if the directory parameter is specified' do
    stub_puts

    directory = "some/other/directory"

    expect(Dir).to(receive(:chdir).with(directory).and_yield)

    expect(RubyLeiningen)
        .to(receive(:cljstyle))

    namespace :something do
      subject.define(directory: directory)
    end

    Rake::Task["something:style"].invoke
  end

  def stub_chdir
    allow(Dir).to(receive(:chdir).and_yield)
  end

  def stub_puts
    allow_any_instance_of(Kernel).to(receive(:puts))
  end
end
