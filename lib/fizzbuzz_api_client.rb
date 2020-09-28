# frozen_string_literal: true

require 'json'
require 'oauth2'
require 'rest-client'
# api client
class FizzbuzzApiClient
  def initialize(base_url, resource_path, oauth2_base_url)
    @base_url = base_url || ENV.fetch('FIZZBUZZ_API_URL')
    @resource_path = resource_path || ENV.fetch('FIZZBUZZ_RESOURCE_PATH')
    @oauth2_base_url = oauth2_base_url || ENV.fetch('OAUTH2_BASE_URL')
    @headers = { 'Accept' => 'application/vnd.api+json' }
  end

  def fizzbuzz(next_pointer)
    response = RestClient.get("#{base_url}#{next_pointer}", headers)
    body = response_json(response)
    data = show_body(body)
    return data if data[:next_pointer].nil?

    fizzbuzz(data[:next_pointer])
  end

  def begin_fizzbuzz(options)
    oauth2_options(options)
    resource = "#{resource_path}?page[number]=#{options[:number]}&page[size]=#{options[:size]}"
    @access_token = oauth2_access_token
    headers['Authorization'] = "Bearer #{access_token}"
    response = RestClient.get("#{base_url}/#{resource}", headers)
    body = response_json(response)
    data = show_body(body)
    fizzbuzz(data[:next_pointer])
  end

  def favourite(options)
    oauth2_options(options)
    @access_token = oauth2_access_token
    headers['Authorization'] = "Bearer #{access_token}"
    headers['Content-type'] = 'application/vnd.api+json'
    response = RestClient.post("#{base_url}/#{resource_path}", payload(options), headers)
    body = response_json(response)
    { status_code: response.code, data: body[:data] }
  end

  private

  def oauth2_url
    <<-URL.strip
    #{oauth2_base_url}?client_id=#{client_id}&client_secret=#{client_secret}&grant_type=password&username=#{name}&password=#{password}
    URL
  end

  def oauth2_options(options)
    @client_id = options[:client_id]
    @client_secret = options[:client_secret]
    @name = options[:name]
    @password = options[:password]
  end

  def oauth2_access_token
    oauth_response = RestClient.post(oauth2_url, '')
    @access_token = response_json(oauth_response)[:access_token]
  end

  def response_json(payload = response)
    JSON.parse(payload.body, symbolize_names: true)
  end

  def payload(options)
    number = options[:number]
    fizzbuzz = options[:fizzbuzz]
    state = options[:state]
    "{
      \"data\": {
      \"type\": \"favourite\",
      \"attributes\": {
        \"number\": #{number},\"fizzbuzz\": \"#{fizzbuzz}\",\"state\": #{state}
      }
    }}"
  end

  def data(body)
    next_pointer = body[:links][:next]
    first = body[:data].first[:attributes]
    last = body[:data].last[:attributes]
    { first: first, last: last, next_pointer: next_pointer }
  end

  def show_body(body)
    data(body).each { |_k, v| puts v }
  end

  attr_reader :client_id, :client_secret, :name, :password, :base_url, :resource_path, :oauth2_base_url, :headers,
              :access_token
end
