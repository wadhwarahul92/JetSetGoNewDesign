if @seat_locker.all_allowed_for_sale?
  json.status 'success'
  json.message 'proceed to payment'
  json.transaction_id @jetsteal_seat_purchaser.payment_transaction.id
else
  json.status 'failure'
  json.message 'Looks like some of the seats you chose, are locked or booked'
end