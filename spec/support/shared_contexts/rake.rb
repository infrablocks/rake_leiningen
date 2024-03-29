# frozen_string_literal: true

require 'rake'
require 'fakefs/spec_helpers'
require 'active_support'
require 'active_support/core_ext/string/inflections'

# rubocop:disable RSpec/ContextWording
shared_context 'rake' do
  include Rake::DSL if defined?(Rake::DSL)
  include FakeFS::SpecHelpers

  subject { self.class.top_level_description.constantize }

  let(:rake) { Rake::Application.new }

  before do
    Rake.application = rake
  end

  before do
    Rake::Task.clear
  end
end
# rubocop:enable RSpec/ContextWording
