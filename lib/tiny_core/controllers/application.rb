module TinyCore
  module Controllers
    module Application
      def self.included(receiver)
        receiver.helper_method :current_user_session, :current_user, :logged_in?
      end

    protected
      def method_missing(method, *args)
        if method.to_s =~ /^can_.*\?$/
          if current_user.send(method, *args)
            yield if block_given?
            true
          else
            false
          end
        elsif method.to_s =~ /^can_.*\!$/
          if current_user.send(method.to_s.gsub(/\!$/, '?'), *args)
            yield if block_given?
          else
            flash[:error] = t('flash.error.access_denied')
            redirect_to root_path
            false
          end
        else
          super
        end
      end

      def login_required
        deny_access(I18n.t("flash.error.login_required"), login_path) unless current_user
      end

      def guest_required
        deny_access(I18n.t("flash.error.guest_required")) if current_user
      end

      def deny_access(message = nil, path = root_path)
        store_location
        flash[:error] = message || I18n.t("flash.error.access_denied")
        redirect_to path
        return false
      end

      def store_location
        session[:return_to] = request.request_uri
      end

      def redirect_back_or_default(default)
        redirect_to(session[:return_to] || default)
        session[:return_to] = nil
      end

      def logged_in?
        !current_user.nil?
      end

    private
      def current_user_session
        return @current_user_session if defined?(@current_user_session)
        @current_user_session = UserSession.find
      end

      def current_user
        return @current_user if defined?(@current_user)
        @current_user = current_user_session && current_user_session.user
      end
    end
  end
end
