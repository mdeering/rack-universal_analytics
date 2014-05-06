# Encoding: utf-8
require 'spec_helper'

describe Rack::UniversalAnalytics do
  include Rack::Test::Methods

  let(:app) do
    Rack::UniversalAnalytics
      .new(dummy,
           property_url: property_url,
           tracking_id:  tracking_id,
           personality: personality
      )
  end
  let(:body)         { ['<html><head></head><body>Hello!</body></html>'] }
  let(:dummy)        { ->(env) { [200, env, body] } }
  let(:property_url) { 'mitremedia.com' }
  let(:tracking_id)  { 'UA-123456789-2' }

  before do
    get '/', {}, env
  end

  context 'with no personality set' do
    let(:personality) {}
    context 'with an html request' do
      let(:env) { { 'Content-Type' => 'text/html' } }

      it 'pass the response body through unchanged' do
       expect(last_response.body).to eq(body.join)
      end

    end
  end

  context 'with universal personality' do
    let(:personality)  { :universal }

    context 'with an html request' do

     let(:env) { { 'Content-Type' => 'text/html' } }

     it 'should augment the response body' do
        expect(last_response.body).to match(tracking_id)
     end

     it 'should inject the universal analytics code' do
        expect(last_response.body).to match('i,s,o,g,r,a,m')
     end

     it 'should not inject the async analytics code' do
        expect(last_response.body).not_to match(/\_gaq\.push\(\[\'\_trackPageview\'\]\)\;/)
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

    context 'with the tracking id set to a lamba' do

     let(:tracking_id) { ->(env) { env['google_analytics.tracking_id'] } }

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
              'Content-Type'                 => 'text/html',
              'google_analytics.tracking_id' => scoped_tracking_id
           }
         end

         let(:scoped_tracking_id) { 'UA-987654321-7' }

         it 'should augment the response body' do
            expect(last_response.body).to match(scoped_tracking_id)
         end

        end
      end
    end
  end

  context 'with async personality' do
   let(:personality) { :async }

   context 'with an html request' do
      let(:env) { { 'Content-Type' => 'text/html' } }

      it 'should augment the response body' do
        expect(last_response.body).to match(tracking_id)
      end

      it 'should inject the async analytics code' do
        expect(last_response.body).to match(/\_gaq\.push\(\[\'\_trackPageview\'\]\)\;/)
      end

      it 'should not inject the universal analytics code' do
        expect(last_response.body).not_to match('i,s,o,g,r,a,m')
      end
    end
  end
end
