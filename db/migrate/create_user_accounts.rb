# frozen_string_literal: true

class CreateUserAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :user_accounts do |t|
      t.references :user, null: false, foreign_key: true

      ## Omniauth
      t.string     :provider, null: false
      t.string     :uid, null: false

      t.timestamps null: false
    end

    add_index :user_accounts, %i[provider uid], unique: true
  end
end
