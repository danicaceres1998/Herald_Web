class BillersController < ApplicationController
  before_action :find_biller, only: %i[show edit update destroy]

  def show; end

  def new
    @errors = []
    @biller = Biller.new
  end

  def index
    @biller = Biller.new
    @errors = []
    render 'billers/new'
  end

  def edit; end

  def update
    if @biller.update(get_email_data)
      flash[:notice] = 'The Email data was updated successfully.'
      redirect_to new_biller_brand_path(@biller)
    else
      @biller.errors.full_messages.each { |error| @errors.push(error) }
      render 'edit'
    end
  end

  def create
    @errors = []
    # Getting the email data
    @biller = Biller.new(get_email_data)
    # Verifying the biller
    unless @biller.valid?
      @biller.errors.full_messages.each { |error| @errors.push(error) }
    end
    if @errors.empty?
      flash[:notice] = 'Valid Email Data, Please Continue.'
      @biller.save
      redirect_to new_biller_brand_path(@biller)
    else
      render 'billers/new'
    end
  end

  def destroy
    path = root_path
    unless @biller.brands.empty?
      @biller.brands.each do |brand|
        brand.products.each(&:destroy) unless brand.products.empty?
      end
      @biller.brands.each(&:destroy)
      flash[:notice] = 'Biller has been untracked successfully.'
      path = untrack_billers_path
    end
    @biller.destroy
    redirect_to path
  end

  private

  def find_biller
    @biller = Biller.find(params[:id])
    @errors = []
  end

  def get_email_data
    params.require(:biller).permit(:from, :contacts, :error)
  end
end