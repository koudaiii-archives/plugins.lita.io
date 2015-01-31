class Plugin < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :version, presence: true
  validates :requirements_list, presence: true
  validates :homepage, presence: true

  def self.alphabetical_by_type
    order(name: :asc).group_by(&:plugin_type)
  end
end
