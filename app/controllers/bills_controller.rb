# frozen_string_literal: true

class BillsController < ApplicationController
  BILL_TYPES = %w[hr s hjres sjres hconres sconres hres sres].freeze

  def index
    @bill_types = BILL_TYPES
    @congress = params[:congress]
    @bill_type = params[:bill_type]

    if @bill_type.present? && @congress.blank?
      flash.now[:alert] = 'Select a Congress session to search by bill type.'
      @bills = []
      @total = 0
      return
    end

    client = Congress::Client.new(Rails.application.credentials[:CONGRESS_GOV_API_KEY])
    result = get_bills(client)

    @bills = result['bills'] || []
    @total = result.dig('pagination', 'count') || @bills.length
  end

  def show
    @bill = Bill.find(params[:id])
  end

  def create
    client = Congress::Client.new(Rails.application.credentials[:CONGRESS_GOV_API_KEY])
    bill_type = params[:bill_type].downcase

    summary_data = client.get("bill/#{params[:congress]}/#{bill_type}/#{params[:number]}/summaries")
    summary = summary_data['summaries']&.last&.dig('text')

    bill_data = {
      'title' => params[:title], 'congress' => params[:congress],
      'number' => params[:number], 'originChamber' => params[:original_chamber],
      'type' => params[:bill_type]
    }

    if (bill = Bill.save_from_api(bill_data, summary))
      redirect_to bill
    else
      redirect_to bills_path, alert: 'Could not save that bill.'
    end
  end

  private

  def get_bills(client)
    if @congress.blank? && @bill_type.blank?
      client.bills(limit: 50).get
    elsif @bill_type.present?
      client.bills(congress: @congress, type: @bill_type).get
    else
      client.bills(congress: @congress).get
    end
  end
end
