class Styledown
  module Rails
    module Controller
      def self.included(klass)
        klass.extend ClassMethods
        klass.include InstanceMethods
        klass.styledown
      end

      module ClassMethods
        def styledown
          @styledown ||= ControllerIntegration.new(self)
        end
      end

      module InstanceMethods
        def styledown
          self.class.styledown
        end
      end
    end
  end
end
