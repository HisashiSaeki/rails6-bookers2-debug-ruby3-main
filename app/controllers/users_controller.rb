class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @posts_today = @books.created_today
    @posts_yesterday = @books.created_yesterday
    @posts_2days_ago = @books.created_2days_ago
    @posts_3days_ago = @books.created_3days_ago
    @posts_4days_ago = @books.created_4days_ago
    @posts_5days_ago = @books.created_5days_ago
    @posts_6days_ago = @books.created_6days_ago
    @posts_this_week = @books.created_this_week
    @posts_last_week = @books.created_last_week
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  def follows
    user = User.find(params[:id])
    @users = user.following_user
  end

  def followers
    user = User.find(params[:id])
    @users = user.followed_user
  end

  def search_number_of_posts
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    if params[:created_at] == ''
      @search_result = "日付を選択してください"
    else
      create_at = params[:created_at].to_date.strftime('%Y %b %d')
      @search_result = Book.where("created_at Like ?", create_at).count
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
