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
      attr_reader :root
      attr_reader :options

      def initialize(controller_class)
        @controller = controller_class
        @options = { extension: '' }
      end

      def root=(path)
        @instance = nil
        path = ::Rails.root.join(path) unless Pathname.new(path).absolute?
        @root = path
      end

      def options=(options)
        @instance = nil
        @options = options
      end

      # Returns the `Styledown` instance.
      def instance
        @instance ||= Styledown.new(@root, @options)
      end

      def show(controller)
        instance.reload
        page = controller.params[:page]
        page += ".#{controller.params[:format]}" if controller.params[:format]
        puts instance.output
        file = instance.output[page]
        if file
          controller.render text: file['contents'], content_type: file['type']
        else
          raise ActiveRecord::RecordNotFound
        end
      end
    end
  end
end
