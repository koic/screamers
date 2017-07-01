# frozen-string-literal: true

module Screamers
  class ColumnCollector
    def initialize(old_column_type, new_column_type)
      @old_column_type = old_column_type.to_sym
      @new_column_type = new_column_type.to_sym
    end

    def collect_columns
      tables = ActiveRecord::Base.connection.tables

      @target_tables = tables.each_with_object({}) {|table, target|
        active_record_model = active_record_model_const_get(table.classify)

        target_columns = active_record_model.columns.select {|column|
          column.type == @old_column_type
        }

        unless (columns = target_columns.map(&:name)).empty?
          target[table] = columns
        end
      }
    end

    private

    def active_record_model_const_get(class_name)
      Module.const_get(class_name)
    rescue
      eval <<-EOS.strip_heredoc
        class ::#{class_name} < ActiveRecord::Base
        end
      EOS
      Module.const_get(class_name)
    end
  end
end
