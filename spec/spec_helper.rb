require 'rspec/its'
require 'coveralls'
Coveralls.wear!
require 'pry'
require 'contented'
require 'yaml'

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f }

RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

def load_yaml(filename)
  yml = File.read(filename)
  YAML.safe_load(yml)
end

# SOURCE: https://github.com/amogil/rspec-deep-ignore-order-matcher
RSpec::Matchers.define :be_deep_equal do |expected|
  match { |actual| match? actual, expected }

  failure_message do |actual|
    "expected that #{actual} would be deep equal with #{expected}"
  end

  failure_message_when_negated do |actual|
    "expected that #{actual} would not be deep equal with #{expected}"
  end

  description do
    "be deep equal with #{expected}"
  end

  def match?(actual, expected)
    return arrays_match?(actual, expected) if expected.is_a?(Array) && actual.is_a?(Array)
    return hashes_match?(actual, expected) if expected.is_a?(Hash) && actual.is_a?(Hash)
    expected == actual
  end

  def arrays_match?(actual, expected)
    exp = expected.clone
    actual.each do |a|
      index = exp.find_index { |e| match? a, e }
      return false if index.nil?
      exp.delete_at(index)
    end
    exp.empty?
  end

  def hashes_match?(actual, expected)
    return false unless actual.keys.sort == expected.keys.sort
    actual.each { |key, value| return false unless match? value, expected[key] }
    true
  end
end
