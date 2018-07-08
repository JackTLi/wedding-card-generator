require 'pry'
require 'benchmark'
require 'csv'

def css
  width_in_inches = 3.70
  height_in_inches = 5
  dpi = 300

  "
  body {
    background-color: white;
    color: #454f5b;
  }

  .individual {
    display: inline-block;
    width: #{width_in_inches * dpi};
    height: #{height_in_inches * dpi};
  }

  .empty_top_half {
    height: #{height_in_inches * dpi / 2};
    border: 1px solid #eee;
  }

  .bottom_half {
    width: 100%;
    height: #{height_in_inches * dpi / 2};
    position: relative;
    border: 1px solid #eee;
  }

  .bottom_content {
    position: absolute;
    top: 25%;
    width: 100%;
  }

  .table_number {
    font-family: SF Pro Display;
    text-align: center;
    font-size: 40px;
    letter-spacing: 8px;
  }

  .guest_name {
    font-family: Sweet Pea;
    font-size: 110px;
    text-align: center;
    margin-top: 45px;
    margin-bottom: 45px;
  }

  .flower {
  }

  .flower img {
    width: 300px;
    margin: auto;
    display: block;
  }
  "
end

def individual_html(name, table)
  table = "Table #{table}" unless table == "Headtable"
  table.upcase!
  "
    <div class ='individual'>
      <div class='empty_top_half'></div>
      <div class='bottom_half'>
        <div class='bottom_content'>
          <div class='table_number'>#{table}</div>
          <div class='guest_name'>#{name}</div>
          <div class='flower'>
            <img src='flower.svg'/>
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

  file_name = "cards_#{sheet}"
  write_code_to_file("#{file_name}.html", code)
  screenshot(`phantomjs screengrab.js #{file_name}.html pngs/#{file_name}.png`, "pngs/#{file_name}.png")
end

def write_code_to_file(filename, code)
  open(filename, 'w') { |f|
    f.puts code
  }
end

def screenshot(command, png_path)
  puts "Benchmark: #{png_path}"
  Benchmark.bm do |x|
    x.report { command } unless ARGV[1] == "skip"
  end
  puts "Done phantomjs for #{png_path}"
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



