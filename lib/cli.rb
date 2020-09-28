# frozen_string_literal: true

require 'thor'
require './lib/fizzbuzz_api_client'
class FizzbuzzApiClientCLI < Thor
  option :number, type: :numeric, required: true, desc: 'The page number'
  option :size, type: :numeric, required: true, desc: 'The page size'
  option :client_id, type: :string, required: true, desc: 'The oauth2 application client_id'
  option :client_secret, type: :string, required: true, desc: 'The oauth2 application client_secret'
  option :name, type: :string, required: true, desc: 'The name of the resource owner'
  option :password, type: :string, required: true, desc: 'The password of the resource owner'
  desc 'fizzbuzz BASE_URL', 'base url of resource addresses'
  desc 'fizzbuzz RESOURCE_PATH', 'url path for resource addresses'
  desc 'fizzbuzz OAUTH2_BASE_URL', 'base url for oauth2 server'
  def fizzbuzz(base_url, resource_path, oauth2_base_url)
    FizzbuzzApiClient.new(base_url, resource_path, oauth2_base_url).begin_fizzbuzz(options)
  rescue RestClient::ResourceNotFound, URI::InvalidURIError, RestClient::ExceptionWithResponse => e
    puts e.response
    puts "status_code: #{e.response.code}"
  end

  option :number, type: :numeric, required: true, desc: 'The number'
  option :fizzbuzz, type: :string, required: true, desc: 'The fizzbuzz of the number'
  option :state, type: :string, required: true, desc: 'The favourite state of the number'
  option :client_id, type: :string, required: true, desc: 'The oauth2 application client_id'
  option :client_secret, type: :string, required: true, desc: 'The oauth2 application client_secret'
  option :name, type: :string, required: true, desc: 'The name of the resource owner'
  option :password, type: :string, required: true, desc: 'The password of the resource owner'
  desc 'fizzbuzz BASE_URL', 'base url of resource addresses'
  desc 'fizzbuzz RESOURCE_PATH', 'url path for resource addresses'
  desc 'fizzbuzz OAUTH2_BASE_URL', 'base url for oauth2 server'
  def favourite(base_url, resource_path, oauth2_base_url)
    FizzbuzzApiClient.new(base_url, resource_path, oauth2_base_url).favourite(options)
  rescue RestClient::ResourceNotFound, URI::InvalidURIError, RestClient::ExceptionWithResponse => e
    puts e.response
    puts "status_code: #{e.response.code}"
  end
end
FizzbuzzApiClientCLI.start(ARGV)
