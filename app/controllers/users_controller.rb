class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # GET /users/999
  def index
    if params[:password] == "999"
      @users = User.all.map do |user|
        group_name = user.group.nil? ? "" : user.group.group_name
        {
            user_id: user.id,
            user_name: user.user_name,
            email: user.email,
            location: user.location,
            group_name: group_name,
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

    if @group.nil?
      @user = User.new(user_params)
      @group_name = ""
      @friend_count = 0
    else
      @user = @group.users.create(user_params)
      @group_name = @user.group.group_name
      @friend_count = @user.group.users.size - 1
    end

    if @user.save
      render json: {user_id: @user.id.to_s, user_name: @user.user_name, user_email: @user.email, location: @user.location, book_count: "0", friend_count: @friend_count.to_s, access_token: @user.access_token, group_name: @group_name}
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

# POST /login
  def login
    @user = User.where({email: params[:email], password: params[:password]}).first

    if @user.nil?
      render json: @user.errors, status: :unprocessable_entity
    else
      group_name = @user.group.nil? ? "" : @user.group.group_name
      friend_count = @user.group.nil? ? 0 : @user.group.users.size - 1
      render json: {user_id: @user.id.to_s, user_name: @user.user_name, user_email: @user.email, location: @user.location, book_count: Book.where({user_id: @user.id.to_s}).count.to_s, friend_count: friend_count.to_s, access_token: @user.access_token, group_name: group_name}
    end
  end

  # POST /find_password
  def find_password
    user_id = params[:user_id]
    @user = User.find(user_id.to_i)

    if @user.nil?
      render json: @user.errors, status: 404
    else
      UserMailer.find_password_for_user(@user).deliver

      render json: {result: "Email already sent to user: #{@user.email}"}
    end
  end

  # POST /upload_avatar
  def upload_avatar
    if has_no_permission?(params[:user_id], params[:access_token])
      render json: {error: "User authentication failed."}, status: :unauthorized
      return
    end

    uploaded_io = params[:avatar_file]
    if !uploaded_io.nil? && uploaded_io.content_type.match('image')
      File.open(Rails.root.join('public/assets', uploaded_io.original_filename), 'wb') do |f|
        f.write(uploaded_io.read)
      end

      render json: {result: "uploaded success!"}
    else
      render json: {result: "uploaded fail!"}, status: 500
    end
  end

  # POST /change_username
  def change_username
    if has_no_permission?(params[:user_id], params[:access_token])
      render json: {error: "User authentication failed."}, status: :unauthorized
      return
    end

    @user = User.find(params[:user_id])
    @user.user_name = params[:user_name]
    @user.save!
    render json: {result: "Change username success!"}
  end

# POST /change_location
  def change_location
    if has_no_permission?(params[:user_id], params[:access_token])
      render json: {error: "User authentication failed."}, status: :unauthorized
      return
    end

    @user = User.find(params[:user_id])
    @user.location = params[:location]
    @user.save!
    render json: {result: "Change location success!"}
  end

# GET /books_by_user/123
  def get_books_by_user
    user_id = params[:user_id]

    @user = User.find(user_id)
    if @user.nil?
      render json: @user.errors, status: 404
    else
      books = Book.where({user_id: user_id})
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
      return
    end

    if @user.group.nil?
      render json: {error: "No group for personal email."}, status: 404
      return
    end

    users = @user.group.users.map do |user|
      {
          friend_id: user.id.to_s,
          friend_name: user.user_name,
          friend_email: user.email,
          friend_location: user.location,
          book_count: Book.where({user_id: user.id.to_s}).count.to_s
      }
    end
    friends = users.select do |friend|
      friend[:friend_id] != user_id
    end

    results = {user_id: user_id, friends: friends}
    render json: results
  end

  private

# Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:user_name, :email, :password, :location).merge(access_token: random_string)
  end

  def random_string
    randstring = ""
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    1.upto(20) { |i| randstring << chars[rand(chars.size-1)] }
    return randstring
  end

  def get_or_create_group_by_email email
    user_group_name = email.split('@')[1].split('.')[0]

    if is_a_personal_email?(user_group_name)
      return nil
    end

    group = Group.where(group_name: user_group_name).first
    group.nil? ? Group.create(group_name: user_group_name) : group
  end

  def is_a_personal_email? name
    ['126', '163', 'gmail', 'qq', 'sina', 'yahoo', 'sohu'].include?(name)
  end

  def has_no_permission?(user_id, access_token)
    User.where({id: user_id, access_token: access_token}).empty?
  end

end
