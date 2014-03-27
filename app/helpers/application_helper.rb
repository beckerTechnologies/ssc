module ApplicationHelper
  def set_ct
    return rand(10)
  end

  def set_ssc (ct, auth_val_s, ct_mask_s)
    auth_val = auth_val_s.split ''
    ct_mask = ct_mask_s.split ','
    ct_mask.each do |i|
      ind = (i).to_i
      auth_val[ind] = ct
    end
    return auth_val.join
  end

  def set_expiry (lifetime)
    return (Time.now + (60*60* lifetime))
  end

  def mail_helper(pid)
    ssc_bank = SscBank.find_by profile_id: pid
    ct = set_ct
    ssc = set_ssc(ct, ssc_bank[:ssc], ssc_bank[:ct_mask])
    lifetime = Lifetime.find(ssc_bank.lifetime_id)
    expiry = set_expiry(lifetime[:hours])
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
