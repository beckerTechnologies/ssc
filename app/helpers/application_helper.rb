module ApplicationHelper
  #@@h = Hash[('a'..'z').to_a.zip (0..25).to_a]
  @@lt = [["12Hrs", 12],["1Day",24],["2Days", 48],["3Days", 72],["4Days", 96],["5Days", 120],["6Days", 144],["7Days", 168]]
  def set_ct
    return (rand(10)).to_s
  end
  def set_ssc (ct, ssc_val_s, ct_mask_s)
    ssc_val = ssc_val_s.split ''
    ct_mask = ct_mask_s.split ','
    ct_mask.each do |i|
      ind = (i).to_i
      ssc_val[ind] = ct
    end
    return ssc_val.join
  end
  def set_expiry (lifetime)
    return (Time.now + (60*60* lifetime))
  end
  def get_lifetime()
    return @@lt
  end

  def mail_helper(pid)
    ssc_bank = SscBank.find_by profile_id: pid
    ct = set_ct
    ssc = set_ssc(ct, ssc_bank[:ssc], ssc_bank[:ct_mask])
    expiry = set_expiry(ssc_bank[:lifetime])
    ssc_bank[:expiry] = expiry
    ssc_bank[:ssc] = ssc
    ssc_bank.valid?
    if ssc_bank.errors.present?
      #TODO figure out what should we do in this case?
    else
      ssc_bank.save!
      SscMailer.newct_email(pid, ct).deliver
  end
end
end
