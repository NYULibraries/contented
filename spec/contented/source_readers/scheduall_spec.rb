require 'spec_helper'
require 'yaml'

describe Contented::SourceReaders::Scheduall do
  let(:driver) { double 'driver' }
  let(:host_credentials) { Hash.new host: 'host.nyu.edu', password: 'password', username: 'nyuser' }

  # allow(driver).to receive(:execute) do
  #   yml = File.read('./spec/fixtures/scheduall_technology.yml')
  #   YAML.safe_load(yml)
  # end

  before(:each) do
    Contented::SourceReaders::Scheduall.class_variable_set :@@driver, driver
  end

  describe '#initialize' do
    let(:scheduall) { Contented::SourceReaders::Scheduall.new(host_credentials) }
    let(:driver_client) { double('driver_client') }

    before do
      allow(driver).to receive(:new).and_return driver_client
    end

    it 'sets @client to driver' do
      expect(scheduall.client).to be driver_client
    end

    it 'sets @data to nil' do
      expect(scheduall.data).to be(nil)
    end
  end
  #
  # describe '#close' do
  #
  # end
  #
  # describe '#buildings' do
  #
  # end
  #
  # describe '#rooms' do
  # end
  #
  # describe '#equipment' do
  #
  # end
end
