class User < ApplicationRecord
    has many :posts
    has many :comments
end
