class Comment < ApplicationRecord

    belongs_to :post
    has_many :claps, as: :clapable
    validates :comment, :user_id, :post_id, presence: true

end