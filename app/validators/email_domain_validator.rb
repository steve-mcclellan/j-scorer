class EmailDomainValidator < ActiveModel::Validator
  def validate(record)
    return 'OK' unless record.email.strip.end_with? '@j-scorer.com'
    record.errors[:email] << "Can't be @j-scorer.com"
  end
end
