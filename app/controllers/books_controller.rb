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
    @book = Book.new(book_params)

    if @book.save
      render json: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # GET /users_by_book/123
  def get_users_by_book
    book_id = params[:book_id]
    @books = Book.where({book_id: book_id})

    if @books.empty?
      render json: {error: "No book with douban_book_id: #{book_id} found!"}, status: 404
    else
      users = @books.map do |book|
        {user_id: book.user_id,
         available: book.available}
      end
      results = {book_id: book_id, users: users}
      render json: results
    end
  end

  private

  def book_params
    params.require(:book).permit(:book_id, :user_id, :available)
  end
end
