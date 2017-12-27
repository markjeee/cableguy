require 'cableguy'

module Palmade
  module Cableguy
    autoload :Builders, 'palmade/cableguy/builders'
    autoload :Cable, 'palmade/cableguy/cable'
    autoload :Cabler, 'palmade/cableguy/cabler'
    autoload :Env, 'palmade/cableguy/env'

    autoload :CLI, 'palmade/cableguy/cli'
    autoload :CliHelper, 'palmade/cableguy/cli_helper'
    autoload :Constants, 'palmade/cableguy/constants'
    autoload :DB, 'palmade/cableguy/db'
    autoload :CablingValues, 'palmade/cableguy/cabling_values'
    autoload :Migrator, 'palmade/cableguy/migrator'
    autoload :Migration, 'palmade/cableguy/migration'
    autoload :Runner, 'palmade/cableguy/runner'
    autoload :TemplateBinding, 'palmade/cableguy/templatebinding'

    autoload :Configurator, 'palmade/cableguy/configurator'
    autoload :LegacyConfigurator, 'palmade/cableguy/legacy_configurator'
    autoload :Cablefile, 'palmade/cableguy/cablefile'

    autoload :Utils, 'palmade/cableguy/utils'
    autoload :VERSION, 'palmade/cableguy/version'

    autoload :CapistranoTasks, 'palmade/cableguy/capistrano_tasks'

    def self.boot_cabler(app_path, opts = { })
      Palmade::Cableguy::Cabler.new(app_path, opts).boot
    end
  end
end
