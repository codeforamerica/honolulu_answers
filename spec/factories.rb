FactoryGirl.define do
  factory :article do
    title         "How do I get a Hawai'i driver license for the first time?"
    content       "<div class=\"quick_top\"><h2>Apply in person at a <a href=\"http://hnlanswers.herokuapp.com/articles/3/\">driver license station or Satellite City Hall</a>.</h2>\r\n<p>Requirements at the station:\r\n<ol>\r\n<li>Bring your <a target=\"_blank\" href=\"http://hawaii.gov/dot/hawaiis-legal-presence-law\" target=\"_blank\" >proof of legal presence.</a></li>\t\r\n<li>If you're between 15.5 and 17 years of age, bring <a target=\"_blank\" href=\"http://www1.honolulu.gov/csd/vehicle/dlrequirements.htm\">a parental consent form</a>.</li>\r\n<li>Take written knowledge exam.</li> \r\n<li>Take an eye test, and be fingerprinted and photographed.</li>\r\n<li><a target=\"_blank\" href=\"http://www1.honolulu.gov/csd/vehicle/dlrequirements.htm#feetable\">Pay fees</a> with cash, personal check, VISA, or MasterCard.</li>\r\n</ol></div>\r\n<div class=\"quick_bottom\"><h3>what you need to know</h3>\r\n<p>Study manuals for the written test are available <a target=\"_blank\" href=\"http://hawaii.gov/dot/highways/hwy-v/\">online</a> or at local bookstores and state libraries.</p>\r\n<p>You also need to complete a road test before you can receive your driver license. You can <a target=\"_blank\" href=\"http://www3.honolulu.gov/csdarts/default.aspx\">schedule your road test</a> online. If you already have a valid US driver license, the road test may be waived.</p></div>"
    category      "Driver License"
    preview       "Go to a driver license station with your proof of legal presence, take a written exam there as well as eye test, photograph, and fingerprints, pay fees, and schedule a road test appointment."
    tags          "driver license, drivers license, driver's license, driving license, license, driving, drive, driving test, written test, written exam, driving exam, road test, road exam, new driver license, new driver's license, new driving license"
    contact

    factory :article_no_tags do
      tags ""
    end     
    
  end

  factory :contact do
    # name
    # subname
    # number
    # url
    # address
    # department
    # description
  end
end

