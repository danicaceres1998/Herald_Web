class AddCreatedAtBiller < ActiveRecord::Migration[6.0]
  def change
    add_column :billers, :created_at, :date
  end
end
