require 'spec_helper'

describe Guard::EcukesVersion do
  describe 'VERSION' do
    it 'defines the version' do
      Guard::EcukesVersion::VERSION.should match /\d+.\d+.\d+/
    end
  end
end
