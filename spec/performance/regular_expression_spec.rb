# # Encoding: utf-8
# require 'spec_helper'
# require 'benchmark'
#
# describe 'regular exprssion matching' do
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
#             response.body.gsub(/<\/head>/i, 'SCRIPT_GOES_HERE</head>')
#           end
#         end
#       ).to be < 0.1
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
#             response.body.gsub(/<\/head>/i, 'SCRIPT_GOES_HERE</head>')
#           end
#         end
#       ).to be < 5
#       # puts response.body
#     end
#
#   end
#
#   context 'with a small html document and a RegExp' do
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
#             response.body.gsub!(/<\/head>/i, 'SCRIPT_GOES_HERE</head>')
#           end
#         end
#       ).to be < 0.15
#       # puts response.body
#     end
#
#   end
#
#   context 'with a large html document and a RegExp' do
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
#             response.body.gsub!(/<\/head>/i, 'SCRIPT_GOES_HERE</head>')
#           end
#         end
#       ).to be < 5
#       # puts response.body
#     end
#
#   end
#
# end
