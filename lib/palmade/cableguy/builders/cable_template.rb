module Palmade::Cableguy
  class Builders::CableTemplate < Cable
    add_as :template

    def configure(cabler)
      templates_apply_path = cabler.determine_apply_path(:for_templates => true)
      template_file = @args[0]

      unless @args[1].nil?
        target_path = File.join(cabler.determine_apply_path, @args[1], template_file)
      else
        target_path = File.join(templates_apply_path, template_file)
      end

      cabler.say('Setup template: %s' % File.basename(template_file), true)
      install_template(template_file, cabler, target_path)
    end

    def install_template(template_file, cabler, target_path = nil)
      templates_apply_path = cabler.determine_apply_path(:for_templates => true)
      template_path = determine_template_path(cabler, template_file)

      if target_path.nil?
        target_path = File.join(templates_apply_path, template_file)
      end

      if File.exists?(template_path)
        tb = TemplateBinding.new(self, cabler)
        tb.install(template_path, target_path)
      else
        raise ArgumentError, "template file %s not found" % template_path
      end
    end

    protected

    def determine_template_path(cabler, template_file)
      try_template_path = File.join(cabler.templates_path,
                                    variant_fname(cabler, template_file))

      if File.exists?(try_template_path)
        try_template_path
      else
        File.join(cabler.templates_path, template_file)
      end
    end

    def variant_fname(cabler, template_file)
      target = cabler.target

      extname = File.extname(template_file)
      fname = File.basename(template_file, extname)
      extname.sub!(/^\./, '')

      vfname = [ fname, target ].join('.')
      vfname = [ vfname, extname ].join('.') unless extname.empty?
      vfname
    end
  end
end
