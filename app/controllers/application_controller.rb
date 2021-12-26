class ApplicationController < ActionController::Base
 # For APIs, you may want to use :null_session instead.
 protect_from_forgery with: :exception
#  before_action :authenticate_user!
 before_action :configure_permitted_parameters, if: :devise_controller?
 before_action :set_global_search_variable
 after_action :store_action

#  load_and_authorize_resource

rescue_from CanCan::AccessDenied do |exception|
  respond_to do |format|
    format.json { head :forbidden }
      format.html { redirect_to (request.referrer || '/')  , alert: 'Bạn không được phép truy cập trang này' }
  end
end
  def store_action
    return unless request.get? 
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.xhr?) # don't store ajax calls
      store_location_for(:user, request.fullpath)
    end
  end


 def after_sign_in_path_for(resource_or_scope)
        # # check for the class of the object to determine what type it is
        # case resource.class
        # when PatientUser
        #   privacy_agreement_path  
        # when StaffUser
        #   dashboard_path
        # end
        stored_location_for(resource_or_scope) || super
  end

 def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: [:login, :password]
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def search
    shared_context = Ransack::Context.for(Article)
    q = params[:q]
    @q = Article.published.ransack(params[:q])
    if user_signed_in?
      @user_articles = current_user.articles.ransack(params[:q])
      shared_conditions = [@q, @user_articles].map { |search|
        Ransack::Visitor.new.accept(search.base)
      }
      @q = Article.joins(shared_context.join_sources)
      .where(shared_conditions.reduce(&:or)).ransack(params[:q])
    end
  
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @articles = @q.result(:distinct=>true)
    render "articles/index"
  end
  
  def set_global_search_variable
    @q = Article.ransack(params[:q])  
  end
  
end
