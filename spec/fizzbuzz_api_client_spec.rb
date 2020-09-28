# frozen_string_literal: true

require 'webmock/rspec'
require 'fizzbuzz_api_client'
require 'vcr'
require 'support/vcr_setup'

RSpec.describe FizzbuzzApiClient do
  let(:base_url) { 'http://localhost:4000' }
  let(:resource_path) { 'api/v1/favourites' }
  let(:oauth2_base_url) { 'http://localhost:4000/oauth/token' }
  let(:client_id) { 'a2de6982055a1eb696c6c2b6c1040520a5ef4bddd46d25bc7b62a54f12bf5605' }
  let(:client_secret) { '8bda6b7c9300fccc7ec236c8c89ca5c02930a11e9b8e67f80e500c390194ac94' }
  let(:name) { 'johnl' }
  let(:password) { 'j123456l' }

  context '#begin_fizzbuzz' do
    let(:number) { 6_666_666_666 }
    let(:size) { 15 }
    let(:fizzbuzz_options) do
      {
        client_id: client_id,
        client_secret: client_secret,
        name: name,
        password: password,
        number: number,
        size: size
      }
    end
    let(:expected) do
      {
        first: { fizzbuzz: '99999999991', number: 99_999_999_991, state: false },
        last: { fizzbuzz: 'buzz', number: 100_000_000_000, state: false },
        next_pointer: nil
      }
    end
    it 'returns list of favourites' do
      VCR.use_cassette 'favourites/api_get_response' do
        response = FizzbuzzApiClient.new(base_url, resource_path, oauth2_base_url).begin_fizzbuzz(fizzbuzz_options)
        expect(response).to eq(expected)
      end
    end
  end

  context '#favourite' do
    let(:number) { 15 }
    let(:fizzbuzz) { 'fizzbuzz' }
    let(:state) { true }
    let(:favourite_options) do
      {
        client_id: client_id,
        client_secret: client_secret,
        name: name,
        password: password,
        number: number,
        fizzbuzz: fizzbuzz,
        state: state
      }
    end
    let(:expected) do
      {
        data:
        { attributes:
           { fizzbuzz: 'fizzbuzz', number: 15, state: true },
          id: '2',
          type: 'favourite' },
        status_code: 201
      }
    end
    it 'favourite a number' do
      VCR.use_cassette 'favourites/api_post_response' do
        response = FizzbuzzApiClient.new(base_url, resource_path, oauth2_base_url).favourite(favourite_options)
        expect(response).to eq(expected)
      end
    end
  end
end
