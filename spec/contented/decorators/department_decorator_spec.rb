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
end
