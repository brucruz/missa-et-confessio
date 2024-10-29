class CreateChurches < ActiveRecord::Migration[7.2]
  def change
    create_table :churches do |t|
      t.string :name
      t.string :address
      t.string :country
      t.string :state
      t.string :city
      t.string :neighborhood
      t.string :timezone
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6

      t.timestamps
    end

    add_index :churches, :name
    add_index :churches, [ :latitude, :longitude ]
  end
end
