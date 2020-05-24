class HeraldController < ApplicationController
  def home; end

  def report_problem
    @biller = Biller.find(params[:biller_id])
    # Disabling the service
    @biller.brands.each do |brand|
      brand.products.each do |prd|
        disable_service(prd.product_id, brand.brand_name, prd.product_name)
      end
    end
    # Sending the email to the biller
    @email_sender.send_email_biller(@user_email, @biller[0]['name_brand'], @biller_contacts.split('; '), error.join("\n"), false)
    # Sending the email to the entities
    products = []
    @biller.each {|row| products.push({id: row[2], name_prd: row[3]})}
    @email_sender.send_email_entities(@user_email, @biller[0]['name_brand'], products, error.join("\n"), false)
  end

  private

  # Function that disable one service
  def disable_service(product_id, brand_name, product_name)
    petition = "curl -X POST -u 'apps/i9Pc7v5W8m4jVaPc51a14RiA5K8TLGmy:59fRSmdYHljB.Yew6wCGdRTADF6eSCwc05gXnCfs' "
    petition += "https://10.10.17.104:4481/billing/api/0.2/extra_product_params -F 'extra_product_params[product_id]=#{product_id}' -F "
    petition += "'extra_product_params[group]=notification_message' -F 'extra_product_params[params][message]="
    petition += "El servicio #{brand_name} - #{product_name} se encuentra en mantenimiento, lo estaremos restableciendo en la brevedad posible' -k"
    system(petition)
  end

  # Function that enable one service
  def enable_service(product_id)
    petition = "curl -X DELETE -u 'apps/i9Pc7v5W8m4jVaPc51a14RiA5K8TLGmy:59fRSmdYHljB.Yew6wCGdRTADF6eSCwc05gXnCfs' "
    petition += "https://10.10.17.104:4481/billing/api/0.2/extra_product_params/#{product_id}/notification_message -k"
    system(petition)
  end
end
