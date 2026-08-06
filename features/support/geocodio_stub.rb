# frozen_string_literal: true

require 'webmock/cucumber'
WebMock.disable_net_connect!(allow_localhost: true)

# "tests must not hit geocodio api"
Before do
  fake_response = {
    results: [
      {
        response: {
          results: [
            {
              fields: {
                congressional_districts: [
                  {
                    current_legislators: [
                      {
                        type: 'representative',
                        bio: {
                          first_name: 'Rick',
                          last_name: 'Larsen'
                        },
                        references: {
                          govtrack_id: '400232'
                        }
                      },
                      {
                        type: 'senator',
                        bio: {
                          first_name: 'Patty',
                          last_name: 'Murray'
                        },
                        references: {
                          govtrack_id: '300076'
                        }
                      },
                      {
                        type: 'senator',
                        bio: {
                          first_name: 'Maria',
                          last_name: 'Cantwell'
                        },
                        references: {
                          govtrack_id: '300018'
                        }
                      }
                    ]
                  }
                ]
              }
            }
          ]
        }
      }
    ]
  }

  stub_request(:post, /api\.geocod\.io/)
    .to_return(
      status: 200,
      body: fake_response.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
end