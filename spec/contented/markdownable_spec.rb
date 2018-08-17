require 'spec_helper'

describe Contented::Markdownable do
  class DummyClass; end
  let(:dummy_instance) { DummyClass.new }
  let(:rendered) { 'This is a rendered document' }
  before { dummy_instance.extend(Contented::Markdownable) }

  describe "#to_liquid_hash" do
    subject { dummy_instance.to_liquid_hash }

    it 'raises an error' do
      expect{ subject }.to raise_error(RuntimeError)
    end

    context "with including class method defined" do
      before { dummy_instance.define_singleton_method(:to_liquid_hash, -> { true }) }

      it { is_expected.to be true }
    end
  end

  describe '#filename' do
    subject { dummy_instance.filename }

    it 'raises an error' do
      expect{ subject }.to raise_error(RuntimeError)
    end

    context "with including class method defined" do
      before { dummy_instance.define_singleton_method(:filename, -> { true }) }

      it { is_expected.to be true }
    end
  end

  describe "#template_file" do
    subject { dummy_instance.send(:template_file) }

    it { is_expected.to eql 'dummy_class' }
  end

  describe "#to_markdown" do
    subject { dummy_instance.send(:to_markdown) }

    before do
      dummy_instance.stub(:to_liquid_hash) { true }
      liquid_template_parsed = double('liquid_template', render: rendered, errors: [])
      stub_const "Liquid::Template", double(parse: liquid_template_parsed)
      stub_const "File", double('File', read: true)
    end

    it { is_expected.to eql rendered }
  end

  describe "#save_as_markdown!" do
    subject { dummy_instance.save_as_markdown!(save_location: './output') }

    before do
      dummy_instance.stub(to_markdown: rendered)
      dummy_instance.stub(filename: 'output_file')
      class_double("File", write: true).as_stubbed_const
    end

    it { is_expected.to be true }
  end
end
