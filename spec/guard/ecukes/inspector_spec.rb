require 'spec_helper'

describe Guard::Ecukes::Inspector do

  let(:inspector) { Guard::Ecukes::Inspector }

  describe '.clean' do
    context 'with the standard feature set' do
      before do
        Dir.stub(:glob).and_return %w(features/a.feature features/subfolder/b.feature)
      end

      it 'removes non-feature files' do
        inspector.clean(%w(features/a.feature b.rb)).should == %w(features/a.feature)
      end

      it 'removes non-existing feature files' do
        inspector.clean(%w(features/a.feature features/x.feature)).should == %w(features/a.feature)
      end

      it 'keeps a feature folder' do
        inspector.clean(%w(features/a.feature features/subfolder)).should == %w(features/a.feature features/subfolder)
      end

      it 'removes duplicate paths' do
        inspector.clean(%w(features features)).should == %w(features)
      end

      it 'removes individual feature tests if the path is already in paths to run' do
        inspector.clean(%w(features/a.feature features/a.feature:10)).should == %w(features/a.feature)
      end

      it 'removes feature folders included in other feature folders' do
        inspector.clean(%w(features/subfolder features)).should == %w(features)
      end

      it 'removes feature files includes in feature folder' do
        inspector.clean(%w(features/subfolder/b.feature features)).should == %w(features)
      end
    end

  end
end
