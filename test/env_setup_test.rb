require File.expand_path('../test_helper', __FILE__)
require 'minitest/autorun'

class EnvSetupTest < MiniTest::Test
  include TestHelper

  def setup
    @cli = TestHelper.simulate_after_cable
    @env = TestHelper.env_setup
  end

  def teardown
    TestHelper.unload_cabling
  end

  def test_env_target_is_test
    assert_equal('test', @env.target)
  end

  def test_env_location_is_nil
    assert_nil(@env.location)
  end

  def test_env_app_root_is_test_app_root
    assert_equal(TEST_APP_ROOT, @env.app_root)
  end

  def test_env_cablefile_is_test_cablefile
    assert_equal(TEST_CABLEFILE, @env.cablefile_path)
  end

  def test_env_lockfile_is_test_lockfile
    assert_equal(TEST_CABLING_LOCK, @env.lockfile_path)
  end
end
