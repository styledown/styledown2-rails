require 'rails/generators/base'

class Styledown
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc 'Adds Styledown configuration via styledown2-rails'
      source_root File.expand_path('../sources', __FILE__)

      class_option :template_engine

      SUPPORTED_ENGINES = [:erb, :haml]

      def install
        engine = options[:template_engine]
        engine = :erb unless SUPPORTED_ENGINES.include?(engine)

        # Controllers
        template 'controller.rb', 'app/controllers/styleguides_controller.rb'

        # Routes
        route "resource 'styleguides', only: [:show] do\n" +
          "    get '*page', action: :show, as: :page\n" +
          '  end'

        # Views
        template "_head.#{engine}", "app/views/styleguides/_head.#{engine}"

        # Styleguides
        template 'index.md', 'docs/styleguides/index.md'
        template 'buttons.md', 'docs/styleguides/buttons.md'
        template 'README.md', 'docs/styleguides/README.md'
      end
    end
  end
end
