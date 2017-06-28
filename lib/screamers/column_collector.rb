# frozen-string-literal: true

module Screamers
  class ColumnCollector
    def initialize(old_column_type, new_column_type)
      @old_column_type = old_column_type.to_sym
      @new_column_type = new_column_type.to_sym
    end

    def collect_columns
      tables = ActiveRecord::Base.connection.tables
      tables.delete('ar_internal_metadata')

      @target_tables = tables.each_with_object({}) {|table, target|
        begin
          columns = Module.const_get(table.classify).columns
        rescue
          puts "An ActiveRecord model mapped to `#{table}` foo could not be found. Please check if you need handmade by yourself."
          next
        end

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
