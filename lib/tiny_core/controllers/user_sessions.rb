module TinyCore
  module Controllers
    module UserSessions
      def self.included(receiver)
        receiver.before_filter :guest_required, :only => [ :new, :create ]
        receiver.skip_before_filter :verify_authenticity_token, :only => :create
      end

      def new
        @user_session = UserSession.new
      end

      def create
        @user_session = UserSession.new(params[:user_session])
        if @user_session.save
          flash[:notice] = I18n.t("flash.notice.logged_in")
          redirect_back_or_default root_path
        else
          render :action => :new
        end
      end

      def destroy
        current_user_session.destroy
        flash[:notice] = I18n.t("flash.notice.logged_out")
        redirect_to login_path
      end
    end
  end
end
