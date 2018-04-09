class Her < ApplicationRecord
  self.table_name = 'join_tables'
  self.primary_key = 'idd'

  def readonly?
    true
  end
end
