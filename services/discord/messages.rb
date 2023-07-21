# frozen_string_literal: true

require_relative 'base'

module Discord
  # API Wrapper for Discord messages API.
  class Messages < Base
    MESSAGES_LIMIT = 10
    PATH = 'channels/:channel_id/messages'

    def fetch
      request(method: :get, query: { limit: MESSAGES_LIMIT })
    end

    private

    def path
      substitute_url_args(PATH, { channel_id: @channel_id })
    end
  end
end
