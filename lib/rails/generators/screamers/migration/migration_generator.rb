# frozen-string-literal: true

require 'screamers'

module Screamers
  module Generators
    class MigrationGenerator < ::Rails::Generators::Base
      desc 'Creates a migration file made [Screamers Task]'
      argument :old_column_type, type: :string, banner: 'old column type'
      argument :new_column_type, type: :string, banner: 'new column type'

      def self.source_root
        File.expand_path('../templates', __FILE__)
      end

      def create_migration_file
        collector = Screamers::SchemaCollector.new(old_column_type, new_column_type)

        @target_columns = collector.collect_schema

        if @target_columns.empty?
          puts '[Screamers] There is no change in the schema.'; exit!
        end

        file_name = "#{Time.current.strftime('%Y%m%d%H%M%S')}_change_#{old_column_type}_to_#{new_column_type}_using_screamers"

        template 'migration.rb.tt', File.join('db/migrate', "#{file_name}.rb")
      end
    end
  end
end
