require 'guard'
require 'guard/guard'
require 'guard/ecukes/version'

module Guard

  # The Ecukes guard that gets notifications about the following
  # Guard events: `start`, `stop`, `reload`, `run_all` and `run_on_change`.
  #
  class Ecukes < Guard

    autoload :Runner, 'guard/ecukes/runner'
    autoload :Inspector, 'guard/ecukes/inspector'
    autoload :Focuser, 'guard/ecukes/focuser'

    # Initialize Guard::Ecukes.
    #
    # @param [Array<Guard::Watcher>] watchers the watchers in the Guard block
    # @param [Hash] options the options for the Guard
    # @option options [String] :cli any arbitrary Ecukes CLI arguments
    # @option options [Boolean] :all_after_pass run all features after changed features pass
    # @option options [Boolean] :all_on_start run all the features at startup
    # @option options [Boolean] :run_all run override any option when running all specs
    #
    def initialize(watchers = [], options = {})
      super

      @options = {
          :all_after_pass => true,
          :all_on_start   => true,
      }.update(options)

      @last_failed  = false
    end

    # Gets called once when Guard starts.
    #
    # @raise [:task_has_failed] when stop has failed
    #
    def start
      run_all if @options[:all_on_start]
    end

    # Gets called when all specs should be run.
    #
    # @raise [:task_has_failed] when stop has failed
    #
    def run_all
      passed = Runner.run(['features'], @options.merge(@options[:run_all] || {}).merge(:message => 'Running all features'))

      @last_failed = !passed

      throw :task_has_failed unless passed
    end

    # Gets called when the Guard should reload itself.
    #
    # @raise [:task_has_failed] when stop has failed
    #
    def reload
    end

    # Gets called when watched paths and files have changes.
    #
    # @param [Array<String>] paths the changed paths and files
    # @raise [:task_has_failed] when stop has failed
    #
    def run_on_changes(paths)
      paths   = Inspector.clean(paths)
      passed  = Runner.run(paths, paths.include?('features') ? @options.merge({ :message => 'Running all features' }) : @options)

      if passed
        # run all the specs if the changed specs failed, like autotest
        run_all if @last_failed && @options[:all_after_pass]
      else
        # track whether the changed feature failed for the next change
        @last_failed = true
      end

      throw :task_has_failed unless passed
    end

  end
end
