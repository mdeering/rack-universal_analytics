# # Encoding: utf-8
# rubocop:disable all
# require 'spec_helper'
#
# require 'benchmark'
# require 'nokogiri'
#
# describe 'nokogiri matching' do
#
#   context 'with a small html document' do
#
#     let!(:response) do
#       VCR.use_cassette('hello') do
#         Net::HTTP.get_response(URI('http://www.december.com/html/tutor/hello.html'))
#       end
#     end
#
#     it 'should parse it really fast' do
#       # puts response.body
#       expect(
#         Benchmark.realtime do
#           1000.times do
#             doc = Nokogiri::HTML(response.body)
#             doc.at_xpath('//html/head').add_child('<script type="text/javascript">alert("mdeering was here");</script>')
#           end
#         end
#       ).to be < 0.05
#       # puts response.body
#     end
#
#   end
#
#   context 'with a large html document' do
#
#     let!(:response) do
#       VCR.use_cassette('etfdb') do
#         Net::HTTP.get_response(URI('http://etfdb.com/screener/'))
#       end
#     end
#
#     it 'should parse it really fast' do
#       # puts response.body
#       expect(
#         Benchmark.realtime do
#           1000.times do
#             doc = Nokogiri::HTML(response.body)
#             doc.at_xpath('//html/head').add_child('<script type="text/javascript">alert("mdeering was here");</script>')
#           end
#         end
#       ).to be < 0.5
#       # puts response.body
#     end
#
#   end
#
# end
