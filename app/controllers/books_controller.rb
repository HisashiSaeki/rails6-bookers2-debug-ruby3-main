class BooksController < ApplicationController
  before_action :ensure_correct_book, only: [:edit, :update, :destroy]

  def show
    @book_new = Book.new
    @book_comment = BookComment.new
    @book = Book.find(params[:id])
  end

  def index
    @book = Book.new
    @books = Book.includes(:favorites).sort_by{ |book| -book.favorites.count}
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path, notice: "sucessfully delete book!"
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_book
    @book = Book.find(params[:id])
    unless @book.user_id == current_user.id
      redirect_to books_path
    end
  end
end
