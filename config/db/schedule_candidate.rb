# frozen_string_literal: true

require 'active_record'
require 'yaml'

config = YAML.load_file('./config/db.yml')
# p config # for debug

db_env = ENV['APP_DB_ENV'] || 'development'
ActiveRecord::Base.establish_connection(config[db_env])

ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.tables.include? 'schedule_candidates'
    create_table :schedule_candidates do |table|
      table.column :schedule_id, :integer
      table.column :event_id,    :string
      table.column :datetime,    :datetime
    end
  end
end
