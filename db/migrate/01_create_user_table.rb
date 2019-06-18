class CreateUserTable < ActiveRecord::Migration[4.2]
    def change
        create_table :users do |t|
            t.string :user_name
        end
    end
end