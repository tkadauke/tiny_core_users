module TinyCore
  module Role
    module Guest
      include TinyCore::Role

      def method_missing(method, *args)
        if method.to_s =~ /^can_.*\?$/
          false
        else
          super
        end
      end
    end
  end
end
