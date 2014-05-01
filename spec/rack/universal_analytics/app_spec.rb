# Encoding: utf-8

# rubocop:disable UnusedBlockArgument

require 'spec_helper'

describe Rack::UniversalAnalytics::App do

  let(:app)     { nil }
  let(:options) { {} }

  subject { Rack::UniversalAnalytics::App.new(app, options) }

  describe '#html? HTML response detection' do

    {
      'text/html'  => true,
      'text/plain' => false,
      'text/HTML'  => true
    }.each do |content_type, is_html_or_not|
      it "should #{'NOT ' unless is_html_or_not}treat the MIME Type of #{content_type} as HTML" do
        subject.instance_variable_set('@headers', 'Content-Type' => content_type)
        expect(subject.send(:html?)).to eq(is_html_or_not)
      end
    end

  end

  describe '#property_url' do

    let(:options)    { { property_url: property_url } }

    context 'when set as a string in the options hash' do

      let(:property_url) { 'mdeering.com' }

      it 'should just return that string that was passed in' do
        expect(subject.send(:property_url)).to eq(property_url)
      end

    end

    context 'when set as a lamda in the options hash' do

      let(:property_url) { ->(env) { 'mdeering.com' } }

      it 'should call our lambda for the result' do
        expect(subject.send(:property_url)).to eq(property_url.call(nil))
      end

      context 'the environment passed into the lambda' do

        let(:env)         { { this: :that } }
        let(:property_url) { ->(env) { env[:this] } }

        it 'for use in the evaluation' do
          subject.instance_variable_set('@env', env)
          expect(subject.send(:property_url)).to eq(:that)
        end

      end

    end
  end

  describe '#tracking_id' do

    let(:options)    { { tracking_id: tracking_id } }

    context 'when set as a string in the options hash' do

      let(:tracking_id) { 'UA-123456789-7' }

      it 'should just return that string that was passed in' do
        expect(subject.send(:tracking_id)).to eq(tracking_id)
      end

    end

    context 'when set as a lamda in the options hash' do

      let(:tracking_id) { ->(env) { 'UA-987654321-7' } }

      it 'should call our lambda for the result' do
        expect(subject.send(:tracking_id)).to eq(tracking_id.call(nil))
      end

      context 'the environment passed into the lambda' do

        let(:env)        { { this: :that } }
        let(:tracking_id) { ->(env) { env[:this] } }

        it 'for use in the evaluation' do
          subject.instance_variable_set('@env', env)
          expect(subject.send(:tracking_id)).to eq(:that)
        end

      end

    end
  end

end
