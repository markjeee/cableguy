require 'cableguy'
require 'yaml'

module Palmade::Cableguy
  class Env
    include Palmade::Cableguy::Constants

    DEFAULT_OPTIONS = {
      :target => DEFAULT_TARGET,
      :location => DEFAULT_LOCATION,
      :app_root => nil
    }

    def self.setup(options = { })
      e = self.new(options).setup!

      ::Cableguy.set_env(e)
      ::Cableguy.env
    end

    def initialize(options = { })
      @options = DEFAULT_OPTIONS.merge(options)
    end

    def target
      @options[:target]
    end

    def location
      @options[:location]
    end

    def app_root
      @options[:app_root]
    end

    def cablefile_path
      @cablefile_path
    end

    def lockfile_path
      @lockfile_path
    end

    def cablefile_name
      DEFAULT_CABLEFILE_NAME
    end

    def lockfile_name
      DEFAULT_LOCK_FILE
    end

    def setup!
      if @options[:app_root].nil?
        @options[:app_root] = discover_app_root
      end

      @cablefile_path = File.join(@options[:app_root], cablefile_name)
      @lockfile_path = find_lock_file(@options[:app_root])

      unless @lockfile_path.nil?
        locked_values = load_locked_values(@lockfile_path)

        if locked_values.include?(:target)
          @options[:target] = locked_values[:target]
        end

        if locked_values.include?(:location)
          @options[:location] = locked_values[:location]
        end
      end

      self
    end

    def locked?
      !@lockfile_path.nil?
    end

    protected

    def discover_app_root
      app_root = nil

      if ENV.include?('CABLEGUY_CABLEFILE')
        cf_path = File.expand_path(ENV['CABLEGUY_CABLEFILE'])
        app_root = File.dirname(cf_path)
      else
        cf_path = find_cable_file(Dir.pwd)

        if cf_path.nil?
          app_root = Dir.pwd
        else
          app_root = File.dirname(cf_path)
        end
      end

      app_root
    end

    def find_cable_file(pwd)
      found = nil
      pname = Pathname.new(pwd)
      pname.ascend do |path|
        if File.exists?(File.join(path, cablefile_name))
          found = path
          break
        end
      end

      unless found.nil?
        cf_path = File.join(found.to_path, cablefile_name)
      else
        cf_path = nil
      end

      cf_path
    end

    def find_lock_file(app_root)
      lock_path = File.join(app_root, lockfile_name)

      unless File.exists?(lock_path)
        lock_path = nil
      end

      lock_path
    end

    def load_locked_values(lfp)
      if File.exists?(lfp)
        locked_values = YAML.load_file(lfp)
      else
        locked_values = { }
      end

      locked_values
    end
  end
end
