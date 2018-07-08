require 'pry'
require 'csv'

def css
  width_in_inches = 3.70
  height_in_inches = 5
  dpi = 300

  "
  body {
    display: flex;
    flex-wrap: wrap;
  }

  .individual {
    width: #{width_in_inches * dpi};
    height: #{height_in_inches * dpi};
  }

  .empty_top_half {
    height: #{height_in_inches * dpi / 2};
    border: 1px solid black;
  }

  .bottom_half {
    width: 100%;
    height: #{height_in_inches * dpi / 2};
    position: relative;
    border: 1px solid black;
  }

  .bottom_content {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    width: 100%;
  }

  .table_number {
    font-family: SF Pro Display;
    margin-bottom: 25px;
    text-align: center;
    font-size: 30px;
    letter-spacing: 4px;
  }

  .guest_name {
    font-family: Sweet Pea;
    font-size: 120px;
    text-align: center;
  }
  "
end

def individual_html(name, table)
  table = "Table #{table}" unless table == "Headtable"

  "
    <div class ='individual'>
      <div class='empty_top_half'></div>
      <div class='bottom_half'>
        <div class='bottom_content'>
          <div class='table_number'>#{table}</div>
          <div class='guest_name'>#{name}</div>
          <div class='flower'>
            <img src=""/>
          </div>
        </div>
      </div>
    </div>
  "
end

def create_card_sheets(guests, sheet)
  puts sheet

  code = "<style> #{css} </style>"
  code += "<body>"
  guests.each do |name, table|
    code += individual_html(name, table)
  end
  code += "</body>"
  write_code_to_file("cards_#{sheet}.html", code)
end

def write_code_to_file(filename, code)
  open(filename, 'w') { |f|
    f.puts code
  }
end

sheet_count = 0
guest_counter = -1
guests = []

CSV.foreach("guestlist.csv") do |row|
  guest_counter += 1
  name, table = row

  guest = [name, table]

  if guest_counter % 4 == 0
    if guests.any?
      sheet_count += 1
      create_card_sheets(guests, sheet_count)
      guests = []
    end
  end
  guests << guest

end

sheet_count += 1
create_card_sheets(guests, sheet_count)



