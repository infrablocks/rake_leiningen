# frozen_string_literal: true

require 'spec_helper'

describe RakeLeiningen::Tasks::Optimise do
  include_context 'rake'

  before do
    namespace :leiningen do
      task :ensure
    end
  end

  it 'adds a optimise task in the namespace in which it is created' do
    namespace :something do
      described_class.define
    end

    expect(Rake.application)
      .to(have_task_defined('something:optimise'))
  end

  it 'gives the optimise task a description' do
    namespace :something do
      described_class.define
    end

    expect(Rake::Task['something:optimise'].full_comment)
      .to(eq('Warn on reflection for all clojure files.'))
  end

  it 'allows the task name to be overridden' do
    namespace :something do
      described_class.define(name: :check_reflection)
    end

    expect(Rake.application)
      .to(have_task_defined('something:check_reflection'))
  end

  it 'allows multiple optimise tasks to be declared' do
    namespace :something1 do
      described_class.define
    end

    namespace :something2 do
      described_class.define
    end

    expect(Rake.application)
      .to(have_tasks_defined(
            %w[something1:optimise
               something2:optimise]
          ))
  end

  it 'depends on the leiningen:ensure task by default' do
    namespace :something do
      described_class.define
    end

    expect(Rake::Task['something:optimise'].prerequisite_tasks)
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

    expect(Rake::Task['something:optimise'].prerequisite_tasks)
      .to(include(Rake::Task['tools:leiningen:ensure']))
  end

  it 'configures the task with the provided arguments if specified' do
    argument_names = %i[deployment_identifier region]

    namespace :something do
      described_class.define(argument_names: argument_names)
    end

    expect(Rake::Task['something:optimise'].arg_names)
      .to(eq(argument_names))
  end

  it 'executes eastwood on invocation' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:check))

    namespace :something do
      described_class.define
    end

    Rake::Task['something:optimise'].invoke

    expect(RubyLeiningen)
      .to(have_received(:check)
            .with(
              profile: nil,
              environment: nil
            ))
  end

  it 'uses the provided profile when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:check))

    namespace :something do
      described_class.define(profile: 'test')
    end

    Rake::Task['something:optimise'].invoke

    expect(RubyLeiningen)
      .to(have_received(:check)
            .with(
              profile: 'test',
              environment: nil
            ))
  end

  it 'uses the provided environment when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:check))

    namespace :something do
      described_class.define(environment: { 'VAR' => 'val' })
    end

    Rake::Task['something:optimise'].invoke

    expect(RubyLeiningen)
      .to(have_received(:check)
            .with(
              profile: nil,
              environment: { 'VAR' => 'val' }
            ))
  end

  # rubocop:disable RSpec/MultipleExpectations
  it 'changes directory if the directory parameter is specified' do
    stub_output

    directory = 'some/other/directory'

    allow(Dir).to(receive(:chdir).and_yield)
    allow(RubyLeiningen).to(receive(:check))

    namespace :something do
      described_class.define(directory: directory)
    end

    Rake::Task['something:optimise'].invoke

    expect(Dir)
      .to(have_received(:chdir)
            .with(directory))
    expect(RubyLeiningen)
      .to(have_received(:check))
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
