require 'spec_helper'

describe Contented::SwiftypeSync do

  it { should be_const_defined(:PEOPLE_DIR_NAME) }
  it { should be_const_defined(:PEOPLE_URL_BASE) }
  it { should be_const_defined(:SERVICES_DIR_NAME) }
  it { should be_const_defined(:SERVICES_URL_BASE) }
  it { should be_const_defined(:LOCATIONS_DIR_NAME) }
  it { should be_const_defined(:LOCATIONS_URL_BASE) }

end
