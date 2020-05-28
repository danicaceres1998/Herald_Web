class EmailSender
  # Class Constants
  @@ENTITY_EMAIL_CODE = 1
  @@BILLER_EMAIL_CODE = 2

  # Functions
  def self.read_email_entities(biller_name, products, error, is_active_email)
    # Getting the message
    message = Time.now.strftime('%H').to_i < 12 ? 'Buenos Dias,' : 'Buenas Tardes,'
    @email = Email.find(@@ENTITY_EMAIL_CODE)
    message += @email.message
    # Changing the message
    message['BILLER'] = biller_name
    unless is_active_email
      message['ERROR_LOG'] = error
      brand_product = ''
      products.each { |prd| brand_product += "-> ID: #{prd[:id]}\tNombre: #{prd[:name_prd]}\n" }
      message['BILLER_PRODUCTS'] = brand_product
    end
    # Returning the message
    message
  end

  def self.read_email_biller(biller_name, error, is_active_email)
    # Getting the message
    message = Time.now.strftime('%H').to_i < 12 ? 'Buenos Dias,' : 'Buenas Tardes,'
    @email = Email.find(@@BILLER_EMAIL_CODE)
    message += @email.message
    # Changing the message
    message['BILLER'] = biller_name
    message['ERROR_LOG'] = error unless is_active_email
    # Returning the message
    message
  end

  def self.send_email_entities(user_email, biller_name, products, error, is_active_email)
    #  Configuration for the email
    Mail.defaults do
      delivery_method :smtp, address: '192.100.1.12', port: 25
    end
    # Reading and configurating the message
    message = read_email_entities(biller_name, products, error, is_active_email)
    # Configuration for send the email
    mail = Mail.new do
      from     user_email
      subject  "Avisos API Entidades - #{biller_name}"
      body     message
    end
    mail.charset = 'UTF-8'
    mail.content_transfer_encoding = '8bit'
    # Hidden Copy
    mail.bcc = @email.contacts
    # Sending the email
    mail.deliver!
  end

  def self.send_email_biller(user_email, biller_name, contacts, error, is_active_email)
    #  Configuration for the email
    Mail.defaults do
      delivery_method :smtp, address: '192.100.1.12', port: 25
    end
    # Reading and configurating the message
    message = read_email_biller(biller_name, error, is_active_email)
    # Configuration for send the email
    mail = Mail.new do
      from     user_email
      subject  "Avisos Facturadores - #{biller_name}"
      body     message
    end
    mail.charset = 'UTF-8'
    mail.content_transfer_encoding = '8bit'
    # Contacts of the Biller
    mail.to = contacts
    # Copy to
    mail.cc = @email.contacts
    # Sending the email
    mail.deliver!
  end
end