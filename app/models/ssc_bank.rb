class SscBank < ActiveRecord::Base
  belongs_to :profile
  VALID_MASK_REGEX = /\A[\d]+[,][\d]+[,][\d]+\z/i # 2 comas, 3 values max. 
  validates :ct_mask, presence: true, format: { with: VALID_MASK_REGEX}
end
