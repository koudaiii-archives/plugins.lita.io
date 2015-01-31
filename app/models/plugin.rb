class Plugin < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :version, presence: true
  validates :requirements_list, presence: true
  validates :homepage, presence: true

  def self.alphabetical
    order(name: :asc)
  end
end
