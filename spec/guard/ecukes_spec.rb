require 'spec_helper'

describe Guard::Ecukes do

  before do
    Dir.stub(:glob).and_return ['features/a.feature', 'features/subfolder/b.feature']
  end

  let(:default_options) do
    {
        :all_after_pass => true,
        :all_on_start   => true,
    }
  end

  let(:guard) { Guard::Ecukes.new }
  let(:runner) { Guard::Ecukes::Runner }

  describe '#initialize' do
    context 'when no options are provided' do
      it 'sets a default :all_after_pass option' do
        guard.options[:all_after_pass].should be_true
      end

      it 'sets a default :all_on_start option' do
        guard.options[:all_on_start].should be_true
      end
    end

    context 'with other options than the default ones' do
      let(:guard) { Guard::Ecukes.new(nil, { :all_after_pass => false,
                                               :all_on_start   => false,
                                               :cli            => '--timeout 12' }) }

      it 'sets the provided :all_after_pass option' do
        guard.options[:all_after_pass].should be_false
      end

      it 'sets the provided :all_on_start option' do
        guard.options[:all_on_start].should be_false
      end

      it 'sets the provided :cli option' do
        guard.options[:cli].should eql '--timeout 12'
      end

    end
  end

  describe '#start' do
    it 'calls #run_all' do
      runner.should_receive(:run).with(['features'], default_options.merge(:message => 'Running all features')).and_return(true)
      guard.start
    end

    context 'with the :all_on_start option is false' do
      let(:guard) { Guard::Ecukes.new([], :all_on_start => false) }

      it 'does not call #run_all' do
        runner.should_not_receive(:run).with(['features'], default_options.merge(:all_on_start => false,
                                                                                 :message      => 'Running all features'))
        guard.start
      end
    end
  end

  describe '#run_all' do
    it 'runs all features' do
      runner.should_receive(:run).with(['features'], default_options.merge(:message => 'Running all features')).and_return(true)
      guard.run_all
    end

    it 'cleans failed memory if passed' do
      runner.should_receive(:run).with(['features/foo'], default_options).and_return(false)
      expect { guard.run_on_changes(['features/foo']) }.to throw_symbol :task_has_failed
      runner.should_receive(:run).with(['features'], default_options.merge(:message => 'Running all features')).and_return(true)
      runner.should_receive(:run).with(['features/bar'], default_options).and_return(true)
      guard.run_on_changes(['features/bar'])
    end

    context 'with the :cli option' do
      let(:guard) { Guard::Ecukes.new([], { :cli => '--win' }) }

      it 'directly passes :cli option to runner' do
        runner.should_receive(:run).with(['features'], default_options.merge(:cli     => '--win',
                                                                             :message => 'Running all features')).and_return(true)
        guard.run_all
      end
    end

    context 'with a :run_all option' do
      let(:guard) { Guard::Ecukes.new([], { :cli => '--reporter progress' }) }

      it 'allows the :run_all options to override the default_options' do
        runner.should_receive(:run).with(anything, hash_including(:cli => '--reporter progress')).and_return(true)
        guard.run_all
      end
    end
  end

  describe '#reload' do
    it 'clears failed_path' do
      runner.should_receive(:run).with(['features/foo'], default_options).and_return(false)
      expect { guard.run_on_changes(['features/foo']) }.to throw_symbol :task_has_failed
      guard.reload
      runner.should_receive(:run).with(['features/bar'], default_options).and_return(true)
      runner.should_receive(:run).with(['features'], default_options.merge(:message => 'Running all features')).and_return(true)
      guard.run_on_changes(['features/bar'])
    end
  end

  describe '#run_on_changes' do
    it 'runs ecukes with all features' do
      runner.should_receive(:run).with(['features'], default_options.merge(:message => 'Running all features')).and_return(true)
      guard.run_on_changes(['features'])
    end

    it 'runs ecukes with single feature' do
      runner.should_receive(:run).with(['features/a.feature'], default_options).and_return(true)
      guard.run_on_changes(['features/a.feature'])
    end

    it 'passes the matched paths to the inspector for cleanup' do
      runner.stub(:run).and_return(true)
      Guard::Ecukes::Inspector.should_receive(:clean).with(['features']).and_return ['features']
      guard.run_on_changes(['features'])
    end

    it 'calls #run_all if the changed specs pass after failing' do
      runner.should_receive(:run).with(['features/foo'], default_options).and_return(false, true)
      runner.should_receive(:run).with(['features'], default_options.merge(:message => 'Running all features')).and_return(true)
      expect { guard.run_on_changes(['features/foo']) }.to throw_symbol :task_has_failed
      guard.run_on_changes(['features/foo'])
    end

    it 'does not call #run_all if the changed specs pass without failing' do
      runner.should_receive(:run).with(['features/foo'], default_options).and_return(true)
      runner.should_not_receive(:run).with(['features'], default_options.merge(:message => 'Running all features'))
      guard.run_on_changes(['features/foo'])
    end

    context 'with a :cli option' do
      let(:guard) { Guard::Ecukes.new([], { :cli => '--no-win' }) }

      it 'directly passes the :cli option to the runner' do
        runner.should_receive(:run).with(['features'], default_options.merge(:cli => '--no-win', :message => 'Running all features')).and_return(true)
        guard.run_on_changes(['features'])
      end
    end

    context 'when the :all_after_pass option is false' do
      let(:guard) { Guard::Ecukes.new([], :all_after_pass => false) }

      it 'does not call #run_all if the changed specs pass after failing but the :all_after_pass option is false' do
        runner.should_receive(:run).with(['features/foo'], default_options.merge(:all_after_pass => false)).and_return(false, true)
        runner.should_not_receive(:run).with(['features'], default_options.merge(:all_after_pass => false, :message => 'Running all features'))
        expect { guard.run_on_changes(['features/foo']) }.to throw_symbol :task_has_failed
        guard.run_on_changes(['features/foo'])
      end
    end

  end
end
