class EnableUuidExtension < ActiveRecord::Migration[8.1]
  def change
    enable_extension 'uuid-ossp'
  end
end
