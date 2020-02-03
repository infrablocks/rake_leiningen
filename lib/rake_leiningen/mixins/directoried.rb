module RakeLeiningen
  module Mixins
    module Directoried
      def in_directory(directory, &block)
        if directory
          Dir.chdir(directory, &block)
        else
          block.call
        end
      end
    end
  end
end