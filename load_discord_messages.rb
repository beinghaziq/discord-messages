# frozen_string_literal: true

require 'colorize'
require 'dotenv'
require_relative 'services/discord/messages'

Dotenv.load

def main
  if messages_api_response.success?
    puts messages.colorize(:green)
  else
    puts messages_api_response.errors.colorize(:red)
  end
end

def messages_api_response
  @messages_api_response ||= Discord::Messages.new(args: {
                                                     channel_id: ENV['DISCORD_CHANNEL_ID'],
                                                     user_authentication_token: ENV['DISCORD_USER_AUTHENTICATION_TOKEN']
                                                   }).fetch
end

def messages
  messages_api_response.parsed_body.map { |message| message['content'] }.to_s
end

main
