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
        @instance = nil
        @instance.options = options
      end

      # Reloads data, if needed.
      def reload
        if ::Rails.env.development?
          instance.render!
        else
          instance.render
        end
      end

      def show(controller)
        @controller_instance = controller

        # TODO: auto-redirect to trailing slash
        reload

        page = get_page(controller.params)
        file = instance.output[page]

        if file
          controller.render body: file['contents'], content_type: file['type']
        else
          raise ActiveRecord::RecordNotFound
        end
      end

      def append_template(template, partial)
        use_template template, partial, append: true
      end

      def use_template(template, partial, options = {})
        template_name = template.to_s # 'head'

        instance.add_data_filter do |data|
          html = controller_instance.render_to_string partial: partial

          if options[:append]
            data['templates'][template_name] ||= ''
            data['templates'][template_name] += "\n" + html
          else
            data['templates'][template_name] = html
          end

          data
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
    end
  end
end
