# frozen_string_literal: true

class RatingsController < ApplicationController
  before_action :require_login!
  def create
    representative = Representative.find(params[:representative_id])
    news_item = representative.news_items.find(params[:news_item_id])
    rating = news_item.ratings.find_or_initialize_by(user: current_user)
    rating.score = params[:rating][:score]
    if rating.save
      redirect_to representative_news_item_path(representative, news_item),
                  notice: 'Rating was successfully saved.'
    else
      redirect_to representative_news_item_path(representative, news_item),
                  alert: 'Rating could not be saved.'
    end
  end
end
