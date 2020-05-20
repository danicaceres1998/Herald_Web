class BrandsController < ApplicationController
  def new
    @errors = []
    @biller = Biller.find(params[:biller_id])
    @brands = nil
  end

  def create
    @errors = []
  end

  def search_brands
    require 'net/http'
    require 'uri'
    require 'openssl'
    require 'json'
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
    @brands = {"status"=>"success", "brands"=>[{"id"=>1, "name"=>"ANDE", "url_name"=>"ande", \
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
  end

  private

  def get_name_brand
    params.permit(:brand_name)
  end
end