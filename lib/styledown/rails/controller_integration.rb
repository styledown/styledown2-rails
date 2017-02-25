class Styledown
  module Rails
    # Accessible via `#styledown`.
    #
    #     class StyleguidesController < ApplicationController
    #       include Styledown::Rails::Controller
    #
    #       styledown.root = 'docs/styleguides'
    #       styledown.options = { skipAssets: true }
    #     end
    #
    class ControllerIntegration
      attr_reader :controller_class
      attr_reader :controller_instance
      attr_reader :instance

      DEFAULT_OPTIONS = { extension: '' }

      def initialize(controller_class)
        @controller_class = controller_class
        @controller_instance = nil
        @instance = Styledown.new
        @instance.options = DEFAULT_OPTIONS
      end

      def root=(path)
        path = ::Rails.root.join(path) unless Pathname.new(path).absolute?
        @instance.paths = path
        path
      end

      def options=(options)
        @instance.options = options
      end

      # Reloads data, if needed.
      def reload
        # TODO: styledown.no_reload = -> { !::Rails.env.development? }
        if ::Rails.env.development?
          instance.render
        else
          instance.fast_render
        end
      end

      def show(controller)
        @controller_instance = controller

        # If there's no trailing slash, add it
        return if redirect_with_trailing_slash(controller)

        # Find what to be rendered (eg, 'buttons')
        page = get_page(controller.params)

        # Re-render (if needed), and get the final output
        reload
        file = instance.output[page]

        unless file
          raise ActionController::RoutingError,
            "No file '#{page}' in styleguides"
        end
        controller.render body: file['contents'], content_type: file['type']
      end

      # Appends to Styledown template `template` the contents from partial `partial`.
      def append_template(template, partial)
        use_template template, partial, append: true
      end

      # Replaces Styledown template `template` with contents from partial `partial`.
      def use_template(template, partial, options = {})
        template_name = template.to_s # 'head'

        instance.add_data_filter do |data|
          html = controller_instance.render_to_string(
            partial: partial, formats: [:html])

          if options[:append]
            data['templates'][template_name] ||= ''
            data['templates'][template_name] += "\n" + html
          else
            data['templates'][template_name] = html
          end

          data
        end
      end

      # Allows the use of a given template engine.
      def use_template_engine(*engines)
        engines.each do |engine|
          instance.add_figure_filter engine do |contents|
            html = controller_instance.render_to_string(
              inline: contents, type: engine.to_sym)

            ['html', html]
          end
        end
      end

      private

      # Returns the page to be rendered
      def get_page(params)
        if params[:page]
          page = params[:page]
          page += ".#{params[:format]}" if params[:format]
          page
        else
          'index'
        end
      end

      # If there's no trailing slash, add it
      def redirect_with_trailing_slash(controller)
        # Don't use request.path, because that will always be missing a trailing slash.
        path = controller.request.env['REQUEST_PATH']

        # Check if there's no page and no trailing slash (eg, /styleguides and not
        # /styleguides/ or /styleguides/foo)
        if !controller.params[:page] && path[-1] != '/'
          controller.redirect_to "#{path}/"
          true
        end
      end
    end
  end
end
