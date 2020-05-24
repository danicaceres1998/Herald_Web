class EmailSender
  def self.read_email_entities(biller_name, products, error, path, is_active_email)
    # Getting the message
    message = Time.now.strftime('%H').to_i < 12 ? 'Buenos Dias,' : 'Buenas Tardes,'
    File.foreach(path, "r:UTF-8")  {|line| message += line}
    # Changing the message
    if is_active_email
      message['BILLER'] = biller_name
    else
      message['BILLER'] = biller_name
      message['ERROR_LOG'] = error
      brand_product = ''
      products.each {|prd| brand_product += "-> ID: #{prd[:id]}\tNombre: #{prd[:name_prd]}\n"}
      message['BILLER_PRODUCTS'] = brand_product
    end
    # Returning the message
    message
  end

  def self.read_email_biller(biller_name, error, path, is_active_email)
    # Getting the message
    message = Time.now.strftime('%H').to_i < 12 ? 'Buenos Dias,' : 'Buenas Tardes,'
    File.foreach(path, "r:UTF-8")  {|line| message += line}
    # Changing the message
    if is_active_email
      message['BILLER'] = biller_name
    else
      message['BILLER'] = biller_name
      message['ERROR_LOG'] = error
    end
    # Returning the message
    message
  end

  def self.get_contacts(path, contacts)
    File.foreach(path) do |line|
      contacts.push(line)
    end
  end

  def self.send_email_entities(user_email, biller_name, products, error, is_active_email)
    #  Configuration for the email
    Mail.defaults do
      delivery_method :smtp, address: '192.100.1.12', port: 25
    end
    # Reading and configurating the message
    is_active_email ? path = @@DIR_ACTIVE_EMAIL : path = @@DIR_EMAIL_ENTITIES
    message = self.read_email_entities(biller_name, products, error, path, is_active_email)
    # Configuration for send the email
    mail = Mail.new do
      from     user_email
      subject  "Avisos API Entidades - #{biller_name}"
      body     message
    end
    mail.charset = 'UTF-8'
    mail.content_transfer_encoding = '8bit'
    # Hidden Copy
    self.get_contacts(@@DIR_CCO_ENTITIES, @entities_contacts)
    mail.bcc = @entities_contacts.join('; ')
    # Sending the email
    begin
      mail.deliver!
      puts "SUCCESS #{Time.now.strftime('%Y-%m-%d %H:%M:%S')} -> Entities email sended (see the contacts in Herald/emails/entities_contacts.txt)"
      log("SUCCESS #{Time.now.strftime('%Y-%m-%d %H:%M:%S')} -> Entities email sended (see the contacts in Herald/emails/entities_contacts.txt)", is_active_email)
    rescue Exception => msg
      puts "ERROR #{Time.now.strftime('%Y-%m-%d %H:%M:%S')} -> Unable to send Entities email (see the contacts in Herald/emails/entities_contacts.txt)"
      log("ERROR #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}: #{msg} -> Unable to send Entities email (see the contacts in Herald/emails/entities_contacts.txt)", is_active_email)
    end
  end

  def self.send_email_biller(user_email, biller_name, contacts, error, is_active_email)
    #  Configuration for the email
    Mail.defaults do
      delivery_method :smtp, address: '192.100.1.12', port: 25
    end
    # Reading and configurating the message
    is_active_email ? path = @@DIR_ACTIVE_EMAIL : path = @@DIR_EMAIL_BILLER
    message = self.read_email_biller(biller_name, error, path, is_active_email)
    # Configuration for send the email
    mail = Mail.new do
      from     user_email
      subject  "Avisos Facturadores - #{biller_name}"
      body     message
    end
    mail.charset = 'UTF-8'
    mail.content_transfer_encoding = '8bit'
    # Contacts of the Biller
    mail.to = contacts.join('; ')
    self.get_contacts(@@DIR_CC_CONTACTCS, @cc_contacts)
    mail.cc = @cc_contacts.join('; ')
    # Sending the email
    begin
      mail.deliver!
      puts "SUCCESS #{Time.now.strftime('%Y-%m-%d %H:%M:%S')} -> Biller email sended to: #{contacts.join('; ')}"
      log("SUCCESS #{Time.now.strftime('%Y-%m-%d %H:%M:%S')} -> Biller email sended to: #{contacts.join('; ')}", is_active_email)
    rescue Exception => msg
      puts "ERROR #{Time.now.strftime('%Y-%m-%d %H:%M:%S')} -> Unable to send Biller email to: #{contacts.join('; ')}"
      log("ERROR #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}: #{msg} -> Unable to send Biller email to: #{contacts.join('; ')}", is_active_email)
    end
  end
end