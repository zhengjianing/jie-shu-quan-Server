class CommentsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # GET /comments_for_book/:douban_book_id
  def comments_for_book
    comments = Comment.where({douban_book_id: params[:douban_book_id]}).map do |comment|
      {
          user_name: comment.user_name,
          comment_date: comment.created_at.time.strftime('%Y-%m-%d'),
          content: comment.content
      }
    end

    results = {douban_book_id: params[:douban_book_id], comments: comments}
    render json: results
  end

  # POST /comments/create
  def create
    @comment = Comment.new({douban_book_id: params[:douban_book_id], user_name: params[:user_name], content: params[:content]})
    if @comment.save
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

end