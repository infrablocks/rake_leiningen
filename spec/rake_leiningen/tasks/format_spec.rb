require 'spec_helper'

describe RakeLeiningen::Tasks::Format do
  include_context :rake

  before(:each) do
    namespace :leiningen do
      task :ensure
    end
  end

  it 'adds a format task in the namespace in which it is created' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task.task_defined?('something:format')).to(be(true))
  end

  it 'gives the format task a description' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task["something:format"].full_comment)
        .to(eq("Format all clojure files"))
  end

  it 'allows the task name to be overridden' do
    namespace :something do
      subject.define(name: :cljfmt)
    end

    expect(Rake::Task.task_defined?("something:cljfmt")).to(be(true))
  end

  it 'allows multiple format tasks to be declared' do
    namespace :something1 do
      subject.define
    end

    namespace :something2 do
      subject.define
    end

    expect(Rake::Task.task_defined?("something1:format")).to(be(true))
    expect(Rake::Task.task_defined?("something2:format")).to(be(true))
  end

  it 'depends on the leiningen:ensure task by default' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task["something:format"].prerequisite_tasks)
        .to(include(Rake::Task["leiningen:ensure"]))
  end

  it 'depends on the provided task if specified' do
    namespace :tools do
      namespace :fly do
        task :ensure
      end
    end

    namespace :something do
      subject.define(ensure_task_name: "tools:fly:ensure")
    end

    expect(Rake::Task["something:format"].prerequisite_tasks)
        .to(include(Rake::Task["tools:fly:ensure"]))
  end

  it 'configures the task with the provided arguments if specified' do
    argument_names = [:deployment_identifier, :region]

    namespace :something do
      subject.define(argument_names: argument_names)
    end

    expect(Rake::Task['something:format'].arg_names)
        .to(eq(argument_names))
  end

  it 'executes cljfmt on invocation' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:cljfmt)
            .with(mode: nil, paths: nil, profile: nil))

    namespace :something do
      subject.define
    end

    Rake::Task["something:format"].invoke
  end

  it 'uses the provided mode when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:cljfmt)
            .with(mode: :fix, paths: nil, profile: nil))

    namespace :something do
      subject.define(mode: :fix)
    end

    Rake::Task["something:format"].invoke
  end

  it 'uses the provided paths when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:cljfmt)
            .with(
                mode: nil,
                paths: ["src/", "generated/"],
                profile: nil))

    namespace :something do
      subject.define(paths: ["src/", "generated/"])
    end

    Rake::Task["something:format"].invoke
  end

  it 'uses the provided profile when specified' do
    stub_puts
    stub_chdir

    expect(RubyLeiningen)
        .to(receive(:cljfmt)
            .with(
                mode: nil,
                paths: nil,
                profile: "test"))

    namespace :something do
      subject.define(profile: "test")
    end

    Rake::Task["something:format"].invoke
  end

  it 'changes directory if the directory parameter is specified' do
    stub_puts
    
    directory = "some/other/directory"

    expect(Dir).to(receive(:chdir).with(directory).and_yield)

    expect(RubyLeiningen)
        .to(receive(:cljfmt))

    namespace :something do
      subject.define(directory: directory)
    end

    Rake::Task["something:format"].invoke
  end

  def stub_chdir
    allow(Dir).to(receive(:chdir).and_yield)
  end

  def stub_puts
    allow_any_instance_of(Kernel).to(receive(:puts))
  end
end
