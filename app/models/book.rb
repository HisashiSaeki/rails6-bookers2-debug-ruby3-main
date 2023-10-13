class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :title, presence:true
  validates :body, presence:true, length:{maximum:200}

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

  scope :created_today, -> { where(created_at: Today.all_day) }
  scope :created_yesterday, -> { where(created_at: Yesterday.all_day) }
  scope :created_2days_ago, -> { where(created_at: 2.days.ago.all_day) }
  scope :created_3days_ago, -> { where(created_at: 3.days.ago.all_day) }
  scope :created_4days_ago, -> { where(created_at: 4.days.ago.all_day) }
  scope :created_5days_ago, -> { where(created_at: 5.days.ago.all_day) }
  scope :created_6days_ago, -> { where(created_at: 6.days.ago.all_day) }
  scope :created_this_week, -> { where(created_at: Oneweek_before.beginning_of_day..Today.end_of_day) }
  scope :created_last_week, -> { where(created_at: Tweweek_before.beginning_of_day..(Oneweek_before - 1.day).end_of_day) }

end
