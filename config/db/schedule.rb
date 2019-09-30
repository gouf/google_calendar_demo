# frozen_string_literal: true

require 'active_record'
require 'yaml'

config = YAML.load_file('./config/db.yml')
# p config # for debug

ActiveRecord::Base.establish_connection config['development']

ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.tables.include? 'schedules'
    create_table :schedules do |table|
      table.column :corporation_name, :string
      table.column :description,      :string
      table.column :location,         :string
    end
  end
end
