class BooksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # GET /books/999
  def index
    if params[:password] == "999"
      render json: Book.all
    else
      render json: {error: 'wrong password'}
    end
  end

  # POST /add_book
  def create
    if has_no_permission?(params[:user_id], params[:access_token])
      render json: {error: "User authentication failed."}, status: :unauthorized
      return
    end

    if already_has_book_for_user(params[:douban_book_id], params[:user_id])
      render json: {error: "Already has the book: #{params[:douban_book_id]} for the user: #{params[:user_id]}."}, status: :unprocessable_entity
      return
    end

    @book = Book.new(book_params)
    if @book.save
      render json: {book: @book}
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # PUT /change_status
  def update
    user_id = params[:user_id]
    douban_book_id = params[:douban_book_id]

    if has_no_permission?(user_id, params[:access_token])
      render json: {error: "User authentication failed."}, status: :unauthorized
      return
    end

    @book = Book.where({douban_book_id: douban_book_id, user_id: user_id}).first

    if @book.nil?
      render json: {error: "Can't find douban_book_id with: #{douban_book_id} for user: #{user_id}"}, status: 404
      return
    end

    @book.available = params[:available]
    if @book.save
      render json: {douban_book_id: @book.douban_book_id, user_id: @book.user_id.to_s, available: @book.available}
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # PUT /remove_book
  def remove
    user_id = params[:user_id]
    douban_book_id = params[:douban_book_id]

    if has_no_permission?(user_id, params[:access_token])
      render json: {error: "User authentication failed."}, status: :unauthorized
      return
    end

    @book = Book.where({douban_book_id: douban_book_id, user_id: user_id}).first

    if @book.nil?
      render json: {error: "Can't find douban_book_id with: #{douban_book_id} for user: #{user_id}"}, status: 404
      return
    end

    if @book.destroy!
      render json: {removed: 'success'}
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # GET /friendsWithBook/:douban_book_id/forUser/:user_id
  def get_friends_with_book_for_user
    user = User.find(params[:user_id])
    if user.nil? || user.group.nil?
      render json: {error: "No user or group found!"}, status: 404
      return
    end

    @books = Book.where({douban_book_id: params[:douban_book_id]})
    if @books.empty?
      render json: {douban_book_id: params[:douban_book_id], friends: []}
      return
    end

    all_people_has_book = []
    @books.each do |book|
      all_people_has_book << User.find(book.user_id)
    end

    friends = all_people_has_book.select do |people|
       people.group != nil && people.group.group_name == user.group.group_name && people.id.to_s != params[:user_id]
    end

    friends_result = friends.map do |friend|
      {
          friend_id: friend.id.to_s,
          friend_name: friend.user_name,
          friend_email: friend.email,
          friend_location: friend.location,
          book_count: Book.where({user_id: friend.id.to_s}).count.to_s,
          available: Book.where({douban_book_id: params[:douban_book_id], user_id: friend.id.to_s}).first.available
      }
    end

    results = {douban_book_id: params[:douban_book_id], friends: friends_result}
    render json: results
  end

  private

  def book_params
    params.require(:book).permit(:douban_book_id, :user_id, :available, :name, :authors, :image_href,
                                 :description, :author_info, :price, :publisher, :publish_date)
  end

  def has_no_permission?(user_id, access_token)
    User.where({id: user_id, access_token: access_token}).empty?
  end

  def already_has_book_for_user(douban_book_id, user_id)
    Book.where({douban_book_id: douban_book_id, user_id: user_id}).size > 0
  end

end
