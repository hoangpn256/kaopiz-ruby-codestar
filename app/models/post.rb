class Post < ApplicationRecord
    belongs_to :user
    has many :comments
end
