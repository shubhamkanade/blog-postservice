class Clap < ApplicationRecord

    belongs_to :clapable, polymorphic: true
    validates :user_id, :clapable_id, :clapable_type, presence: true

end