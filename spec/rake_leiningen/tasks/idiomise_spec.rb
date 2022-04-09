# frozen_string_literal: true

require 'spec_helper'

describe RakeLeiningen::Tasks::Idiomise do
  include_context 'rake'

  before do
    namespace :leiningen do
      task :ensure
    end
  end

  it 'adds an idiomise task in the namespace in which it is created' do
    namespace :something do
      described_class.define
    end

    expect(Rake.application)
      .to(have_task_defined('something:idiomise'))
  end

  it 'gives the idiomise task a description' do
    namespace :something do
      described_class.define
    end

    expect(Rake::Task['something:idiomise'].full_comment)
      .to(eq('Transform all clojure files to be more idiomatic.'))
  end

  it 'allows the task name to be overridden' do
    namespace :something do
      described_class.define(name: :kibit)
    end

    expect(Rake.application)
      .to(have_task_defined('something:kibit'))
  end

  it 'allows multiple idiomise tasks to be declared' do
    namespace :something1 do
      described_class.define
    end

    namespace :something2 do
      described_class.define
    end

    expect(Rake.application)
      .to(have_tasks_defined(
            %w[something1:idiomise
               something2:idiomise]
          ))
  end

  it 'depends on the leiningen:ensure task by default' do
    namespace :something do
      described_class.define
    end

    expect(Rake::Task['something:idiomise'].prerequisite_tasks)
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

    expect(Rake::Task['something:idiomise'].prerequisite_tasks)
      .to(include(Rake::Task['tools:leiningen:ensure']))
  end

  it 'configures the task with the provided arguments if specified' do
    argument_names = %i[deployment_identifier region]

    namespace :something do
      described_class.define(argument_names: argument_names)
    end

    expect(Rake::Task['something:idiomise'].arg_names)
      .to(eq(argument_names))
  end

  it 'executes kibit on invocation' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:kibit))

    namespace :something do
      described_class.define
    end

    Rake::Task['something:idiomise'].invoke

    expect(RubyLeiningen)
      .to(have_received(:kibit)
            .with(
              replace: nil,
              interactive: nil,
              reporter: nil,
              paths: nil,
              profile: nil,
              environment: nil
            ))
  end

  it 'uses the provided value for replace when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:kibit))

    namespace :something do
      described_class.define(replace: true)
    end

    Rake::Task['something:idiomise'].invoke

    expect(RubyLeiningen)
      .to(have_received(:kibit)
            .with(
              replace: true,
              interactive: nil,
              reporter: nil,
              paths: nil,
              profile: nil,
              environment: nil
            ))
  end

  it 'uses the provided value for interactive when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:kibit))

    namespace :something do
      described_class.define(interactive: true)
    end

    Rake::Task['something:idiomise'].invoke

    expect(RubyLeiningen)
      .to(have_received(:kibit)
            .with(
              replace: nil,
              interactive: true,
              reporter: nil,
              paths: nil,
              profile: nil,
              environment: nil
            ))
  end

  it 'uses the provided reporter when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:kibit))

    namespace :something do
      described_class.define(reporter: 'markdown')
    end

    Rake::Task['something:idiomise'].invoke

    expect(RubyLeiningen)
      .to(have_received(:kibit)
            .with(
              replace: nil,
              interactive: nil,
              reporter: 'markdown',
              paths: nil,
              profile: nil,
              environment: nil
            ))
  end

  it 'uses the provided paths when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:kibit))

    namespace :something do
      described_class.define(
        paths: %w[path/to/src/clj/ path/to/src/cljs/util.cljs]
      )
    end

    Rake::Task['something:idiomise'].invoke

    expect(RubyLeiningen)
      .to(have_received(:kibit)
            .with(
              replace: nil,
              interactive: nil,
              reporter: nil,
              paths: %w[path/to/src/clj/ path/to/src/cljs/util.cljs],
              profile: nil,
              environment: nil
            ))
  end

  it 'uses the provided profile when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:kibit))

    namespace :something do
      described_class.define(profile: 'test')
    end

    Rake::Task['something:idiomise'].invoke

    expect(RubyLeiningen)
      .to(have_received(:kibit)
            .with(
              replace: nil,
              interactive: nil,
              reporter: nil,
              paths: nil,
              profile: 'test',
              environment: nil
            ))
  end

  it 'uses the provided environment when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:kibit))

    namespace :something do
      described_class.define(environment: { 'VAR' => 'val' })
    end

    Rake::Task['something:idiomise'].invoke

    expect(RubyLeiningen)
      .to(have_received(:kibit)
            .with(
              replace: nil,
              interactive: nil,
              reporter: nil,
              paths: nil,
              profile: nil,
              environment: { 'VAR' => 'val' }
            ))
  end

  # rubocop:disable RSpec/MultipleExpectations
  it 'changes directory if the directory parameter is specified' do
    stub_output

    directory = 'some/other/directory'

    allow(Dir).to(receive(:chdir).and_yield)
    allow(RubyLeiningen).to(receive(:kibit))

    namespace :something do
      described_class.define(directory: directory)
    end

    Rake::Task['something:idiomise'].invoke

    expect(Dir)
      .to(have_received(:chdir)
            .with(directory))
    expect(RubyLeiningen)
      .to(have_received(:kibit))
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
