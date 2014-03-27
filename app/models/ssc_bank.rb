class SscBank < ActiveRecord::Base
  belongs_to :profile
  belongs_to :lifetime
  #VALID_MASK_REGEX = /\A[\d]+[,][\d]+[,][\d]+\z/i # 2 comas, 3 values max. 
  #validates :ct_mask, presence: true, format: { with: VALID_MASK_REGEX}
  validates :auth_option_id, presence: true
  validates :auth_value, presence: true
  validates :lifetime, presence: true
end
