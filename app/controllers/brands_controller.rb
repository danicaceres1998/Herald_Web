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
    response = nil
    uri = URI('https://10.10.17.104:4481/billing/api/0.2/brands')
    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      req = Net::HTTP::Get.new(uri)
      req.basic_auth 'apps/i9Pc7v5W8m4jVaPc51a14RiA5K8TLGmy', '59fRSmdYHljB.Yew6wCGdRTADF6eSCwc05gXnCfs'
      response = http.request(req) # Net::HTTPResponse object
    end
    response = JSON.parse(response.body)
    @errors = []
    @biller = Biller.find(params[:biller_id])
    @brand = Brand.new
    @list_brands = []
    brand_name = get_name_brand
    brands = response['brands'].select { |br| br['name'].downcase.include? brand_name[:brand_name].downcase }
    brands.each { |brand| @list_brands.push(Struct::BrandStruct.new(brand, false)) }
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
    selected_products = get_selected_prd
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