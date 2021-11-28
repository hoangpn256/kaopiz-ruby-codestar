class User < ApplicationRecord
validates :name, presence: true
validates :email, uniqueness: true
after_save :print
before_destroy :history

private
def print
puts "User is created in #{created_at}"
end
def history
	UserDeleteHistory.create(email: self.email, name: self.name, dob: self.dob, address: self.address)
end
end
