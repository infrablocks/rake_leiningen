# frozen_string_literal: true

require 'spec_helper'

describe RakeLeiningen::Tasks::Release do
  include_context 'rake'

  before do
    namespace :leiningen do
      task :ensure
    end
  end

  it 'adds a release task in the namespace in which it is created' do
    namespace :something do
      described_class.define
    end

    expect(Rake.application)
      .to(have_task_defined('something:release'))
  end

  it 'gives the release task a description' do
    namespace :something do
      described_class.define
    end

    expect(Rake::Task['something:release'].full_comment)
      .to(eq('Release library.'))
  end

  it 'allows the task name to be overridden' do
    namespace :something do
      described_class.define(name: :publish)
    end

    expect(Rake.application)
      .to(have_task_defined('something:publish'))
  end

  it 'allows multiple release tasks to be declared' do
    namespace :something1 do
      described_class.define
    end

    namespace :something2 do
      described_class.define
    end

    expect(Rake.application)
      .to(have_tasks_defined(
            %w[something1:release
               something2:release]
          ))
  end

  it 'depends on the leiningen:ensure task by default' do
    namespace :something do
      described_class.define
    end

    expect(Rake::Task['something:release'].prerequisite_tasks)
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

    expect(Rake::Task['something:release'].prerequisite_tasks)
      .to(include(Rake::Task['tools:leiningen:ensure']))
  end

  it 'configures the task with the provided arguments if specified' do
    argument_names = [:level]

    namespace :something do
      described_class.define(argument_names: argument_names)
    end

    expect(Rake::Task['something:release'].arg_names)
      .to(eq(argument_names))
  end

  it 'executes release on invocation' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:release))

    namespace :something do
      described_class.define
    end

    Rake::Task['something:release'].invoke

    expect(RubyLeiningen)
      .to(have_received(:release)
            .with(
              level: nil,
              profile: nil,
              environment: nil
            ))
  end

  it 'uses the provided level when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:release))

    namespace :something do
      described_class.define(level: ':patch')
    end

    Rake::Task['something:release'].invoke

    expect(RubyLeiningen)
      .to(have_received(:release)
            .with(
              level: ':patch',
              profile: nil,
              environment: nil
            ))
  end

  it 'uses the provided profile when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:release))

    namespace :something do
      described_class.define(profile: 'pre')
    end

    Rake::Task['something:release'].invoke

    expect(RubyLeiningen)
      .to(have_received(:release)
            .with(
              level: nil,
              profile: 'pre',
              environment: nil
            ))
  end

  it 'uses the provided environment when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen)
      .to(receive(:release))

    namespace :something do
      described_class.define(environment: { 'VAR' => 'val' })
    end

    Rake::Task['something:release'].invoke

    expect(RubyLeiningen)
      .to(have_received(:release)
            .with(
              level: nil,
              profile: nil,
              environment: { 'VAR' => 'val' }
            ))
  end

  # rubocop:disable RSpec/MultipleExpectations
  it 'changes directory if the directory parameter is specified' do
    stub_output

    directory = 'some/other/directory'

    allow(Dir).to(receive(:chdir).and_yield)
    allow(RubyLeiningen).to(receive(:release))

    namespace :something do
      described_class.define(directory: directory)
    end

    Rake::Task['something:release'].invoke

    expect(Dir)
      .to(have_received(:chdir)
            .with(directory))
    expect(RubyLeiningen)
      .to(have_received(:release))
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
