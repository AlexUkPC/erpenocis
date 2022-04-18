class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :admin_only, except: [:show, :edit, :update]
  before_action :admin_or_current_user, only: [:show, :edit]

  def index
    @users = User.all.order("id DESC")
    status=params[:status]
    if !status.nil?
      if status == "activ"
        @users = User.where(active: true).order("id DESC")
      elsif status == "inactiv"
        @users = User.where(active: false).order("id DESC")
      end
    else
      @users = User.all.order("id DESC")
    end
  end

  def show
    unless current_user.admin?
      unless @user == current_user
        redirect_to root_path, :alert => "Access denied."
      end
    end
  end

  def new
    @user = User.new
  end

  def edit
    unless current_user.admin?
      unless @user == current_user
        redirect_to root_path, :alert => "Access denied."
      end
    end
  end

  def create
    psw = SecureRandom.alphanumeric(10)
    token, hashed_token = Devise.token_generator.generate(User, :reset_password_token)
    @user = User.new(secure_params)
    @user.reset_password_token = hashed_token
    @user.reset_password_sent_at = Time.now.utc
    @user.password = psw
    @user.password_confirmation = psw

    respond_to do |format|
      if @user.save
        WelcomeMailer.welcome(@user, token).deliver
        format.html { redirect_to users_path, notice: "User-ul a fost creeat." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @user.update(secure_params)
      redirect_to current_user.admin? ? users_path : edit_user_path(current_user), :notice => "User-ul a fost modificat."
    else
      redirect_to current_user.admin? ? users_path : edit_user_path(current_user), :alert => "Nu se poate modifica user-ul."
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, :notice => "User-ul a fost sters."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def admin_only
    unless current_user.admin?
      redirect_to root_path, :alert => "Acces interzis."
    end
  end

  def admin_or_current_user
    unless current_user.admin?
      unless @user == current_user
        redirect_to root_path, :alert => "Access interzis."
      end
    end
  end

  def secure_params
    if current_user.admin?
      params.require(:user).permit(:email, :username, :role, :password, :password_confirmation, :active, :profile_picture, :remove_profile_picture)
    else
      params.require(:user).permit(:username, :password, :password_confirmation, :profile_picture, :remove_profile_picture)
    end
  end

end
