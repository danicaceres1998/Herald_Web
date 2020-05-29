class EmailsController < ApplicationController
  before_action :get_emails, only: %i[update_messages update_contacts update]
  # Class Constants
  @@ENTITY_EMAIL_CODE = 1
  @@BILLER_EMAIL_CODE = 2
  @@ACTIVE_EMAIL_CODE = 3

  def update
    @email = Email.find(params[:id])
    @update_condition = get_message[:message].is_a?(String) ? true : false
    data = @update_condition ? get_message : get_contacts
    unless @update_condition
      data[:contacts].gsub!("\r\n", '; ')
      check_email_addresses(data[:contacts], @errors)
    end
    if @errors.empty? and @email.update(data)
      flash[:notice] = 'The Email data was updated successfully.'
      redirect_to @update_condition ? update_messages_path : update_contacts_path
    else
      @email.errors.full_messages.each { |error| @errors.push(error) }
      @emails.each { |email| email.contacts.gsub!('; ', "\n") }
      render 'update_messages'
    end
  end

  def update_messages
    @update_condition = true
  end

  def update_contacts
    @update_condition = false
    @emails.each { |email| email.contacts.gsub!('; ', "\n") }
  end

  # Class Functions
  def self.read_email_entities(biller_name, products, error, is_active_email)
    # Getting the message
    message = Time.now.strftime('%H').to_i < 12 ? 'Buenos Dias,' : 'Buenas Tardes,'
    @email = is_active_email ? Email.find(@@ACTIVE_EMAIL_CODE) : Email.find(@@ENTITY_EMAIL_CODE)
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
    @email = is_active_email ? Email.find(@@ACTIVE_EMAIL_CODE) : Email.find(@@BILLER_EMAIL_CODE)
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
    mail.bcc = Email.find(@@ENTITY_EMAIL_CODE).contacts
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
    mail.cc = Email.find(@@BILLER_EMAIL_CODE).contacts
    # Sending the email
    mail.deliver!
  end

  private

  def get_emails
    @emails = Email.all
    @errors = []
  end

  def get_message
    params.require(:email).permit(:message)
  end

  def get_contacts
    params.require(:email).permit(:contacts)
  end

  def check_email_addresses(contacts, errors)
    valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    contacts.split('; ').each do |email|
      unless email =~ valid_email_regex
        errors.push("Email: this email address -> '#{email}' is invalid")
      end
    end
  end
end