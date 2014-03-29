class ApplicationController < ActionController::Base
  require 'nokogiri'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ApplicationHelper
  include SMSEasy
  # place me inside your base controller class
  ActionView::Base.field_error_proc = Proc.new do |html_tag, object|
    html = Nokogiri::HTML::DocumentFragment.parse(html_tag)
    html = html.at_css("input") || html.at_css("textarea")
    unless html.nil?
      css_class = html['class'] || "" 
      html['class'] = css_class.split.push("error").join(' ')
      html['data-error'] = object.error_message.join(". ")
      html_tag = html.to_s.html_safe
    end
    html_tag
  end
end
