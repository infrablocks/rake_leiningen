require 'spec_helper'

RSpec.describe RakeLeiningen do
  it 'has a version number' do
    expect(RakeLeiningen::VERSION).not_to be nil
  end

  context 'define_installation_tasks' do
    context 'when instantiating RakeDependencies::Tasks::All' do
      it 'sets the namespace to leiningen by default' do
        task = stubbed_rake_dependencies_all_task

        expect(RakeDependencies::Tasks::All)
            .to(receive(:new).and_yield(task))

        expect(task).to(receive(:namespace=).with(:leiningen))

        RakeLeiningen.define_installation_tasks
      end

      it 'uses the supplied namespace when provided' do
        task = stubbed_rake_dependencies_all_task

        expect(RakeDependencies::Tasks::All)
            .to(receive(:new).and_yield(task))

        expect(task).to(receive(:namespace=).with(:tools_lein))

        RakeLeiningen.define_installation_tasks(
            namespace: :tools_lein)
      end

      it 'sets the dependency to lein' do
        task = stubbed_rake_dependencies_all_task

        expect(RakeDependencies::Tasks::All)
            .to(receive(:new).and_yield(task))

        expect(task).to(receive(:dependency=).with('lein'))

        RakeLeiningen.define_installation_tasks
      end

      it 'sets the version to 2.9.1 by default' do
        task = stubbed_rake_dependencies_all_task

        expect(RakeDependencies::Tasks::All)
            .to(receive(:new).and_yield(task))

        expect(task).to(receive(:version=).with('2.9.1'))

        RakeLeiningen.define_installation_tasks
      end

      it 'uses the supplied version when provided' do
        task = stubbed_rake_dependencies_all_task

        expect(RakeDependencies::Tasks::All)
            .to(receive(:new).and_yield(task))

        expect(task).to(receive(:version=).with('2.7.1'))

        RakeLeiningen.define_installation_tasks(
            version: '2.7.1')
      end

      it 'uses a path of vendor/leiningen by default' do
        task = stubbed_rake_dependencies_all_task

        expect(RakeDependencies::Tasks::All)
            .to(receive(:new).and_yield(task))

        expect(task).to(receive(:path=).with('vendor/leiningen'))

        RakeLeiningen.define_installation_tasks
      end

      it 'uses the supplied path when provided' do
        task = stubbed_rake_dependencies_all_task

        expect(RakeDependencies::Tasks::All)
            .to(receive(:new).and_yield(task))

        expect(task).to(receive(:path=).with('tools/lein'))

        RakeLeiningen.define_installation_tasks(
            path: File.join('tools', 'lein'))
      end

      # TODO: test needs_fetch more thoroughly
      it 'provides a needs_fetch checker' do
        task = stubbed_rake_dependencies_all_task

        expect(RakeDependencies::Tasks::All)
            .to(receive(:new).and_yield(task))

        expect(task).to(receive(:needs_fetch=))

        RakeLeiningen.define_installation_tasks
      end

      it 'uses a type of tgz' do
        task = stubbed_rake_dependencies_all_task

        expect(RakeDependencies::Tasks::All)
            .to(receive(:new).and_yield(task))

        expect(task).to(receive(:type=).with(:uncompressed))

        RakeLeiningen.define_installation_tasks
      end

      it 'uses the correct URI template' do
        task = stubbed_rake_dependencies_all_task

        expect(RakeDependencies::Tasks::All)
            .to(receive(:new).and_yield(task))

        expect(task)
            .to(receive(:uri_template=)
                .with('https://raw.githubusercontent.com/technomancy/' +
                    'leiningen/<%= @version %>/bin/lein'))

        RakeLeiningen.define_installation_tasks
      end

      it 'uses the correct file name template' do
        task = stubbed_rake_dependencies_all_task

        expect(RakeDependencies::Tasks::All)
            .to(receive(:new).and_yield(task))

        expect(task)
            .to(receive(:file_name_template=)
                .with('lein'))

        RakeLeiningen.define_installation_tasks
      end
    end
  end
end

def double_allowing(*messages)
  instance = double
  messages.each do |message|
    allow(instance).to(receive(message))
  end
  instance
end

def stubbed_rake_dependencies_all_task
  double_allowing(
      :namespace=, :dependency=, :version=, :path=, :type=, :os_ids=,
      :uri_template=, :file_name_template=,
      :source_binary_name_template=, :target_binary_name_template=,
      :needs_fetch=)
end
