require 'palmade/cableguy'

module Cableguy
  def self.target
    env.target
  end

  def self.location
    env.location
  end

  def self.app_root
    env.app_root
  end

  def self.env; @@env; end
  def self.set_env(v); @@env = v; end
  @@env = nil

  def self.on(*targets)
    yield if targets.include?(env.target)
  end

  def self.on_location(*locations)
    yield if locations.include?(env.location)
  end
end
