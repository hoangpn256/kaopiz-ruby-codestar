class Tag < ApplicationRecord
    has_many :taggings
    has_many :articles, through: :taggings

    validates :name, presence: true

    def get_tag_name
        sefl.name
    end

end
