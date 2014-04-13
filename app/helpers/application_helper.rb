module ApplicationHelper
  def set_temp_password
    o = [('a'..'z'), ('A'..'Z'), ('1'..'9')].map { |i| i.to_a }.flatten
    a = [('a'..'z')].map { |i| i.to_a }.flatten
    w = [('A'..'Z')].map { |i| i.to_a }.flatten
    d = [('1'..'9')].map { |i| i.to_a }.flatten
    str = []
    str.push((0...9).map { o[rand(o.length)] }.join)
    str.push( a[rand(a.length)]) 
    str.push( w[rand(w.length)])
    str.push( d[rand(d.length)]) 
    pass = str.join
    # not using SecureRandom.base64(12) 
    # because docs contain the word "may" where we wanted to see "will"
  end
  def set_temp_boxcode (len)
    str = []
    while str.length<3 do
      temp = rand(len)
      str.push(temp) unless str.include? temp  
    end
    boxcode = str.join ','
    return boxcode
  end

  def set_ct
    return rand(10)
  end

  def set_ssc (ct, auth_val_s, ct_mask_s)
    auth_val = auth_val_s.split ''
    ct_mask = ct_mask_s.split ','
    ct_mask.each do |i|
      ind = (i).to_i - 1
      auth_val[ind] = ct
    end
    return auth_val.join
  end

  def set_expiry (lifetime)
    return (Time.now + (60*60* lifetime))
  end

  def mail_boxcode_helper(pid)
    ssc_bank = SscBank.find_by profile_id: pid
    # get new box code.
    len = ssc_bank.ssc.length
    new_box_code = set_temp_boxcode len
    # decode the old ct. 
    ssc = (ssc_bank.ssc).split
    box = (ssc_bank.ct_mask).split(',')
    ct = ssc[box[0]]
    # set new ssc
    new_ssc = set_ssc(ct, ssc_bank[:auth_value], new_box_code)
    # set new expiry
    lifetime = Lifetime.find(ssc_bank.lifetime_id)
    expiry = set_expiry(lifetime[:hours])
    # put every new thing in 
    ssc_bank[:expiry] = expiry
    ssc_bank[:ssc] = new_ssc
    ssc_bank[:ct_mask] = new_box_code
    ssc_bank.valid?
    if ssc_bank.errors.present?
      #TODO figure out what should we do in this case?
    else
      ssc_bank.save!
      SscMailer.newbox_email(pid, new_box_code).deliver
    end
  end

  def mail_ct_helper(pid)
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
