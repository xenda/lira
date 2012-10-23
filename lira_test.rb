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
    :content => '<!DOCTYPE html><html><body><h2>Test Newsletter</h2><p>Este es un mensaje de prueba</p></body></html>'
  }
})

deliver_status = lira.deliver_message({
  :mailing_list_id => mailing_list["DATASET"]["DATA"][0],
  :message_id => message["DATASET"]["DATA"]
})

# message = lira.create_message({
#   :subject => "Mensaje de Prueba",
#   :mailing_list_id => "418",
#   :from => {
#     :email => 'mailing@se.pe',
#     :name => 'Semana Economica'
#   },
#   :message => {
#     :format => 'html',
#     :content => '<!DOCTYPE html><html><body><h2>Test Newsletter</h2><p>Este es un mensaje de prueba</p></body></html>'
#   }
# })