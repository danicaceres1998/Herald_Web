class EditTtypeDataUpdatedAt < ActiveRecord::Migration[6.0]
  def change
    change_column :billers, :created_at, :datetime
  end
end
