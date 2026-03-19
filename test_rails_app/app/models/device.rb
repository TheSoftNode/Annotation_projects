class Device < ApplicationRecord
  belongs_to :entity
  belongs_to :customer
end
