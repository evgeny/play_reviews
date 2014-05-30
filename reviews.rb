#!/usr/bin/env ruby
# encoding: utf-8
require 'typhoeus'
require 'nokogiri'

request = Typhoeus::Request.new(
  "https://play.google.com/store/getreviews",
  method: :post,
  params: { id: "com.allesklar.meinestadt", pageNum: "1", reviewSortOrder: "0", reviewType: "0", xhr: "1" },
  headers: { Accept: "gzip,deflate,sdch"}
)
request.on_complete do |response|
  s = response.body[17..-7]    
  s = s.gsub(/\\u003c/, "<").gsub(/\\u003d/, "=").gsub(/\\u003e/, ">").gsub(/\\\"/,"\"")

  doc = Nokogiri::HTML(s)

  reviews = []
  doc.css('.single-review').map do | method_span |            
    reviews << {            
      style: method_span.at_css(".current-rating")['style'],
      avatar: method_span.at_css(".author-image")['src'],
      name: method_span.at_css(".review-title").text.strip, 
      body: method_span.at_css(".review-body").first_element_child.next.text.strip 
    }
  end  
  
  send_event('reviews', { reviews: reviews })
end

request.run

#curl -X POST -H Content-length:0 "https://play.google.com/store/getreviews?id=com.allesklar.meinestadt&pageNum=1&reviewSortOrder=2&reviewType=0&xhr=1"
#curl -X POST -H Content-length:0 -H Content-type:"application/x-www-form-urlencoded;charset=UTF-8" "https://play.google.com/store/getreviews?id=com.allesklar.meinestadt&pageNum=0&reviewSortOrder=0&reviewType=0&version=38&xhr=1"