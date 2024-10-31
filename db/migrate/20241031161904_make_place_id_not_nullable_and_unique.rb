class MakePlaceIdNotNullableAndUnique < ActiveRecord::Migration[7.2]
  def change
    change_column_null :churches, :place_id, false
    add_index :churches, :place_id, unique: true
  end
end
