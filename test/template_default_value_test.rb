require File.expand_path('../test_helper', __FILE__)
require 'minitest/autorun'

class TemplateDefaultValueTest < MiniTest::Test
  include TestHelper

  def setup
    @cabler = TestHelper.configure
  end

  def teardown
    TestHelper.unload_cabling
  end

  def test_cable_use_default_value
    @cabler.configure

    config_yml = TestHelper.load_test_config_yml
    assert_equal('default_value', config_yml['use_default_value']['value'])
  end
end
