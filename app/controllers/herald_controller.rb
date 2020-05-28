class HeraldController < ApplicationController
  def home; end

  def report_problem
    @biller = Biller.find(params[:biller_id])
    # Disabling the service
    @biller.brands.each do |brand|
      brand.products.each do |prd|
        # disable_service(prd.product_id, brand.brand_name, prd.product_name)
      end
    end
    # Sending the email to the biller
    # EmailSender.send_email_biller(@biller.from, @biller.brands.first.brand_name, @biller.contacts, @biller.error, false)
    # Sending the email to the entities
    products = []
    @biller.brands.each do |brand|
      # Getting the products
      brand.products.each { |prd| products.push({ id: prd.product_id, name_prd: prd.product_name }) }
    end
    # EmailSender.send_email_entities(@biller.from, @biller.brands.first.brand_name, products, @biller.error, false)
    flash[:notice] = 'Error Reported Successfully'
    redirect_to tracked_billers_path
  end

  def show_tracked_billers
    @billers = Biller.all
  end

  def show_list_for_untrack
    @billers = Biller.all
  end

  def untrack_biller
    @biller = Biller.find(params[:id])
    @biller.brands.each do |brand|
      brand.products.each do |prd|
        # enable_service(prd.product_id)
      end
    end
    # Sending the emails
    # EmailSender.send_email_biller(@biller.from, @biller.brands.first.brand_name, @biller.contacts, nil, true)
    # EmailSender.send_email_entities(@biller.from, @biller.brands.first.brand_name, nil, nil, true)
    redirect_to biller_path(@biller), method: :delete
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
