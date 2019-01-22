require "open-uri"

class Scrapper
  attr_accessor :name, :email 

  @@mails_list = Hash.new

  def self .get_townhall_email(townhall_url)
    page = Nokogiri::HTML(open(townhall_url))
    page.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').each do |node|
      return node.text
    end
  end

  def self .get_townhall_urls
    page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
    page.xpath("//tr[2]//p/a").each do |node|
      name = node.text
      email = get_townhall_email("http://annuaire-des-mairies.com/"+node["href"])
      @@mails_list[name] = email 
    end
    return @@mails_list
  end

  def self .save_as_json
    File.open("database/email.json","w") do |f|
      f.write(JSON.pretty_generate(@@mails_list))
    end
  end

  def self .save_as_csv
    CSV.open("database/email.csv", "w") do |csv|
      @@mails_list.each do |row|
        csv << row
      end
    end
  end

  def self .save_as_spreadsheet
      session = GoogleDrive::Session.from_config("config.json")    
      ws = session.spreadsheet_by_key("1EiThfKrTbSA3Wo_1q8UreHmJasCXL7AN3c0KbTadSZA").worksheets[0]
      ws[1, 1] = "Ville"
      ws[1, 2] = "Email"
      ws.update_cells(2,1,@@mails_list.to_a)
      ws.save
    end
end

