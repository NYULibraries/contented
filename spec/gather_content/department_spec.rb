require 'spec_helper'

describe GatherContent::Department do
  let(:project_id) { '57459' }
  let(:json_string) { File.read(File.join(File.dirname(__FILE__), '../fixtures/department.json')) }
  let(:department) { GatherContent::Department.new(json_string) }
  describe '#title' do
    subject { department.title }
    it { is_expected.to eql 'Web Services' }
  end
  describe '#body' do
    subject { department.body }
    it { is_expected.to eql "We provide administrative management and technical support for the Libraries’ website and BobCat, its primary discovery interface. We also develop and maintain web-based services and special projects." }
  end
  describe '#location' do
    subject { department.location }
    it { is_expected.to eql 'Elmer Holmes Bobst Library' }
  end
  describe '#space' do
    subject { department.space }
    it { is_expected.to eql 'Room 511, Research Commons, 5th Floor South' }
  end
  describe '#email' do
    subject { department.email }
    it { is_expected.to eql 'lib-webservices@nyu.edu' }
  end
  describe '#phone' do
    subject { department.phone }
    it { is_expected.to eql '(212) 000-0000'  }
  end
  describe '#twitter' do
    subject { department.twitter }
    it { is_expected.to eql 'libtechnyu'  }
  end
  describe '#facebook' do
    subject { department.facebook }
    it { is_expected.to eql 'libtechnyu'  }
  end
  describe '#blog' do
    subject { department.blog }
    it { is_expected.to include(title: 'libtechnyu Blog', link: 'http://web1.library.nyu.edu/libtechnyu/', rss: 'http://web1.library.nyu.edu/libtechnyu/atom.xml' )  }
  end
  describe '#libcal_id' do
    subject { department.libcal_id }
    it { is_expected.to eql '1234'  }
  end
  describe '#libanswers_id' do
    subject { department.libanswers_id }
    it { is_expected.to be_nil  }
  end
  describe '#links' do
    subject { department.links }
    it { is_expected.to include("@NYULibraries on GitHub"=>"https://github.com/NYULibraries") }
    it { is_expected.to include("libtechnyu Blog"=>"http://web1.library.nyu.edu/libtechnyu/") }
    it { is_expected.to include("The Agile Manifesto"=>"http://agilemanifesto.org/") }
  end
  describe '#buttons' do
    subject { department.buttons }
    it { is_expected.to include("Request an Appointment" => "http://www.example.org") }
  end
  describe '#to_markdown' do
    subject { department.to_markdown }
    it { is_expected.to be_a String }
  end
end
