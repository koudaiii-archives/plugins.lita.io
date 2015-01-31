class CreatePlugins < ActiveRecord::Migration
  def change
    create_table :plugins do |t|
      t.string :name, null: false
      t.string :plugin_type
      t.string :description
      t.string :authors
      t.string :version, null: false
      t.string :requirements_list, null: false
      t.string :homepage, null: false

      t.timestamps null: false
    end

    add_index :plugins, :name, unique: true
  end
end
