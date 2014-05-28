class HomeController < ApplicationController
  include RailsNlp
  require 'rufus-scheduler'
  require 'json'
  caches_page :index

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
        #puts "no messages"
      else

        my_message = response_status['status']
        receiver = my_message[0]["sender_num"]
        receiver["+92"] = "0"
        sent_response = smile_manager.send_sms(receiver,sender,message)

      end
    end


  end

  def about
  end




end

class Smile_Api

  require 'uri'
  require 'rubygems'
  require 'curb'
  def get_session
    user_name = "5"
    password = "reHnuma532"
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

