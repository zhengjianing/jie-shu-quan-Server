class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @group = get_or_create_group_by_email(user_params[:email])
    @user = @group.users.create(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json do
          render json: {user_id: @user.id.to_s, user_name: @user.user_name, access_token: @user.access_token}
        end
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:user_name, :email, :password).merge(access_token: random_string)
  end

  def random_string
    randstring = ""
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    1.upto(20) { |i| randstring << chars[rand(chars.size-1)] }
    return randstring
  end

  def get_or_create_group_by_email email
    user_group_name = email.split('@')[1].split('.')[0]
    group = Group.where(group_name: user_group_name).first
    group.nil? ? Group.create(group_name: user_group_name) : group
  end
end
