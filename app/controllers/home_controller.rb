class HomeController < ApplicationController
  include RailsNlp
  require 'rufus-scheduler'
  require 'json'
  caches_page :index
  include RailsNlp


  def index
    @popular_categories = Category.by_access_count.limit(3)

    scheduler = Rufus::Scheduler.new

    scheduler.every '10s' do

      sender = "8333"
      receiver = "03328919976"
      message = "Kp Rehnuma--Comming Soon"
      smile_manager =  Smile_Api.new
      smile_response =  smile_manager.receive_sms()

      response_status=JSON.parse(smile_response)

      if(response_status['status'].blank? )
        puts "no messages"
      else

        my_message = response_status['status']
        receiver = my_message[0]["sender_num"]
        receiver["+92"] = "0"

        user_text =  my_message[0]["text"]

       # query = filter_long_or_empty(user_text)
        query = user_text

        @query_corrected = QueryExpansion.spell_check(query)

        query_expanded = QueryExpansion.expand(query)
        @query_expanded = query_expanded

        @results = Article.search(query_expanded).select(&:published?)

        @results.each do |article|

           #link_to article.title, article_path(article.id)

           message = article.preview
           sent_response = smile_manager.send_sms(receiver,sender,message)
        end



      end
    end


  end

  def about
  end

  private

  # Searchify can't handle requests longer than this (because of query
  # expansion + Tanker inefficencies.  >10 can result in >8000 byte request
  # strings)
  def filter_long_or_empty(user_text)
    if user_text.split.size > 10 || user_text.blank?
      @query = user_text
      @results = []
      render and return
    end
  end

end

class Smile_Api

  require 'uri'
  require 'rubygems'
  require 'curb'
  def get_session

    if not ((ENV['smile_user']) && (ENV['smile_password']))
      raise Exception.new "You must set ENV['Smile_User_Name'] = xxx, and ENV['Smile_Password'] = xxx, where xxx is your secret key for Smile_Api"
    else
      user_name = ENV['smile_user']
      password = ENV['smile_password']
      #require 'open-uri'
      require 'json'
      # Set the request URL
      url = "http://api.smilesn.com/session?username="+user_name+"&password="+password

      data = open_smile_uri(url)

      data=JSON.parse(data)


      sessionid= data['sessionid']

      file2 = File.open('session.txt', 'w')

      file1 = File.open('session.txt', 'a')
      file1.write(sessionid)
      file1.close

      return sessionid
    end

  end

  def open_smile_uri(url)
    begin
      curl = Curl::Easy.new(url)
      curl.perform

      data = ''
      data = curl.body_str

      return data
    rescue Exception => exception
      ErrorService.report(exception)

    end

  end

  def send_sms(receive_num, sender_num, text_message)

    receive_num=URI.escape(receive_num)
    sender_num=URI.escape(sender_num)
    text_message=URI.escape(text_message)
    session_file = File.open("session.txt")

    session_id = File.read("session.txt")
    if session_id.blank?

      session_id = self.get_session
    end

    url = "http://api.smilesn.com/sendsms?sid="+session_id+"&receivenum="+receive_num+"&sendernum=8333&textmessage="+text_message

    data = open_smile_uri(url)

    data2=JSON.parse(data)
    response_status=data2["status"]

#=====* START - IF SESSION EXPIRED IS RETURN, GENERATE ANOTHER SESSION & RETRY
    if(response_status=="SESSION_EXPIRED")

      session_id = self.get_session
      data = open_smile_uri(url)
      #data=File.read("http://api.smilesn.com/sendsms?sid="+session_id+"&receivenum="+receive_num+"&sendernum=8333&textmessage="+text_message)
    end

#=====* END - IF SESSION EXPIRED IS RETURN, GENERATE ANOTHER SESSION & RETRY

    return data
  end


  def receive_sms

    session_file = File.open("session.txt")
    session_id = File.read("session.txt")

    if session_id.blank?
      session_id = self.get_session
    end
    url = "http://api.smilesn.com/receivesms?sid="+session_id
    data = open_smile_uri(url)
    data2=JSON.parse(data)
    response_status=data2["status"]


#=====* START - IF SESSION EXPIRED IS RETURN, GENERATE ANOTHER SESSION & RETRY
    if(response_status=="SESSION_EXPIRED")
      session_id = self.get_session
      url = "http://api.smilesn.com/receivesms?sid="+session_id
      data = open_smile_uri(url)
    end
#=====* END - IF SESSION EXPIRED IS RETURN, GENERATE ANOTHER SESSION & RETRY


    return data
  end


end

