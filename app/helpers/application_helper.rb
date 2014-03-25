module ApplicationHelper
  @@h = Hash[('a'..'z').to_a.zip (0..25).to_a]
  def set_ct
    return rand(10)
  end
  def set_ssc (ct, ssc_val_s, ct_mask_s)
    ssc_val = ssc_val_s.split ''
    ct_mask = ct_mask_s.split ''
    ct_mask.each do |i|
      ind = @@h[i]
      ssc_val[ind] = ct
    end
    return ssc_val.join
  end
  def set_expiry (lifetime)
    return (Time.now + (60*60* lifetime))
  end
end
