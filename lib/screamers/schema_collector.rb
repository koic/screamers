# frozen-string-literal: true

module Screamers
  class SchemaCollector
    def initialize(old_column_type, new_column_type)
      @old_column_type = old_column_type.to_sym
      @new_column_type = new_column_type.to_sym
    end

    migrations_paths = ActiveRecord::Migrator.migrations_paths.first

    def collect_schema
      tables = ActiveRecord::Base.connection.tables
      tables.delete('ar_internal_metadata')

      @target_tables = tables.each_with_object({}) {|table, target|
        columns = Module.const_get(table.classify).columns rescue next

        target_columns = columns.select {|column|
          column.type == @old_column_type
        }

        unless (columns = target_columns.map(&:name)).empty?
          target[table] = columns
        end
      }
    end
  end
end
