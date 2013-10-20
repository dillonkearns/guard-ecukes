require 'spec_helper'

describe Guard::Ecukes::Runner do
  let(:runner) { Guard::Ecukes::Runner }

  before do
    Guard::UI.stub(:info)
    runner.stub(:system)
  end

  describe '#run' do
    context 'when passed an empty paths list' do
      it 'returns false' do
        runner.run([]).should be_false
      end
    end

    context 'with a paths argument' do

      it 'runs the given paths' do
        runner.should_receive(:system).with(
            /features\/foo\.feature features\/bar\.feature$/
        )
        runner.run(['features/foo.feature', 'features/bar.feature'])
      end
    end

    context 'with a :command_prefix option' do
      it 'executes ecukes with the command_prefix option' do
        runner.should_receive(:system).with(
            "xvfb-run cask exec ecukes features"
        )
        runner.run(['features'], { :command_prefix => "xvfb-run" })
      end
    end

    context 'with a :cli option' do
      it 'appends the cli arguments when calling ecukes' do
        runner.should_receive(:system).with(
            "cask exec ecukes --custom command features"
        )
        runner.run(['features'], { :cli => '--custom command' })
      end
    end

  end

end
