class User < ApplicationRecord
  belongs_to :customer
  serialize :entity_ids, Array
end
