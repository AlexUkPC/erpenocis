class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :set_current_user, only: %i[ update_settings settings ]
  before_action :authenticate_user!
  before_action :admin_only, except: [:update_settings, :settings]

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
  end

  def settings
  end

  def create
    @user = User.new(secure_params)
    token, hashed_token = Devise.token_generator.generate(User, :reset_password_token)
    @user.reset_password_token = hashed_token
    @user.reset_password_sent_at = Time.now.utc
    psw = SecureRandom.alphanumeric(10)
    @user.password = psw
    @user.password_confirmation = psw

    respond_to do |format|
      if @user.save
        WelcomeMailer.welcome(@user, token).deliver
        Record.create(record_type: "Adaugare", location: "Utilizatori", model_id: @user.id, initial_data: "", modified_data: "Username: #{@user.username} | Email: #{@user.email} | Rol: #{@user.role.titleize} | Status: #{@user.active ? "activ" : "inactiv"}", user_id: current_user.id)
        format.html { redirect_to users_path, notice: "User-ul a fost creeat." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @old_info_user = @user.dup
    respond_to do |format|
      if @user.update(secure_params)
        old_s = ""
        s = ""
        if @old_info_user.username != @user.username
          old_s += "Username: #{@old_info_user.username} | "
          s += "Username: #{@user.username} | "
        end
        if @old_info_user.email != @user.email
          old_s += "Email: #{@old_info_user.email} | "
          s += "Email: #{@user.email} | "
        end
        if @old_info_user.role != @user.role
          old_s += "Rol: #{@old_info_user.role.titleize} | "
          s += "Rol: #{@user.role.titleize} | "
        end
        if @old_info_user.active != @user.active
          old_s += "Status: #{@old_info_user.active ? "activ" : "inactiv"} | "
          s += "Status: #{@user.active ? "activ" : "inactiv"} | "
        end
        Record.create(record_type: "Modificare", location: "Utilizatori", model_id: @user.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
        format.html { redirect_to current_user.admin? ? users_path : edit_user_path(current_user), :notice => "User-ul a fost modificat." } 
      else
        format.html { render :edit, status: :unprocessable_entity}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_settings
    @old_info_user = @user.dup
    respond_to do |format|
      if params[:user][:password].blank? || params[:user][:password_confirmation].blank?
        params[:user].delete(:password) 
        params[:user].delete(:password_confirmation)
        if @user.update(settings_params_psw)
          old_s = ""
          s = ""
          if @old_info_user.username != @user.username
            old_s += "Username: #{@old_info_user.username} | "
            s += "Username: #{@user.username} | "
          end
          Record.create(record_type: "Modificare", location: "Utilizatori", model_id: @user.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
          format.html { redirect_to settings_path, :notice => "User-ul a fost modificat." } 
        else
          format.html { render "settings", :alert => "Nu se poate modifica user-ul." }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        if params[:user][:password] != params[:user][:password_confirmation]
          format.html { redirect_to settings_path, :alert => "Parolele nu sunt identice." }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        else
          if @user.update_with_password(settings_params)
            old_s = ""
            s = ""
            if @old_info_user.username != @user.username
              old_s += "Username: #{@old_info_user.username} | "
              s += "Username: #{@user.username} | "
            end
            old_s += "Parola schimbata | "
            s += "Parola schimbata | "
            Record.create(record_type: "Modificare", location: "Utilizatori", model_id: @user.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
            bypass_sign_in(@user)
            format.html { redirect_to settings_path, :notice => "User-ul a fost modificat." } 
          else
            format.html { render "settings", :alert => "Nu se poate modifica user-ul." }
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end
      end
    end
  end

  def destroy
    @user.destroy
    Record.create(record_type: "Stergere", location: "Utilizatori", model_id: @user.id, initial_data: "", modified_data: "Username: #{@user.username} | Email: #{@user.email} | Rol: #{@user.role.titleize} | Status: #{@user.active ? "activ" : "inactiv"}", user_id: current_user.id)
    redirect_to users_path, :notice => "User-ul a fost sters."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_current_user
    @user = current_user
  end

  def admin_only
    unless current_user.admin?
      redirect_to root_path, :alert => "Acces interzis admin_only."
    end
  end

  def secure_params
    params.require(:user).permit(:email, :username, :role, :password, :password_confirmation, :active, :profile_picture, :remove_profile_picture)
  end

  def settings_params_psw
    params.require(:user).permit(:username, :password, :password_confirmation, :profile_picture, :remove_profile_picture)
  end
  def settings_params
    params.require(:user).permit(:username, :password, :password_confirmation, :current_password, :profile_picture, :remove_profile_picture)
  end

end
