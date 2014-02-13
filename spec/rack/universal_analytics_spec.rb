# Encoding: utf-8
require 'spec_helper'

describe Rack::UniversalAnalytics do

  include Rack::Test::Methods

  let(:tracker_id) { '123456-7' }
  let(:app)        { Rack::UniversalAnalytics::App.new(dummy, tracker_id: tracker_id) }
  let(:body)       { ['<html><head></head><body>Hello!</body></html>'] }
  let(:dummy)      { ->(env) { [200, env, body] } }

  before do
    get '/', {}, env
  end

  context 'with an html request' do

    let(:env) { { 'Content-Type' => 'text/html' } }

    it 'should augment the response body' do
      expect(last_response.body).to match(tracker_id)
    end

  end

  context 'with non-HTML requests' do

    let(:env) { { 'Content-Type' => 'text/plain' } }

    it 'passes the response body through unchanged' do
      expect(last_response.body).to eq(body.join)
    end

  end

  context 'with no Content-Type given' do

    let(:env) { {} }

    it 'passes the response body through unchanged' do
      expect(last_response.body).to eq(body.join)
    end

  end

  context 'with the tracker id set to a lamba' do

    let(:app) do
      Rack::UniversalAnalytics::App
        .new(dummy,
             tracker_id: ->(env) { env['universal_analytics.tracker_id'] }
        )
    end

    context 'with the correct environment variable NOT set' do

      context 'with an html request' do

        let(:env) { { 'Content-Type' => 'text/html' } }

        it 'should augment the response body' do
          expect(last_response.body).to eq(body.join)
        end

      end

    end

    context 'with the correct environment variable set' do

      context 'with an html request' do

        let(:env) do
          {
            'Content-Type'                   => 'text/html',
            'universal_analytics.tracker_id' => tracker_id
          }
        end

        it 'should augment the response body' do
          expect(last_response.body).to match(tracker_id)
        end

      end

    end

  end

end
