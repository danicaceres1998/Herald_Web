class CreatingBackend < ActiveRecord::Migration[6.0]
  def change
    create_table :billers do |t|
      t.string :contacts
      t.string :from
      t.text :error
    end

    create_table :brands do |t|
      t.integer :brand_code
      t.string :brand_name
      t.integer :biller_id
    end

    create_table :products do |t|
      t.integer :product_id
      t.string :product_name
      t.integer :brand_id
    end

    create_table :emails do |t|
      t.text :message
      t.string :contacts
    end
  end
end
