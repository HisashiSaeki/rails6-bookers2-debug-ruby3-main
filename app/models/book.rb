class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.exists?
  end

  def self.search_for(search, word)
    case search
      when "perfect_match" then
        Book.where("title like ?", word)
      when "partial_match" then
        Book.where("title like ?", '%' + word + '%')
      when "forward_match" then
        Book.where("title like ?", word + '%')
      when "backward_match" then
        Book.where("title like ?", '%' + word)
      else
        Book.all
    end
  end

  Today = Date.current
  Yesterday = Date.yesterday
  Oneweek_before = Today - 6.day
  Tweweek_before = Oneweek_before - 7.day

  def self.number_of_posts_today(user)
    Book.where(user_id: user, created_at: Today.all_day).count
  end

  def self.number_of_posts_yesterday(user)
    Book.where(user_id: user, created_at: Yesterday.all_day).count
  end

  def self.number_of_posts_thisweek(user)
    Book.where(user_id: user, created_at: Oneweek_before.beginning_of_day..Today.end_of_day).count
  end

  def self.number_of_posts_lastweek(user)
    Book.where(user_id: user, created_at: Tweweek_before.beginning_of_day..(Oneweek_before - 1.day).end_of_day).count
  end

end
