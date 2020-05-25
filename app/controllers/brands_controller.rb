class BrandsController < ApplicationController
  def new
    @errors = []
    @biller = Biller.find(params[:biller_id])
    @brands = @biller.brands
  end

  def create
    @errors = []
    @biller = Biller.find(params[:biller_id])
    json_list = get_selected_brands
    if !json_list.is_a? Array
      @errors.push('The list of Selected Brands is empty')
      render 'new'
    else
      @list_brands = []
      json_list.each { |br| @list_brands.push(JSON.parse(br.gsub('=>', ':'))) }
      @brands = []
      @products = []
      @list_brands.each do |br|
        @brands.push(Brand.new(brand_code: br['id'], brand_name: br['name'], biller_id: params[:biller_id]))
      end
      @brands.each { |brand| brand.valid? ? brand.save : brand.errors.full_messages.each { |e| @errors.push(e) }}
      @list_brands.length.times do |i|
        @list_brands[i]['products'].each do |prd|
          @products.push(Product.new(product_id: prd['id'], product_name: prd['name'], brand_id: @brands[i].id))
        end
      end
      @products.each { |prd| prd.valid? ? prd.save : prd.errors.full_messages.each { |e| @errors.push(e) }}
    end
  end

  def recreate_brand
    @errors = []
    @biller = Biller.find(params[:biller_id])
    @brands = @biller.brands
  end

  def search_brands
    require 'net/http'
    require 'uri'
    require 'openssl'
    Struct.new('BrandStruct', :hash_brand, :selected_opt)
      #OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
      #response = nil
      #uri = URI('https://10.10.17.104:4481/billing/api/0.2/brands')
    #Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      #req = Net::HTTP::Get.new(uri)
        #req.basic_auth 'apps/i9Pc7v5W8m4jVaPc51a14RiA5K8TLGmy', '59fRSmdYHljB.Yew6wCGdRTADF6eSCwc05gXnCfs'
        #response = http.request(req) # Net::HTTPResponse object
      #end
      #showing_billers(JSON.parse(response.body))
    @errors = []
    @biller = Biller.find(params[:biller_id])
    @brand = Brand.new
    @list_brands = []
    brand_name = get_name_brand
    response = {"status"=>"success", "brands"=>[{"id"=>1, "name"=>"ANDE", "url_name"=>"ande", \
            "logo_resource_id"=>"09e0442830be471db2ff9d7976c5f757.png", \
            "full_logo_url"=>"https://www.bancard.com.py/s4/public/billing_brands_logos/09e0442830be471db2ff9d7976c5f757.png.normal.png", \
            "products"=>[{"id"=>1, "name"=>"Pago de Factura", "description"=>"Pago de Factura", "group_id"=>1, \
            "queries_debt?"=>true}]}, {"id"=>2, "name"=>"Copaco", "url_name"=>"copaco", \
            "logo_resource_id"=>"7cbf154d-478c-4ee6-8882-b0c6be73ee3e", \
            "full_logo_url"=>"https://www.bancard.com.py/s4/public/billing_brands_logos/7cbf154d-478c-4ee6-8882-b0c6be73ee3e.normal.png", \
            "products"=>[{"id"=>2, "name"=>"Pago de Factura", "description"=>"Pago de Factura", "group_id"=>1, \
            "queries_debt?"=>true}, {"id"=>3, "name"=>"Recarga de Saldo", "description"=>"Recarga de Minutos", \
            "group_id"=>2, "queries_debt?"=>false}, {"id"=>93, "name"=>"Pago de factura por cuenta", \
            "description"=>"Pago de Factura por cuenta", "group_id"=>1, "queries_debt?"=>true}]}, \
            {"id"=>3, "name"=>"Essap", "url_name"=>"essap", "logo_resource_id"=>"7c2a3d7b-d849-4c38-a44b-d0f597739a62",\
            "full_logo_url"=>"https://www.bancard.com.py/s4/public/billing_brands_logos/7c2a3d7b-d849-4c38-a44b-d0f597739a62.normal.png", \
            "products"=>[{"id"=>4, "name"=>"Pago de Factura", "description"=>"Pago de Factura", "group_id"=>1, "queries_debt?"=>true}]}]}
      #brands = response['brands'].select { |br| br['name'].downcase.include? brand_name[:brand_name] }
    response['brands'].each { |brand| @list_brands.push(Struct::BrandStruct.new(brand, false)) }
  end

  def research_brand
    @errors = []
    @biller = Biller.find(params[:biller_id])
    @brands = @biller.brands
    @brands.each { |br| br.products.each(&:destroy) }
    @brands.each(&:destroy)
    redirect_to new_biller_brand_path
  end

  def filter_products
    @errors = []
    @biller = Biller.find(params[:biller_id])
    @brands = @biller.brands
    60.times { print '-' }; puts
    selected_products = get_selected_prd
    puts selected_products
    if selected_products.is_a? Array
      @brands.each do |brand|
        brand.products.each do |prd|
          unless selected_products.include? prd.product_id.to_s
            prd.destroy
            brand.products.delete(prd)
          end
        end
      end
    else
      @errors.push('The list of Selected Products is empty')
      render 'create'
    end

  end

  private

  def get_name_brand
    params.permit(:brand_name)
  end

  def get_selected_brands
    params[:list_brands]
  end

  def get_selected_prd
    params[:list_prd]
  end

end