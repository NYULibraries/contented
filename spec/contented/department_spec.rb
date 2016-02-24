require 'spec_helper'

describe Contented::Department, vcr: true do
  let(:item_id) { '2027930' }
  let(:department) { Contented::Department.new(item_id) }
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
    it { is_expected.to be_nil }
  end
  describe '#email' do
    subject { department.email }
    it { is_expected.to be_nil }
  end
  describe '#phone' do
    subject { department.phone }
    it { is_expected.to be_nil  }
  end
  describe '#twitter' do
    subject { department.twitter }
    it { is_expected.to eql 'libtechnyu'  }
  end
  describe '#facebook' do
    subject { department.facebook }
    it { is_expected.to be_nil  }
  end
  describe '#blog' do
    subject { department.blog }
    it { is_expected.to include(title: "libtechnyu Blog", link: "http://web1.library.nyu.edu/libtechnyu/", rss: "http://web1.library.nyu.edu/libtechnyu/atom.xml" )  }
  end
  describe '#libcal_id' do
    subject { department.libcal_id }
    it { is_expected.to be_nil  }
  end
  describe '#libanswers_id' do
    subject { department.libanswers_id }
    it { is_expected.to be_nil  }
  end
  describe '#links' do
    subject { department.links }
    it { is_expected.to include("\"@NYULibraries on GitHub\""=>"https://github.com/NYULibraries") }
    it { is_expected.to include("\"libtechnyu Blog\""=>"http://web1.library.nyu.edu/libtechnyu/") }
    it { is_expected.to include("\"The Agile Manifesto\""=>"http://agilemanifesto.org/") }
  end
  describe '#buttons' do
    subject { department.buttons }
    it { is_expected.to be_nil }
  end
  describe '#filename' do
    subject { department.filename }
    it { is_expected.to eql 'web-services' }
  end
  describe '#to_markdown' do
    subject { department.to_markdown }
    it { is_expected.to be_a String }
    it { is_expected.to eql "---\ntitle: Web Services\nlocation: Elmer Holmes Bobst Library\nspace: \nemail: \nphone: \ntwitter: libtechnyu\nfacebook: \nsubtitle: \nclasses: \nkeywords: \nlibcal_id: \nlibanswers_id: \nblog:\n  title: libtechnyu Blog\n  link: http://web1.library.nyu.edu/libtechnyu/\n  rss: http://web1.library.nyu.edu/libtechnyu/atom.xml\nbuttons:\nlinks:\n  \"@NYULibraries on GitHub\": https://github.com/NYULibraries\n  \"libtechnyu Blog\": http://web1.library.nyu.edu/libtechnyu/\n  \"The Agile Manifesto\": http://agilemanifesto.org/\n---\n\n# What We Do\n\nWe provide administrative management and technical support for the Libraries’ website and BobCat, its primary discovery interface. We also develop and maintain web-based services and special projects." }
  end

end