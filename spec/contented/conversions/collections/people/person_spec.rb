require 'spec_helper'
include Contented::Conversions::Collections::People

describe Person do
  subject(:person) { Person.new(peoplesync_data) }

  context "when an empty JSON object is given as input" do
    let(:peoplesync_data) { "{}" }

    its(:netid) { is_expected.to be_nil }
    its(:last_name) { is_expected.to be_nil }
    its(:first_name) { is_expected.to be_nil }
    its(:work_phone) { is_expected.to be_nil }
    its(:email_address) { is_expected.to be_nil }
    its("all_positions_jobs") { is_expected.to be_empty }
    its("instance_variables.size") { is_expected.to eql 1 }
  end

  context "when proper PeopleSync data is given as unput" do
    let(:peoplesync_data) { FactoryGirl.build(:peoplesync).to_json }

    its(:netid) { is_expected.to eql 'xx123' }
    its(:last_name) { is_expected.to eql 'Diderot' }
    its(:first_name) { is_expected.to eql 'Denis' }
    its(:work_phone) { is_expected.to eql '+1 (555) 5555555' }
    its(:email_address) { is_expected.to eql 'lib-no-reply@nyu.edu' }
    its("all_positions_jobs") { is_expected.to be_a Array }
    its("all_positions_jobs.first") { is_expected.to include "Position_Work_Space" => "New York > Bobst Library > LITS > Web Services" }
    its("instance_variables.size") { is_expected.to eql 6 }
  end
end
