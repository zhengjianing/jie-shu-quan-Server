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

  # POST /books.json
  def create
    p '----------------'
    p book_params

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
      render json: {douban_book_id: @book.douban_book_id, user_id: @book.user_id.to_s, available: @book.available}
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # GET /users_by_book/123
  def get_users_by_book
    douban_book_id = params[:douban_book_id]
    @books = Book.where({douban_book_id: douban_book_id})

    if @books.empty?
      render json: {error: "No book with douban_book_id: #{douban_book_id} found!"}, status: 404
      return
    end

    users = @books.map do |book|
      {user_id: book.user_id,
       available: book.available}
    end
    results = {douban_book_id: douban_book_id, users: users}
    render json: results
  end

  private

  def book_params
    params.require(:book).permit(:douban_book_id, :user_id, :available)
  end

  def has_no_permission?(user_id, access_token)
    User.where({id: user_id, access_token: access_token}).empty?
  end

  def already_has_book_for_user(douban_book_id, user_id)
    Book.where({douban_book_id: douban_book_id, user_id: user_id}).size > 0
  end

end
