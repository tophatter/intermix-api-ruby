module Intermix
  class Table
    FIELDS = %w(
      db_id
      db_name
      
      schema_id
      schema_name
      
      table_id
      table_name 
      
      stats_pct_off
      size_pct_unsorted
      row_count
      sort_key
    )

    attr_accessor(*FIELDS)

    def initialize(data)
      raise ArgumentError, 'data cannot be nil.' unless data.present?

      self.class::FIELDS.each { |field| send("#{field}=", data[field]) }
    end

    def full_name
      "\"#{schema_name}\".\"#{table_name}\""
    end
  end
end
