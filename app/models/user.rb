class User < ApplicationRecord
    validates :name, presence: true
    validates :email, uniqueness: true
    after_create :print
    after_destroy :delete_history

    private

    def print
        p "User is created in #{timestamps}"
    end

    def delete_history
        UserDeleteHistory.create(email: self.email, name: self.name, dob: self.dob, address: self.address)
    end
end
