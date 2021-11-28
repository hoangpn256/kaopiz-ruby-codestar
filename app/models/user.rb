class User < ApplicationRecord
    validates :name, presence: true
    validates :email, uniqueness: true
    after_create :print
    after_destroy :deleteHistory

    private

    def print
        p "User is created in #{created_at}"
    end

    def deleteHistory
        UserDeleteHistory.create(email: self.email, name: self.name, dob: self.dob, address: self.address)
    end
end
