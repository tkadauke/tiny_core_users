module TinyCore
  module Role
    module Admin
      include TinyCore::Role

      allow :assign_roles

      def method_missing(method, *args)
        if method.to_s =~ /^can_.*\?$/
          true
        else
          super
        end
      end
    end
  end
end
