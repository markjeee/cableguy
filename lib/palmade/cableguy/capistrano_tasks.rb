require 'capistrano/bundler'
require "capistrano/plugin"

module Palmade::Cableguy
  class CapistranoTasks < Capistrano::Plugin
    def define_tasks
      namespace :cableguy do
        desc 'Perform cable on application'
        task :cable do
          on roles(:all) do
            within release_path do
              execute :bundle, 'exec cable --target=%s' % fetch(:cableguy_target)
            end
          end
        end
      end
    end

    def set_defaults
      set_if_empty :cableguy_target, 'development'

      append :chruby_map_bins, 'cable'
      append :rbenv_map_bins, 'cable'
      append :rvm_map_bins, 'cable'
      append :bundle_bins, 'cable'
    end

    def register_hooks
      after 'deploy:updated', 'cableguy:cable'
    end
  end
end
