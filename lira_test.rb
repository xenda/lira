require './lira'

lira = Lira.new("2012000193", "J2XsSTwt")

mailing_list = lira.create_mailing_list({
  :name => 'Testing List #2'
})

message = lira.create_message({
  :subject => "Testing Message",
  :mailing_list_id => mailing_list["DATASET"]["DATA"][0],
  :from => {
    :email => 'mailing@se.pe',
    :name => 'Semana Economica'
  },
  :message => {
    :format => 'html',
    :content => '<!DOCTYPE html><html><body><h2>Content</h2></body></html>'
  }
})