class AddPlaceIdToChurches < ActiveRecord::Migration[7.2]
  def change
    add_column :churches, :place_id, :string
  end
end
