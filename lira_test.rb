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

deliveries_stats = lira.query_deliveries({
  :mailing_list_id => "433",
  :message_id => "15181"
})

member = lira.add_member_to_mailing_list(418, {
  :email => "srsanchez@xenda.pe",
  :attributes => {:'1' => "XendoBot", :'2' => "Sanchez"}
})

members = lira.upload_members_to_mailing_list(418, {
  :notificate_to => "gustavo@xenda.pe",
  :file => "https://raw.github.com/xenda/lira/master/new_members_418.csv"
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