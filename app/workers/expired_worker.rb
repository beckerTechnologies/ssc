class RenewWorker
  include Sidekiq::Worker

  def perform (pid)
    a = SscBank.where("expiry >= :now",{now: Time.now})
    a.each do |record|
      ct = createSsc(record.id)
      sendemail(record.id, ct)

    end
  end
end
