class EmailDomainValidator < ActiveModel::Validator
  def validate(record)
    if record.email.strip.end_with? '@j-scorer.com'
      record.errors[:email] << "Can't be @j-scorer.com"
    end
  end
end
