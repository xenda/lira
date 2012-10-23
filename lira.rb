require 'builder'
require 'nori'
require 'cgi'
require 'httpclient'

class Lira
  URL = "https://www.elabs12.com/API/mailing_list.html"

  attr_accessor :password, :site_id, :http, :xml

  def initialize(site_id, password)
    self.site_id = site_id
    self.password = password
    self.http = HTTPClient.new

    self
  end

  def create_mailing_list(options)
    params = {}
    params[:type] = "list"
    params[:activity] = "add"

    self.xml = Builder::XmlMarkup.new(:indent => 0)

    input = self.xml.DATASET{ |ds|
      ds.SITE_ID(self.site_id)
      ds.DATA(self.password, {:type => "extra", :id => "password"})
      ds.DATA(options[:name], :type => "name")
    }.sub("\n","")

    params[:input] = input

    make_request_and_parse_response(params)
  end

  def add_members_to_mailing_list(id, options)
    params = {}
    params[:type] = "record"
    params[:activity] = "upload"

    self.xml = Builder::XmlMarkup.new(:indent => 0)

    input = self.xml.DATASET{ |ds|
      ds.SITE_ID(self.site_id)
      ds.MLID(id)
      ds.DATA(options[:email], {:type => "email"})
      ds.DATA(options[:file], {:id => "file", :type => "extra"})
      ds.DATA(options[:type] || "active", {:id => "type", :type => "extra"})
    }.sub("\n","")

    params[:input] = input

    make_request_and_parse_response(params)

  end

  def destroy_mailing_list(id)
    params = {}
    params[:type] = "list"
    params[:activity] = "delete"

    self.xml = Builder::XmlMarkup.new(:indent => 0)

    input = self.xml.DATASET{ |ds|
      ds.SITE_ID(self.site_id)
      ds.MLID(id)
      ds.DATA(self.password, {:type => "extra", :id => "password"})
    }.sub("\n","")

    params[:input] = input

    make_request_and_parse_response(params)
  end

  def query_lists
    params = {}
    params[:type] = "list"
    params[:activity] = "query-listdata"

    self.xml = Builder::XmlMarkup.new(:indent => 0)

    input = self.xml.DATASET{ |ds|
      ds.SITE_ID(self.site_id)
      ds.DATA(self.password, {:type => "extra", :id => "password"})
    }.sub("\n","")

    params[:input] = input
    
    make_request_and_parse_response(params)
  end

  def create_message(options)
    params = {}
    params[:type] = "message"
    params[:activity] = "add"

    self.xml = Builder::XmlMarkup.new(:indent => 0)

    content = options[:message][:content]

    input = self.xml.DATASET{ |ds|
      ds.SITE_ID(self.site_id)
      ds.MLID(options[:mailing_list_id])
      ds.DATA(self.password, {:type => "extra", :id => "password"})
      ds.DATA(options[:subject], {:type => "subject"})
      ds.DATA(options[:from][:email], {:type => "from-email"})
      ds.DATA(options[:from][:name], {:type => "from-name"})
      ds.DATA(options[:message][:format], {:type => "message-format"})
      ds.DATA(content, {:type => "message-#{options[:message][:format].downcase}"})
    }.sub("\n","")

    params[:input] = input
    
    make_request_and_parse_response(params)
  end

  def deliver_message(options)
    params = {}
    params[:type] = "message"
    params[:activity] = "schedule"

    self.xml = Builder::XmlMarkup.new(:indent => 0)

    input = self.xml.DATASET{ |ds|
      ds.SITE_ID(self.site_id)
      ds.MLID(options[:mailing_list_id])
      ds.DATA(self.password, {:type => "extra", :id => "password"})
      ds.MID(options[:message_id])
      if options[:segment_id]
        ds.MID(options[:segment_id], {:type => "rule"})
      end
      ds.DATA("schedule", {:type => "action"})
    }.sub("\n","")

    params[:input] = input
    
    make_request_and_parse_response(params)
  end

  protected

  def make_request_and_parse_response(params)
    response = self.make_request(:post, Lira::URL, params)

    parse_response(response.body)
  end

  def make_request(method, url, params)
    self.http.send(method.to_sym, url, params)
  end

  def parse_response(response_body)
    Nori.parse(response_body)
  end
end