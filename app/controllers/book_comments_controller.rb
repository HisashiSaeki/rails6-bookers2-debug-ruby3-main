class BookCommentsController < ApplicationController
  before_action :ensure_correct_book_comment, only: [:destroy]

  def create
    @book = Book.find(params[:book_id])
    @comment = current_user.book_comments.new(post_comment_params)
    @comment.book_id = @book.id
    @comment.save
  end

  def destroy
    @book = Book.find(params[:book_id])
    @comment.destroy
  end

  private

  def post_comment_params
    params.require(:book_comment).permit(:comment)
  end

  def ensure_correct_book_comment
    @comment = BookComment.find(params[:id])
    unless @comment.user_id == current_user.id
      redirect_to books_path
    end
  end
end
