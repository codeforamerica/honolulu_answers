FactoryGirl.define do
  factory :article do
    title         "How do I get a Hawai'i driver license for the first time?"
    content       "This content field currently contains all the information required to satisfactorily cover the topic given by the title"
    category      "Driver License"
    preview       "Go to a driver license station with your proof of legal presence, take a written exam there as well as eye test, photograph, and fingerprints, pay fees, and schedule a road test appointment."
    tags          "driver license, drivers license, driver's license, driving license, license, driving, drive, driving test, written test, written exam, driving exam, road test, road exam, new driver license, new driver's license, new driving license"
    contact       
  end

  factory :contact do
  end
end

