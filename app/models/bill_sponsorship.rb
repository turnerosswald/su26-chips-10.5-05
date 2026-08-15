# frozen_string_literal: true

class BillSponsorship < ApplicationRecord
  belongs_to :bill
  belongs_to :representative
end
