class MakePlaceIdNullable < ActiveRecord::Migration[7.2]
  def change
    change_column_null :churches, :place_id, true
  end
end
