require 'spec_helper'

RSpec.configure do |c|
  c.include Contented::Conversions::Collections::Helpers::MarkdownFieldHelpers
end

describe Contented::Conversions::Collections::Helpers::MarkdownFieldHelpers do
  let(:non_yaml_str) { "test string" }

  describe '#to_yaml_list' do
    subject { to_yaml_list(non_yaml_str) }
    context 'when string does not contain semi-colons' do
      it { is_expected.to eql "\n  - 'test string'" }
    end
    context 'when string does contain semi-colons' do
      context 'and those semi-colons are not nested within quotes' do
        let(:non_yaml_str) { "one;two"}
        it { is_expected.to eql "\n  - 'one'\n  - 'two'" }
      end
      context 'and those semi-colons are nested within quotes' do
        let(:non_yaml_str) { "'http://hello.edu?param=1&amp;quobene=me';test" }
        it { is_expected.to eql "\n  - 'http://hello.edu?param=1&amp;quobene=me'\n  - 'test'" }
      end
    end
    context 'when string contains quotes' do
      context 'but those quotes are not properly terminated' do
        let(:non_yaml_str) { "'test string" }
        it { is_expected.to eql "\n  - 'test string'"}
      end
      context 'and those quotes are properly terminated' do
        let(:non_yaml_str) { "'test string'" }
        it { is_expected.to eql "\n  - 'test string'"}
      end
    end
  end

  describe '#to_yaml_object' do
    subject { to_yaml_object(non_yaml_str) }
    context 'when string does not contain semi-colons' do
      it { is_expected.to eql "\n  test string" }
    end
    context 'when string does contain semi-colons' do
      context 'and those semi-colons are not nested within quotes' do
        let(:non_yaml_str) { "rss: test;title: oho"}
        it { is_expected.to eql "\n  rss: test\n  title: oho" }
      end
      context 'and those semi-colons are nested within quotes' do
        let(:non_yaml_str) { "rss: 'http://hello.edu?param=1&amp;quobene=me'" }
        it { is_expected.to eql "\n  rss: 'http://hello.edu?param=1&amp;quobene=me'" }
      end
    end
    context 'when string contains quotes' do
      context 'but those quotes are not properly terminated' do
        let(:non_yaml_str) { "rss: 'http://hello.edu" }
        it { is_expected.to eql "\n  rss: 'http://hello.edu'"}
      end
      context 'and those quotes are properly terminated' do
        let(:non_yaml_str) { "rss: 'http://hello.edu'" }
        it { is_expected.to eql "\n  rss: 'http://hello.edu'"}
      end
    end
  end

end
