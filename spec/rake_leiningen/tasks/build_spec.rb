require 'spec_helper'

describe RakeLeiningen::Tasks::Build do
  include_context :rake

  before(:each) do
    namespace :leiningen do
      task :ensure
    end
  end

  it 'adds a build task in the namespace in which it is created' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task.task_defined?('something:build')).to(be(true))
  end

  it 'gives the build task a description' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task["something:build"].full_comment)
        .to(eq("Build standalone uberjar."))
  end

  it 'allows the task name to be overridden' do
    namespace :something do
      subject.define(name: :jar)
    end

    expect(Rake::Task.task_defined?("something:jar")).to(be(true))
  end

  it 'allows multiple build tasks to be declared' do
    namespace :something1 do
      subject.define
    end

    namespace :something2 do
      subject.define
    end

    expect(Rake::Task.task_defined?("something1:build")).to(be(true))
    expect(Rake::Task.task_defined?("something2:build")).to(be(true))
  end

  it 'depends on the leiningen:ensure task by default' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task["something:build"].prerequisite_tasks)
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

    expect(Rake::Task["something:build"].prerequisite_tasks)
        .to(include(Rake::Task["tools:leiningen:ensure"]))
  end

  it 'configures the task with the provided arguments if specified' do
    argument_names = [:deployment_identifier, :region]

    namespace :something do
      subject.define(argument_names: argument_names)
    end

    expect(Rake::Task['something:build'].arg_names)
        .to(eq(argument_names))
  end

  it 'executes uberjar on invocation' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:uberjar)
            .with(main_namespace: nil, profile: nil))

    namespace :something do
      subject.define
    end

    Rake::Task["something:build"].invoke
  end

  it 'uses the provided main namespace when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:uberjar)
            .with(
                main_namespace: 'some.namespace',
                profile: nil))

    namespace :something do
      subject.define(main_namespace: 'some.namespace')
    end

    Rake::Task["something:build"].invoke
  end

  it 'uses the provided profile when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:uberjar)
            .with(
                main_namespace: nil,
                profile: "test"))

    namespace :something do
      subject.define(profile: "test")
    end

    Rake::Task["something:build"].invoke
  end

  it 'changes directory if the directory parameter is specified' do
    stub_puts
    
    directory = "some/other/directory"

    expect(Dir).to(receive(:chdir).with(directory).and_yield)

    expect(RubyLeiningen)
        .to(receive(:uberjar))

    namespace :something do
      subject.define(directory: directory)
    end

    Rake::Task["something:build"].invoke
  end

  def stub_chdir
    allow(Dir).to(receive(:chdir).and_yield)
  end

  def stub_puts
    allow_any_instance_of(Kernel).to(receive(:puts))
  end
end
