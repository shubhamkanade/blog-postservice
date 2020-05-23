class Post < ApplicationRecord

    has_many :comments, dependent: :destroy
    has_many :claps, as: :clapable
    validates :title, :description, :user_id, presence: true
    after_save ThinkingSphinx::RealTime.callback_for(:post)

end