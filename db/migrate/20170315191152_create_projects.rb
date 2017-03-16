class CreateProjects < ActiveRecord::Migration[5.0]
  enable_extension 'uuid-ossp'

  def change
    create_table :projects, id: :uuid do |t|
      t.uuid    :user_id, null: false
      t.string  :title, limit: 150, unique: true
      t.text    :description
      t.text    :images

      t.timestamps
    end

    add_index :projects, :user_id
  end
end
