class RenewWorker
  include Sidekiq::Worker
  include ApplicationHelper

  def perform (pid)
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
      #TODO send sms here
    end
  end
end

