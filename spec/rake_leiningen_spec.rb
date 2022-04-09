# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RakeLeiningen do
  it 'has a version number' do
    expect(RakeLeiningen::VERSION).not_to be_nil
  end

  describe 'define_check_tasks' do
    context 'when instantiating RakeLeiningen::TaskSets::Checks' do
      # rubocop:disable RSpec/MultipleExpectations
      it 'passes the provided block' do
        opts = { profile: 'test', fix: true }

        block = lambda do |t|
          t.directory = 'my-module'
        end

        allow(RakeLeiningen::TaskSets::Checks).to(receive(:define))

        described_class.define_check_tasks(opts, &block)

        expect(RakeLeiningen::TaskSets::Checks)
          .to(have_received(:define) do |passed_opts, &passed_block|
            expect(passed_opts).to(eq(opts))
            expect(passed_block).to(eq(block))
          end)
      end
      # rubocop:enable RSpec/MultipleExpectations
    end
  end

  describe 'define_build_task' do
    context 'when instantiating RakeLeiningen::Tasks::Build' do
      # rubocop:disable RSpec/MultipleExpectations
      it 'passes the provided block' do
        opts = { profile: 'test' }

        block = lambda do |t|
          t.main_namespace = 'some.namespace'
        end

        allow(RakeLeiningen::Tasks::Build).to(receive(:define))

        described_class.define_build_task(opts, &block)

        expect(RakeLeiningen::Tasks::Build)
          .to(have_received(:define) do |passed_opts, &passed_block|
            expect(passed_opts).to(eq(opts))
            expect(passed_block).to(eq(block))
          end)
      end
      # rubocop:enable RSpec/MultipleExpectations
    end
  end

  describe 'define_release_task' do
    context 'when instantiating RakeLeiningen::Tasks::Release' do
      # rubocop:disable RSpec/MultipleExpectations
      it 'passes the provided block' do
        opts = { profile: 'pre' }

        block = lambda do |t|
          t.level = ':rc'
        end

        allow(RakeLeiningen::Tasks::Release).to(receive(:define))

        described_class.define_release_task(opts, &block)

        expect(RakeLeiningen::Tasks::Release)
          .to(have_received(:define) do |passed_opts, &passed_block|
            expect(passed_opts).to(eq(opts))
            expect(passed_block).to(eq(block))
          end)
      end
      # rubocop:enable RSpec/MultipleExpectations
    end
  end

  describe 'define_start_task' do
    context 'when instantiating RakeLeiningen::Tasks::Start' do
      # rubocop:disable RSpec/MultipleExpectations
      it 'passes the provided block' do
        opts = { profile: 'test' }

        block = lambda do |t|
          t.main_function = 'some.namespace/main'
        end

        allow(RakeLeiningen::Tasks::Start).to(receive(:define))

        described_class.define_start_task(opts, &block)

        expect(RakeLeiningen::Tasks::Start)
          .to(have_received(:define) do |passed_opts, &passed_block|
            expect(passed_opts).to(eq(opts))
            expect(passed_block).to(eq(block))
          end)
      end
      # rubocop:enable RSpec/MultipleExpectations
    end
  end

  describe 'define_test_task' do
    context 'when instantiating RakeLeiningen::Tasks::Test' do
      # rubocop:disable RSpec/MultipleExpectations
      it 'passes the provided block' do
        opts = { type: 'unit', profile: 'test' }

        block = lambda do |t|
          t.files = %w[some/file/first.clj some/file/second.clj]
        end

        allow(RakeLeiningen::Tasks::Test).to(receive(:define))

        described_class.define_test_task(opts, &block)

        expect(RakeLeiningen::Tasks::Test)
          .to(have_received(:define) do |passed_opts, &passed_block|
            expect(passed_opts).to(eq(opts))
            expect(passed_block).to(eq(block))
          end)
      end
      # rubocop:enable RSpec/MultipleExpectations
    end
  end

  describe 'define_installation_tasks' do
    context 'when configuring RubyLeiningen' do
      it 'sets the binary using a path of `pwd`/vendor/leiningen by default' do
        described_class.define_installation_tasks

        expect(RubyLeiningen.configuration.binary)
          .to(eq("#{Dir.pwd}/vendor/leiningen/bin/lein"))
      end

      it 'uses the supplied path when provided' do
        described_class.define_installation_tasks(
          path: 'tools/lein'
        )

        expect(RubyLeiningen.configuration.binary)
          .to(eq('tools/lein/bin/lein'))
      end
    end

    context 'when instantiating RakeDependencies::Tasks::All' do
      it 'sets the namespace to leiningen by default' do
        task_set = described_class.define_installation_tasks

        expect(task_set.namespace).to(eq('leiningen'))
      end

      it 'uses the supplied namespace when provided' do
        task_set = described_class.define_installation_tasks(
          namespace: :tools_lein
        )

        expect(task_set.namespace).to(eq('tools_lein'))
      end

      it 'sets the dependency to lein' do
        task_set = described_class.define_installation_tasks

        expect(task_set.dependency).to(eq('lein'))
      end

      it 'sets the version to 2.9.1 by default' do
        task_set = described_class.define_installation_tasks

        expect(task_set.version).to(eq('2.9.1'))
      end

      it 'uses the supplied version when provided' do
        task_set = described_class.define_installation_tasks(version: '2.7.1')

        expect(task_set.version).to(eq('2.7.1'))
      end

      it 'uses a path of vendor/leiningen by default' do
        task_set = described_class.define_installation_tasks

        expect(task_set.path).to(eq("#{Dir.pwd}/vendor/leiningen"))
      end

      it 'uses the supplied path when provided' do
        task_set = described_class.define_installation_tasks(
          path: File.join('tools', 'lein')
        )

        expect(task_set.path).to(eq('tools/lein'))
      end

      # TODO: test needs_fetch more thoroughly
      it 'provides a needs_fetch checker' do
        task_set = described_class.define_installation_tasks

        expect(task_set.needs_fetch).not_to(be_nil)
      end

      it 'uses a type of tgz' do
        task_set = described_class.define_installation_tasks

        expect(task_set.type).to(eq(:uncompressed))
      end

      it 'uses the correct URI template' do
        task_set = described_class.define_installation_tasks

        expect(task_set.uri_template)
          .to(eq('https://raw.githubusercontent.com/technomancy/' \
                 'leiningen/<%= @version %>/bin/lein'))
      end

      it 'uses the correct file name template' do
        task_set = described_class.define_installation_tasks

        expect(task_set.file_name_template).to(eq('lein'))
      end
    end
  end
end
