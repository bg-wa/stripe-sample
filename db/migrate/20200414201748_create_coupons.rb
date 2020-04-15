class CreateCoupons < ActiveRecord::Migration[5.2]
  def change
    create_table :coupons do |t|
      t.string :duration
      t.string :name
      t.integer :percent_off

      t.timestamps
    end
  end
end
