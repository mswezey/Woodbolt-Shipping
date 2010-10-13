class Notifier < ActionMailer::Base  
  default_url_options[:host] = "wb-shipping.heroku.com"  #change before production
  
  def password_reset_instructions(user)  
    subject       "Password Reset Instructions"  
    from          "Application"  #change before production
    recipients    user.email  
    sent_on       Time.now  
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
  end
  
  def shipment_assigned(shipment)
    subject       "New Shipment Notice"
    from          "Application"  #change before production
    recipients    shipment.assigned_to.email  
    sent_on       Time.now  
    @body[:shipment] = shipment
  end
  
  def new_note(note)
    subject       "New Note for Shipment #{note.shipment.reference_number}"
    from          "Application"  #change before production
    recipients    note.shipment.users.map(&:email)
    sent_on       Time.now  
    @body[:note] = note
  end
  
  
  
end
