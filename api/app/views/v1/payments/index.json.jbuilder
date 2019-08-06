# frozen_string_literal: true

json.array! @payments do |payment|
  json.payment_timestamp payment.payment_timestamp.to_i
  json.state payment.state
  json.total payment.total
end
