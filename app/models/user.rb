class User < ApplicationRecord
    validates :name, presence: true
    validates :email, uniqueness: true

    after_create :print_time_created, :save_to_history
    # before_destroy :save_to_history

    private 
    def print_time_created
         p "User is created at #{created_at}"
    end
    def save_to_history
        # user = { 
        #     name: name, 
        #     email: email, 
        #     dob: dob,
        #     note: note

        #  }
        #  UserDeleteHistory.create(user)
        UserDeleteHistory.new(name: name, email: email, dob: dob, note: note).save
    end
end
