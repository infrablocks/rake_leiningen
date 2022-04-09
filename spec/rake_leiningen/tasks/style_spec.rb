# frozen_string_literal: true

require 'spec_helper'

describe RakeLeiningen::Tasks::Style do
  include_context 'rake'

  before do
    namespace :leiningen do
      task :ensure
    end
  end

  it 'adds a style task in the namespace in which it is created' do
    namespace :something do
      described_class.define
    end

    expect(Rake.application)
      .to(have_task_defined('something:style'))
  end

  it 'gives the style task a description' do
    namespace :something do
      described_class.define
    end

    expect(Rake::Task['something:style'].full_comment)
      .to(eq('Make all clojure files conform to a style.'))
  end

  it 'allows the task name to be overridden' do
    namespace :something do
      described_class.define(name: :cljstyle)
    end

    expect(Rake.application)
      .to(have_task_defined('something:cljstyle'))
  end

  it 'allows multiple style tasks to be declared' do
    namespace :something1 do
      described_class.define
    end

    namespace :something2 do
      described_class.define
    end

    expect(Rake.application)
      .to(have_tasks_defined(
            %w[something1:style
               something2:style]
          ))
  end

  it 'depends on the leiningen:ensure task by default' do
    namespace :something do
      described_class.define
    end

    expect(Rake::Task['something:style'].prerequisite_tasks)
      .to(include(Rake::Task['leiningen:ensure']))
  end

  it 'depends on the provided task if specified' do
    namespace :tools do
      namespace :leiningen do
        task :ensure
      end
    end

    namespace :something do
      described_class.define(ensure_task_name: 'tools:leiningen:ensure')
    end

    expect(Rake::Task['something:style'].prerequisite_tasks)
      .to(include(Rake::Task['tools:leiningen:ensure']))
  end

  it 'configures the task with the provided arguments if specified' do
    argument_names = %i[deployment_identifier region]

    namespace :something do
      described_class.define(argument_names: argument_names)
    end

    expect(Rake::Task['something:style'].arg_names)
      .to(eq(argument_names))
  end

  it 'executes cljstyle on invocation' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:cljstyle))

    namespace :something do
      described_class.define
    end

    Rake::Task['something:style'].invoke

    expect(RubyLeiningen)
      .to(have_received(:cljstyle)
            .with(
              mode: nil,
              paths: nil
            ))
  end

  it 'uses the provided mode when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:cljstyle))

    namespace :something do
      described_class.define(mode: :fix)
    end

    Rake::Task['something:style'].invoke

    expect(RubyLeiningen)
      .to(have_received(:cljstyle)
            .with(
              mode: :fix,
              paths: nil
            ))
  end

  it 'uses the provided paths when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:cljstyle))

    namespace :something do
      described_class.define(paths: %w[src/ generated/])
    end

    Rake::Task['something:style'].invoke

    expect(RubyLeiningen)
      .to(have_received(:cljstyle)
            .with(
              mode: nil,
              paths: %w[src/ generated/]
            ))
  end

  # rubocop:disable RSpec/MultipleExpectations
  it 'changes directory if the directory parameter is specified' do
    stub_output

    directory = 'some/other/directory'

    allow(Dir).to(receive(:chdir).and_yield)
    allow(RubyLeiningen).to(receive(:cljstyle))

    namespace :something do
      described_class.define(directory: directory)
    end

    Rake::Task['something:style'].invoke

    expect(Dir)
      .to(have_received(:chdir)
            .with(directory))
    expect(RubyLeiningen)
      .to(have_received(:cljstyle))
  end
  # rubocop:enable RSpec/MultipleExpectations

  def stub_chdir
    allow(Dir).to(receive(:chdir).and_yield)
  end

  def stub_output
    %i[print puts].each do |method|
      allow($stdout).to(receive(method))
      allow($stderr).to(receive(method))
    end
  end
end
