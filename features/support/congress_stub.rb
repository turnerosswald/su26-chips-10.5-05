# frozen_string_literal: true

require 'webmock/cucumber'
WebMock.disable_net_connect!(allow_localhost: true)

Before do
  bill_list_response = {
    bills: [
      {
        congress: 119,
         number: '134',
         originChamber: 'House',
         title: 'Protecting our Communities from Sexual Predators Act',
         type: 'HR',
         latestAction: { actionDate: '2025-01-03', text: 'Referred to the House Committee on the Judiciary.' }
      }
    ],
    pagination: { count: 10_081 }
  }

  summary_response = {
    summaries: [
      {
        actionDate: '2025-01-03',
        actionDesc: 'Introduced in House',
        text: '<p>This bill requires DOJ to detain non-citizens arrested for sexual assault.</p>',
        updateDate: '2025-02-03T21:16:45Z',
        versionCode: '00'
      }
    ]
  }

  stub_request(:get, %r{api\.congress\.gov/v3/bill})
    .to_return(status: 200, body: bill_list_response.to_json, headers: { 'Content-Type' => 'application/json' })

  stub_request(:get, /summaries/)
    .to_return(status: 200, body: summary_response.to_json, headers: { 'Content-Type' => 'application/json' })
end
