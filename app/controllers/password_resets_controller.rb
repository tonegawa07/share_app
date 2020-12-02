class PasswordResetsController < ApplicationController
  before_action :get_user,             only: [:edit, :update]
  before_action :valid_user,           only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  def new
  end

  def create
    # フォームに入力されたemailを持ったユーザーを@userに代入
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    # @userが存在すれば
    if @user
      # @userのパスワード再設定の属性を設定する（create_reset_digestはapp/models/user.rbにある）
      @user.create_reset_digest
      # @userにパスワード再設定メールを送る（send_password_reset_emailはapp/models/user.rbにある）
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update(user_params)
      log_in @user
      # @userの:reset_digestの値をnilに更新して保存
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # beforeフィルタ

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 有効なユーザーかどうか確認する
    def valid_user
      # 条件がfalseの場合（@userが存在する　かつ　@userが有効化されている　かつ　@userが認証済である）
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end

end
