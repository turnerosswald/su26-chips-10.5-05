# frozen_string_literal: true

class BillsController < ApplicationController
  BILL_TYPES = %w[hr s hjres sjres hconres sconres hres sres].freeze

  def index
    @bill_types = BILL_TYPES
    @congress = params[:congress]
    @bill_type = params[:bill_type]
    @saved_bills = Bill.order(created_at: :desc)

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
    congress = params[:congress]
    number = params[:number]
    bill_type = params[:bill_type].downcase

    summary = fetch_summary(client, congress, bill_type, number)
    bill = Bill.save_from_api(build_bill_data(congress, number), summary)

    if bill
      link_sponsors(client, bill, congress, bill_type, number)
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

  def fetch_summary(client, congress, bill_type, number)
    summary_data = client.get("bill/#{congress}/#{bill_type}/#{number}/summaries")
    summary_data['summaries']&.last&.dig('text')
  end

  def build_bill_data(congress, number)
    {
      'title' => params[:title], 'congress' => congress,
      'number' => number, 'originChamber' => params[:original_chamber],
      'type' => params[:bill_type]
    }
  end

  def link_sponsors(client, bill, congress, bill_type, number)
    cosponsor_data = client.cosponsors(congress: congress, bill_type: bill_type, bill_number: number).get
    cosponsor_list = cosponsor_data['cosponsors'] || []
    cosponsor_list.each do |c|
      rep = Representative.find_by(bioguide_id: c['bioguideId'])
      bill.representatives << rep if rep && bill.representatives.exclude?(rep)
    end
  rescue Congress::Error => e
    Rails.logger.warn("could not fetch cosponsors: #{e.message}")
  end
end
