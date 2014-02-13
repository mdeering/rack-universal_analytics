# Encoding: utf-8
require 'spec_helper'

describe Rack::UniversalAnalytics do

  include Rack::Test::Methods

  let(:dummy) { ->(env) { [200, env, 'OK']} }
  let(:app) { Rack::UniversalAnalytics::App.new(dummy) }

  context 'with an html request' do
    let(:env) { {'Content-Type' => 'text/html'} }

    it 'should augment the response body' do
      get '/', {}, env
      expect(last_response.body).to eq('Rack::UniversalAnalytics was here!')
    end

  end

  context 'with non-HTML requests' do

    let(:env) { {'Content-Type' => 'text/plain'} }

    it 'passes the request through unchanged' do
      get '/', {}, env
      expect(last_response.body).to eq('OK')
    end

  end

end
