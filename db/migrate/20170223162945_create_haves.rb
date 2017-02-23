class CreateHaves < ActiveRecord::Migration
  def change
    create_table :haves do |t|

      t.timestamps null: false
    end
  end
end
