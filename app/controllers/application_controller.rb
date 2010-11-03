class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user

  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
    
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to login_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to root_url
        return false
      end
    end
    
    def require_admin_user
      require_user
      if current_user and !current_user.admin?
        render_404
      end
    end
    
    def render_404
      if request.format.xml? || request.format.json?
        render :nothing => true, :status => 404
      else
        render :file => "#{RAILS_ROOT}/public/404.html",  
        :status => 404 and return
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to session[:return_to] ? session[:return_to] : default
      session[:return_to] = nil
    end
end
