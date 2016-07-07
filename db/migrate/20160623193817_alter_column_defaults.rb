class AlterColumnDefaults < ActiveRecord::Migration
  def change
    change_column_default(:games, :play_type, "regular")
    change_column_default(:sixths, :result1, 0)
    change_column_default(:sixths, :result2, 0)
    change_column_default(:sixths, :result3, 0)
    change_column_default(:sixths, :result4, 0)
    change_column_default(:sixths, :result5, 0)
    change_column_default(:finals, :result, 0)
    change_column_default(:finals, :contestants_right, 0)
    change_column_default(:finals, :contestants_wrong, 0)
  end
end
