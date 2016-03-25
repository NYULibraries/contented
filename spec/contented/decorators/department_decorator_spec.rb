require 'spec_helper'

describe Contented::Decorators::DepartmentDecorator, vcr: true do
  let(:item_id) { '2027930' }
  let(:department) { Contented::Department.new(item_id) }
  let(:department_decorator) { Contented::Decorators::DepartmentDecorator.new(department) }
  describe '#matches_email?' do
    subject { department_decorator.send(:matches_email?, str) }
    context 'when string passed in is an email' do
      let(:str) { 'test@nyu.edu' }
      it { is_expected.to be true }
    end
    context 'when string passed in is a link' do
      let(:str) { 'http://www.eample.org' }
      it { is_expected.to be false }
    end
  end
  describe '#title' do
    subject { department_decorator.title }
    context 'when title is found under Department Name' do
      before { allow(department_decorator).to receive(:find_element_by).with(section: :contact_info, type: 'choice_radio', label: 'Department Name').and_return("Web Services") }
      it { is_expected.to eql 'Web Services' }
    end
    context 'when title is found under Other' do
      before do
        allow(department_decorator).to receive(:find_element_by).with(section: :contact_info, type: 'choice_radio', label: 'Department Name').and_return("Other")
        allow(department_decorator).to receive(:find_element_by).with(section: :contact_info, type: 'choice_radio', label: 'Department Name', value: true).and_return("Web Dev")
      end
      it { is_expected.to eql 'Web Dev' }
    end
  end
  describe '#blog' do
    subject { department_decorator.blog }
    context 'when blog is found' do
      before { allow(department_decorator).to receive(:find_element_by).with(section: :social_media, type: 'text', label: 'Blog').and_return("title: 'Title'\nlink: 'Link'\nrss: 'rss'") }
      it { is_expected.to include {title:"Title", link:"Link", rss:"rss"} }
    end
    context 'when blog is empty' do
      before { allow(department_decorator).to receive(:find_element_by).with(section: :social_media, type: 'text', label: 'Blog').and_return(nil) }
      it { is_expected.to be_nil }
    end
  end
  describe '#floor' do
    subject { department_decorator.send(:floor) }
    context 'when floor is found under Floor' do
      before { allow(department_decorator).to receive(:find_element_by).with(section: :contact_info, type: 'choice_checkbox', label: "Floor").and_return("1st Fl") }
      it { is_expected.to eql '1st Fl' }
    end
    context 'when floor is found under Other' do
      before do
        allow(department_decorator).to receive(:find_element_by).with(section: :contact_info, type: 'choice_checkbox', label: "Floor").and_return("Other")
        allow(department_decorator).to receive(:find_element_by).with(section: :contact_info, type: 'text', label: "If you selected 'Other' please write your floor number below").and_return("My floor")
      end
      it { is_expected.to eql 'My floor' }
    end
  end
  describe ''
  # before { allow(department).to receive(:title).and_return('Web Services') }
  # TITLE, SPACE, BLOG
end
