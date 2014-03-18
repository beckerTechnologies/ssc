class SscBank < ActiveRecord::Base
  belongs_to :profile
  validates :ct_mask, presence: true, length: { minimum: 3, maximum:3}
end
