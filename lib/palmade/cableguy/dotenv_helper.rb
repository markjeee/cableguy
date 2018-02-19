require 'dotenv'

module Palmade::Cableguy
  module DotenvHelper
    def self.load_dotenv
      Dotenv.load('.env.cableguy')

      env_target = '.env.%s' % ::Cableguy.target
      Dotenv.load(env_target)
    end
  end
end
