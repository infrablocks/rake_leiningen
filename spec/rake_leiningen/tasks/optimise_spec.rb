require 'spec_helper'

describe RakeLeiningen::Tasks::Optimise do
  include_context :rake

  before(:each) do
    namespace :leiningen do
      task :ensure
    end
  end

  it 'adds a optimise task in the namespace in which it is created' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task.task_defined?('something:optimise')).to(be(true))
  end

  it 'gives the optimise task a description' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task["something:optimise"].full_comment)
        .to(eq("Warn on reflection for all clojure files."))
  end

  it 'allows the task name to be overridden' do
    namespace :something do
      subject.define(name: :check_reflection)
    end

    expect(Rake::Task.task_defined?("something:check_reflection")).to(be(true))
  end

  it 'allows multiple optimise tasks to be declared' do
    namespace :something1 do
      subject.define
    end

    namespace :something2 do
      subject.define
    end

    expect(Rake::Task.task_defined?("something1:optimise")).to(be(true))
    expect(Rake::Task.task_defined?("something2:optimise")).to(be(true))
  end

  it 'depends on the leiningen:ensure task by default' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task["something:optimise"].prerequisite_tasks)
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

    expect(Rake::Task["something:optimise"].prerequisite_tasks)
        .to(include(Rake::Task["tools:leiningen:ensure"]))
  end

  it 'configures the task with the provided arguments if specified' do
    argument_names = [:deployment_identifier, :region]

    namespace :something do
      subject.define(argument_names: argument_names)
    end

    expect(Rake::Task['something:optimise'].arg_names)
        .to(eq(argument_names))
  end

  it 'executes eastwood on invocation' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:check)
            .with(
                profile: nil,
                environment: nil))

    namespace :something do
      subject.define
    end

    Rake::Task["something:optimise"].invoke
  end

  it 'uses the provided profile when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:check)
            .with(
                profile: "test",
                environment: nil))

    namespace :something do
      subject.define(profile: "test")
    end

    Rake::Task["something:optimise"].invoke
  end

  it 'uses the provided environment when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:check)
            .with(
                profile: nil,
                environment: {"VAR" => "val"}))

    namespace :something do
      subject.define(environment: {"VAR" => "val"})
    end

    Rake::Task["something:optimise"].invoke
  end

  it 'changes directory if the directory parameter is specified' do
    stub_puts
    
    directory = "some/other/directory"

    expect(Dir).to(receive(:chdir).with(directory).and_yield)

    expect(RubyLeiningen)
        .to(receive(:check))

    namespace :something do
      subject.define(directory: directory)
    end

    Rake::Task["something:optimise"].invoke
  end

  def stub_chdir
    allow(Dir).to(receive(:chdir).and_yield)
  end

  def stub_puts
    allow_any_instance_of(Kernel).to(receive(:puts))
  end
end
