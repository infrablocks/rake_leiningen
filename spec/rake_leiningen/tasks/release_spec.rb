require 'spec_helper'

describe RakeLeiningen::Tasks::Release do
  include_context :rake

  before(:each) do
    namespace :leiningen do
      task :ensure
    end
  end

  it 'adds a release task in the namespace in which it is created' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task.task_defined?('something:release')).to(be(true))
  end

  it 'gives the release task a description' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task["something:release"].full_comment)
        .to(eq("Release library."))
  end

  it 'allows the task name to be overridden' do
    namespace :something do
      subject.define(name: :publish)
    end

    expect(Rake::Task.task_defined?("something:publish")).to(be(true))
  end

  it 'allows multiple release tasks to be declared' do
    namespace :something1 do
      subject.define
    end

    namespace :something2 do
      subject.define
    end

    expect(Rake::Task.task_defined?("something1:release")).to(be(true))
    expect(Rake::Task.task_defined?("something2:release")).to(be(true))
  end

  it 'depends on the leiningen:ensure task by default' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task["something:release"].prerequisite_tasks)
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

    expect(Rake::Task["something:release"].prerequisite_tasks)
        .to(include(Rake::Task["tools:leiningen:ensure"]))
  end

  it 'configures the task with the provided arguments if specified' do
    argument_names = [:level]

    namespace :something do
      subject.define(argument_names: argument_names)
    end

    expect(Rake::Task['something:release'].arg_names)
        .to(eq(argument_names))
  end

  it 'executes release on invocation' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:release)
            .with(level: nil, profile: nil))

    namespace :something do
      subject.define
    end

    Rake::Task["something:release"].invoke
  end

  it 'uses the provided level when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:release)
            .with(
                level: ':patch',
                profile: nil))

    namespace :something do
      subject.define(level: ':patch')
    end

    Rake::Task["something:release"].invoke
  end

  it 'uses the provided profile when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:release)
            .with(
                level: nil,
                profile: "pre"))

    namespace :something do
      subject.define(profile: "pre")
    end

    Rake::Task["something:release"].invoke
  end

  it 'changes directory if the directory parameter is specified' do
    stub_puts
    
    directory = "some/other/directory"

    expect(Dir).to(receive(:chdir).with(directory).and_yield)

    expect(RubyLeiningen)
        .to(receive(:release))

    namespace :something do
      subject.define(directory: directory)
    end

    Rake::Task["something:release"].invoke
  end

  def stub_chdir
    allow(Dir).to(receive(:chdir).and_yield)
  end

  def stub_puts
    allow_any_instance_of(Kernel).to(receive(:puts))
  end
end
