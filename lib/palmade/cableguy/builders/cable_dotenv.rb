module Palmade::Cableguy
  class Builders::CableDotenv < Cable
    add_as :dotenv

    def configure(cabler)
      if @args[0].nil?
        env_file = '.env.cableguy'
      else
        env_file = @args[0]
      end

      if @args[1].nil?
        vkey = '.env'
      else
        vkey = @args[1]
      end

      env_file_path = File.join(cabler.determine_apply_path, env_file)
      generate_dotenv_file(cabler, env_file_path, vkey)
    end

    protected

    def generate_dotenv_file(cabler, env_file_path, vkey)
      app_group = cabler.app_group

      values = cabler.db.final_values(app_group)
      env_values = values.fetch(vkey, { })

      all_values = env_values.merge({ '_CABLEGUY_TARGET' => cabler.target,
                                      '_CABLEGUY_LOCATION' => cabler.location })

      File.open(env_file_path, 'w') do |f|
        all_values.each do |k,v|
          if v.is_a?(Hash)
            v = perform_value_action(cabler, k, v)
          end

          unless v.is_a?(String)
            v = v.to_s
          end

          # safely escape characters (not yet escaped)
          v = v.gsub(/(\n)|([^\\]\")|([^\\]\')/) do |m|
            case m
            when "\n"
              '\n'
            else
              '%s\%s' % [ m[0], m[1] ]
            end
          end

          f.write("%s=\"%s\"\n" % [ k, v ])
        end
      end
    end

    def perform_value_action(cabler, k, v)
      app_group = cabler.app_group

      if v.has_key?('get')
        v = cabler.db.get(v['get'], app_group)
      elsif v.has_key?('sprintf')
        v = v['sprintf'][0] % v['sprintf'][1..-1].collect { |v1| cabler.db.get(v1, app_group) }
      end

      v
    end
  end
end
