class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # GET /users/999
  def index
    if params[:password] == "999"
      @users = User.all.map do |user|
        {
            user_id: user.id,
            user_name: user.user_name,
            email: user.email,
            group_name: user.group.group_name,
            access_token: user.access_token
        }
      end
      render json: @users
    else
      render json: {error: 'wrong password'}
    end
  end

  # POST /register
  def register
    @group = get_or_create_group_by_email(user_params[:email])
    @user = @group.users.create(user_params)

    if @user.save
      render json: {user_id: @user.id.to_s, user_name: @user.user_name, access_token: @user.access_token, group_name: @user.group.group_name}
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

# POST /login
  def login
    @user = User.where({email: params[:email], password: params[:password]}).first

    if @user.nil?
      render json: @user.errors, status: 404
    else
      render json: {user_id: @user.id.to_s, user_name: @user.user_name, access_token: @user.access_token, group_name: @user.group.group_name}
    end
  end

# GET /books_by_user/123
  def get_books_by_user
    user_id = params[:user_id]

    @user = User.find(user_id)
    if @user.nil?
      render json: @user.errors, status: 404
    else
      books = Book.where({user_id: user_id}).map do |book|
        {book_id: book.book_id,
         available: book.available}
      end
      results = {user_id: user_id, books: books}
      render json: results
    end
  end

# GET /friends_by_user/123
  def get_friends_by_user
    user_id = params[:user_id]

    @user = User.find(user_id)
    if @user.nil?
      render json: @user.errors, status: 404
    else
      friends = @user.group.users.map do |user|
        if user.id != user_id
          {
              friend_name: user.user_name,
              friend_email: user.email
          }
        end
      end

      results = {user_id: user_id, friends: friends}
      render json: results
    end
  end

  private

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
