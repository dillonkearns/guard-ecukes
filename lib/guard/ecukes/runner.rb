module Guard
  class Ecukes

    # The Ecukes runner handles the execution of the ecukes binary.
    #
    module Runner
      class << self

        # Run the supplied features.
        #
        # @param [Array<String>] paths the feature files or directories
        # @param [Hash] options the options for the execution
        # @option options [String] :command_prefix allows adding an additional prefix to the ecukes command.
        # @return [Boolean] the status of the execution
        #
        def run(paths, options = { })
          return false if paths.empty?

          message = options[:message] || (paths == ['features'] ? "Running all Ecukes features: #{ ecukes_command(paths, options) }" : "Running Ecukes features: #{ ecukes_command(paths, options) }")

          UI.info message, :reset => true

          system(ecukes_command(paths, options))
        end

        private

        # Assembles the Ecukes command from the passed options.
        #
        # @param [Array<String>] paths the feature files or directories
        # @param [Hash] options the options for the execution
        # @option options [String] :command_prefix allows adding an additional prefix to the ecukes command.
        # @return [String] the Ecukes command
        #
        def ecukes_command(paths, options)
          cmd = []
          cmd << options[:command_prefix] if options[:command_prefix]
          cmd << 'cask exec ecukes'
          cmd << options[:cli] if options[:cli]
          (cmd + paths).join(' ')
        end

      end
    end
  end
end
