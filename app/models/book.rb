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
        @book = Book.where("title like?", "#{word}")
      when "partial_match" then
        @book = Book.where("title like?", "%#{word}%")
      when "forward_match" then
        @book = Book.where("title like?", "#{word}%")
      when "backward_match" then
        @book = Book.where("title like?", "%#{word}")
      else
        @book = Book.all
    end
  end
end
