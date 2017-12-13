require File.expand_path('../test_helper', __FILE__)
require 'minitest/autorun'

class TemplateEscapedTest < MiniTest::Test
  include TestHelper

  def setup
    @cabler = TestHelper.configure
  end

  def teardown
    TestHelper.unload_cabling
  end

  def test_cable_not_escaped
    @cabler.configure

    config_yml = TestHelper.load_test_config_yml
    assert_equal(1, config_yml['escaped']['not_escaped'])
  end

  def test_cable_escaped
    @cabler.configure

    random_val = '%s-%s-%s' % [ $$, Time.now.to_i, Random.rand(100000) ]
    config_yml = TestHelper.load_test_config_yml(random_val)

    assert_equal(random_val, config_yml['escaped']['escaped'])
  end
end
