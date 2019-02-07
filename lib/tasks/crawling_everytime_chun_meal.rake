## rake "crawling_everytime_chun_meal:crawling_everytime_chun_meal"

namespace :crawling_everytime_chun_meal do
  require 'nokogiri'
  require 'open-uri'
  require 'mechanize'
  
  # 로그인 처리
  agent = Mechanize.new
  page = agent.get("https://kangwon.everytime.kr/login?redirect=/380617")
  login = page.form_with(:action => "/user/login")
  login.field_with(:name => "userid").value= "#{ENV["EVERYTIME_ID"]}"
  login.field_with(:name => "password").value= "#{ENV["EVERYTIME_PASSWORD"]}"
  login_result = agent.submit login
  
  task crawling_everytime_chun_meal: :environment do
    
  # 백록관 학식
  doc = Nokogiri::HTML(open("http://knucoop.kangwon.ac.kr/weekly_menu_02.asp"))
  @back_meal_analyst = doc.css('table > tbody')
  @back_meal_analyst.each do |x|
    # 월요일 식단
    if Time.zone.now.strftime("%A") == "Monday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i < 14 )
        back_meal = doc.css('tr:nth-child(5) > td:nth-child(2)').text.strip
        @back_meal_time = "점심"
      else
        back_meal = doc.css('tr:nth-child(7) > td:nth-child(3)').text.strip
        @back_meal_time = "저녁"
      end
    end
  
    # 화요일 식단
    if Time.zone.now.strftime("%A") == "Tuesday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i < 14 )
        back_meal = doc.css('tr:nth-child(5) > td:nth-child(3)').text.strip
        @back_meal_time = "점심"
      else
        back_meal = doc.css('tr:nth-child(7) > td:nth-child(4)').text.strip
        @back_meal_time = "저녁"
      end
    end
    
    # 수요일 식단
    if Time.zone.now.strftime("%A") == "Wednesday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i < 14 )
        back_meal = doc.css('tr:nth-child(5) > td:nth-child(4)').text.strip
        @back_meal_time = "점심"
      else
        back_meal = doc.css('tr:nth-child(7) > td:nth-child(5)').text.strip
        @back_meal_time = "저녁"
      end
    end
    
    # 목요일 식단
    if Time.zone.now.strftime("%A") == "Thursday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i < 14 )
        back_meal = doc.css('tr:nth-child(5) > td:nth-child(5)').text.strip
        @back_meal_time = "점심"
      else
        back_meal = doc.css('tr:nth-child(7) > td:nth-child(6)').text.strip
        @back_meal_time = "저녁"
      end
    end
    
    # 금요일 식단
    if Time.zone.now.strftime("%A") == "Friday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i < 14 )
        back_meal = doc.css('tr:nth-child(5) > td:nth-child(6)').text.strip
        @back_meal_time = "점심"
      else
        back_meal = doc.css('tr:nth-child(7) > td:nth-child(7)').text.strip
        @back_meal_time = "저녁"
      end
    end
    
    # 토요일 식단
    if Time.zone.now.strftime("%A") == "Saturday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i < 14 )
        back_meal = doc.css('tr:nth-child(5) > td:nth-child(7)').text.strip
        @back_meal_time = "점심"
      else
        back_meal = doc.css('tr:nth-child(7) > td:nth-child(8)').text.strip
        @back_meal_time = "저녁"
      end
    end
    
    # 일요일 식단
    if Time.zone.now.strftime("%A") == "Sunday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i < 14 )
        back_meal = doc.css('tr:nth-child(5) > td:nth-child(8)').text.strip
        @back_meal_time = "점심"
      else
        back_meal = doc.css('tr:nth-child(7) > td:nth-child(9)').text.strip
        @back_meal_time = "저녁"
      end
    end
  
    @today_back_meal = back_meal
  end
  
  # 천지관 학식
  doc2 = Nokogiri::HTML(open("http://knucoop.kangwon.ac.kr/weekly_menu_01.asp"))
  @chun_meal_analyst = doc2.css('table > tbody')
  @chun_meal_analyst.each do |x|
    # 월요일 식단
    if Time.zone.now.strftime("%A") == "Monday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i <= 8 )
        chun_meal = doc2.css('tr:nth-child(2) > td:nth-child(3)').text.strip
        @chun_meal_time = "아침"
      elsif (Time.zone.now.strftime("%H").to_i >= 9 && Time.zone.now.strftime("%H").to_i < 14 )
        chun_meal = doc2.css('tr:nth-child(5) > td:nth-child(2)').text.strip
        @chun_meal_time = "점심"
      else
        chun_meal = doc2.css('tr:nth-child(8) > td:nth-child(2)').text.strip
        @chun_meal_time = "저녁"
      end
    end
    
    # 화요일 식단
    if Time.zone.now.strftime("%A") == "Tuesday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i <= 8 )
        chun_meal = doc2.css('tr:nth-child(2) > td:nth-child(4)').text.strip
        @chun_meal_time = "아침"
      elsif (Time.zone.now.strftime("%H").to_i >= 9 && Time.zone.now.strftime("%H").to_i < 14 )
        chun_meal = doc2.css('tr:nth-child(5) > td:nth-child(3)').text.strip
        @chun_meal_time = "점심"
      else
        chun_meal = doc2.css('tr:nth-child(8) > td:nth-child(3)').text.strip
        @chun_meal_time = "저녁"
      end
    end
    
    # 수요일 식단
    if Time.zone.now.strftime("%A") == "Wednesday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i <= 8 )
        chun_meal = doc2.css('tr:nth-child(2) > td:nth-child(5)').text.strip
        @chun_meal_time = "아침"
      elsif (Time.zone.now.strftime("%H").to_i >= 9 && Time.zone.now.strftime("%H").to_i < 14 )
        chun_meal = doc2.css('tr:nth-child(5) > td:nth-child(4)').text.strip
        @chun_meal_time = "점심"
      else
        chun_meal = doc2.css('tr:nth-child(8) > td:nth-child(4)').text.strip
        @chun_meal_time = "저녁"
      end
    end
    
    # 목요일 식단
    if Time.zone.now.strftime("%A") == "Thursday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i <= 8 )
        chun_meal = doc2.css('tr:nth-child(2) > td:nth-child(6)').text.strip
        @chun_meal_time = "아침"
      elsif (Time.zone.now.strftime("%H").to_i >= 9 && Time.zone.now.strftime("%H").to_i < 14 )
        chun_meal = doc2.css('tr:nth-child(5) > td:nth-child(5)').text.strip
        @chun_meal_time = "점심"
      else
        chun_meal = doc2.css('tr:nth-child(8) > td:nth-child(5)').text.strip
        @chun_meal_time = "저녁"
      end
    end
    
    # 금요일 식단
    if Time.zone.now.strftime("%A") == "Friday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i <= 8 )
        chun_meal = doc2.css('tr:nth-child(2) > td:nth-child(7)').text.strip
        @chun_meal_time = "아침"
      elsif (Time.zone.now.strftime("%H").to_i >= 9 && Time.zone.now.strftime("%H").to_i < 14 )
        chun_meal = doc2.css('tr:nth-child(5) > td:nth-child(6)').text.strip
        @chun_meal_time = "점심"
      else
        chun_meal = doc2.css('tr:nth-child(8) > td:nth-child(6)').text.strip
        @chun_meal_time = "저녁"
      end
    end
    
    # 토요일 식단
    if Time.zone.now.strftime("%A") == "Saturday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i <= 8 )
        chun_meal = doc2.css('tr:nth-child(2) > td:nth-child(8)').text.strip
        @chun_meal_time = "아침"
      elsif (Time.zone.now.strftime("%H").to_i >= 9 && Time.zone.now.strftime("%H").to_i < 14 )
        chun_meal = doc2.css('tr:nth-child(5) > td:nth-child(7)').text.strip
        @chun_meal_time = "저녁"
      else
        chun_meal = doc2.css('tr:nth-child(8) > td:nth-child(7)').text.strip
        @chun_meal_time = "점심"
      end
    end
    
    @today_chun_meal = chun_meal
  end
  
  # 재정 생활관 식단
  doc3 = Nokogiri::HTML(open("http://knudorm.kangwon.ac.kr/home/sub02/sub02_05_bj.jsp"))
  @dormitory_analyst = doc3.css('#foodtab1 > #foodtab1_building1 > table.table_type01')
  @dormitory_analyst.each do |x|
    # 월요일 식단
    if Time.zone.now.strftime("%A") == "Monday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i <= 8 )
        dormitory_meal_normal = doc3.css('#foodtab1 > #foodtab1_building1 > table.table_type01 > tr:nth-child(2) > td:nth-child(2)').text.strip
        @dormitory_meal_time = "아침"
      elsif (Time.zone.now.strftime("%H").to_i >= 9 && Time.zone.now.strftime("%H").to_i < 14 )
        dormitory_meal_normal = doc3.css('#foodtab1 > #foodtab1_building1 > table.table_type01 > tr:nth-child(2) > td:nth-child(3)').text.strip
        @dormitory_meal_time = "점심"
      else
        dormitory_meal_normal = doc3.css('#foodtab1 > #foodtab1_building1 > table.table_type01 > tr:nth-child(2) > td:nth-child(4)').text.strip
        @dormitory_meal_time = "저녁"
      end
    end
    
    # 화요일 식단
    if Time.zone.now.strftime("%A") == "Tuesday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i <= 8 )
        dormitory_meal_normal = doc3.css('#foodtab1 > #foodtab1_building1 > table.table_type01 > tr:nth-child(3) > td:nth-child(2)').text.strip
        @dormitory_meal_time = "아침"
      elsif (Time.zone.now.strftime("%H").to_i >= 9 && Time.zone.now.strftime("%H").to_i < 14 )
        dormitory_meal_normal = doc3.css('#foodtab1 > #foodtab1_building1 > table.table_type01 > tr:nth-child(3) > td:nth-child(3)').text.strip
        @dormitory_meal_time = "점심"
      else
        dormitory_meal_normal = doc3.css('#foodtab1 > #foodtab1_building1 > table.table_type01 > tr:nth-child(3) > td:nth-child(4)').text.strip
        @dormitory_meal_time = "저녁"
      end
    end
    
    # 수요일 식단
    if Time.zone.now.strftime("%A") == "Wednesday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i <= 8 )
        dormitory_meal_normal = doc3.css('#foodtab1 > #foodtab1_building1 > table.table_type01 > tr:nth-child(4) > td:nth-child(2)').text.strip
        @dormitory_meal_time = "아침"
      elsif (Time.zone.now.strftime("%H").to_i >= 9 && Time.zone.now.strftime("%H").to_i < 14 )
        dormitory_meal_normal = doc3.css('#foodtab1 > #foodtab1_building1 > table.table_type01 > tr:nth-child(4) > td:nth-child(3)').text.strip
        @dormitory_meal_time = "점심"
      else
        dormitory_meal_normal = doc3.css('#foodtab1 > #foodtab1_building1 > table.table_type01 > tr:nth-child(4) > td:nth-child(4)').text.strip
        @dormitory_meal_time = "저녁"
      end
    end
    
    # 목요일 식단
    if Time.zone.now.strftime("%A") == "Thursday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i <= 8 )
        dormitory_meal_normal = doc3.css('#foodtab1 > #foodtab1_building1 > table.table_type01 > tr:nth-child(5) > td:nth-child(2)').text.strip
        @dormitory_meal_time = "아침"
      elsif (Time.zone.now.strftime("%H").to_i >= 9 && Time.zone.now.strftime("%H").to_i < 14 )
        dormitory_meal_normal = doc3.css('#foodtab1 > #foodtab1_building1 > table.table_type01 > tr:nth-child(5) > td:nth-child(3)').text.strip
        @dormitory_meal_time = "점심"
      else
        dormitory_meal_normal = doc3.css('#foodtab1 > #foodtab1_building1 > table.table_type01 > tr:nth-child(5) > td:nth-child(4)').text.strip
        @dormitory_meal_time = "저녁"
      end
    end
    
    # 금요일 식단
    if Time.zone.now.strftime("%A") == "Friday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i <= 8 )
        dormitory_meal_normal = doc3.css('#foodtab1 > #foodtab1_building1 > table.table_type01 > tr:nth-child(6) > td:nth-child(2)').text.strip
        @dormitory_meal_time = "아침"
      elsif (Time.zone.now.strftime("%H").to_i >= 9 && Time.zone.now.strftime("%H").to_i <= 14 )
        dormitory_meal_normal = doc3.css('#foodtab1 > #foodtab1_building1 > table.table_type01 > tr:nth-child(6) > td:nth-child(3)').text.strip
        @dormitory_meal_time = "점심"
      else
        dormitory_meal_normal = doc3.css('#foodtab1 > #foodtab1_building1 > table.table_type01 > tr:nth-child(6) > td:nth-child(4)').text.strip
        @dormitory_meal_time = "저녁"
      end
    end
    
    # 토요일 식단
    if Time.zone.now.strftime("%A") == "Saturday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i <= 8 )
        dormitory_meal_normal = doc3.css('#foodtab1 > #foodtab1_building1 > table.table_type01 > tr:nth-child(7) > td:nth-child(2)').text.strip
        @dormitory_meal_time = "아침"
      elsif (Time.zone.now.strftime("%H").to_i >= 9 && Time.zone.now.strftime("%H").to_i < 14 )
        dormitory_meal_normal = doc3.css('#foodtab1 > #foodtab1_building1 > table.table_type01 > tr:nth-child(7) > td:nth-child(3)').text.strip
        @dormitory_meal_time = "점심"
      else
        dormitory_meal_normal = doc3.css('#foodtab1 > #foodtab1_building1 > table.table_type01 > tr:nth-child(7) > td:nth-child(4)').text.strip
        @dormitory_meal_time = "저녁"
      end
    end
    
    # 일요일 식단
    if Time.zone.now.strftime("%A") == "Sunday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i <= 8 )
        dormitory_meal_normal = doc3.css('#foodtab1 > #foodtab1_building1 > table.table_type01 > tr:nth-child(8) > td:nth-child(2)').text.strip
        @dormitory_meal_time = "아침"
      elsif (Time.zone.now.strftime("%H").to_i >= 9 && Time.zone.now.strftime("%H").to_i < 14 )
        dormitory_meal_normal = doc3.css('#foodtab1 > #foodtab1_building1 > table.table_type01 > tr:nth-child(8) > td:nth-child(3)').text.strip
        @dormitory_meal_time = "점심"
      else
        dormitory_meal_normal = doc3.css('#foodtab1 > #foodtab1_building1 > table.table_type01 > tr:nth-child(8) > td:nth-child(4)').text.strip
        @dormitory_meal_time = "저녁"
      end
    end
    
    @dormitory_meal_result = dormitory_meal_normal
  end
  
  # BTL 생활관 식단
  @BTL_analyst = doc3.css('#foodtab2 > table.table_type01')
  @BTL_analyst.each do |x|
    # 월요일 식단
    if Time.zone.now.strftime("%A") == "Monday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i <= 8 )
        dormitory_meal_BTL = doc3.css('#foodtab2 > table.table_type01 > tr:nth-child(2) > td:nth-child(2)').text.strip
        @BTL_meal_time = "아침"
      elsif (Time.zone.now.strftime("%H").to_i >= 9 && Time.zone.now.strftime("%H").to_i < 14 )
        dormitory_meal_BTL = doc3.css('#foodtab2 > table.table_type01 > tr:nth-child(2) > td:nth-child(3)').text.strip
        @BTL_meal_time = "점심"
      else
        dormitory_meal_BTL = doc3.css('#foodtab2 > table.table_type01 > tr:nth-child(2) > td:nth-child(4)').text.strip
        @BTL_meal_time = "저녁"
      end
    end
    
    # 화요일 식단
    if Time.zone.now.strftime("%A") == "Tuesday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i <= 8 )
        dormitory_meal_BTL = doc3.css('#foodtab2 > table.table_type01 > tr:nth-child(3) > td:nth-child(2)').text.strip
        @BTL_meal_time = "아침"
      elsif (Time.zone.now.strftime("%H").to_i >= 9 && Time.zone.now.strftime("%H").to_i < 14 )
        dormitory_meal_BTL = doc3.css('#foodtab2 > table.table_type01 > tr:nth-child(3) > td:nth-child(3)').text.strip
        @BTL_meal_time = "점심"
      else
        dormitory_meal_BTL = doc3.css('#foodtab2 > table.table_type01 > tr:nth-child(3) > td:nth-child(4)').text.strip
        @BTL_meal_time = "저녁"
      end
    end
    
    # 수요일 식단
    if Time.zone.now.strftime("%A") == "Wednesday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i <= 8 )
        dormitory_meal_BTL = doc3.css('#foodtab2 > table.table_type01 > tr:nth-child(4) > td:nth-child(2)').text.strip
        @BTL_meal_time = "아침"
      elsif (Time.zone.now.strftime("%H").to_i >= 9 && Time.zone.now.strftime("%H").to_i < 14 )
        dormitory_meal_BTL = doc3.css('#foodtab2 > table.table_type01 > tr:nth-child(4) > td:nth-child(3)').text.strip
        @BTL_meal_time = "점심"
      else
        dormitory_meal_BTL = doc3.css('#foodtab2 > table.table_type01 > tr:nth-child(4) > td:nth-child(4)').text.strip
        @BTL_meal_time = "저녁"
      end
    end
    
    # 목요일 식단
    if Time.zone.now.strftime("%A") == "Thursday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i <= 8 )
        dormitory_meal_BTL = doc3.css('#foodtab2 > table.table_type01 > tr:nth-child(5) > td:nth-child(2)').text.strip
        @BTL_meal_time = "아침"
      elsif (Time.zone.now.strftime("%H").to_i >= 9 && Time.zone.now.strftime("%H").to_i < 14 )
        dormitory_meal_BTL = doc3.css('#foodtab2 > table.table_type01 > tr:nth-child(5) > td:nth-child(3)').text.strip
        @BTL_meal_time = "점심"
      else
        dormitory_meal_BTL = doc3.css('#foodtab2 > table.table_type01 > tr:nth-child(5) > td:nth-child(4)').text.strip
        @BTL_meal_time = "저녁"
      end
    end
    
    # 금요일 식단
    if Time.zone.now.strftime("%A") == "Friday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i <= 8 )
        dormitory_meal_BTL = doc3.css('#foodtab2 > table.table_type01 > tr:nth-child(6) > td:nth-child(2)').text.strip
        @BTL_meal_time = "아침"
      elsif (Time.zone.now.strftime("%H").to_i >= 9 && Time.zone.now.strftime("%H").to_i < 14 )
        dormitory_meal_BTL = doc3.css('#foodtab2 > table.table_type01 > tr:nth-child(6) > td:nth-child(3)').text.strip
        @BTL_meal_time = "점심"
      else
        dormitory_meal_BTL = doc3.css('#foodtab2 > table.table_type01 > tr:nth-child(6) > td:nth-child(4)').text.strip
        @BTL_meal_time = "저녁"
      end
    end
    
    # 토요일 식단
    if Time.zone.now.strftime("%A") == "Saturday"
      if (Time.zone.now.strftime("%H").to_i >= 0 && Time.zone.now.strftime("%H").to_i <= 8 )
        dormitory_meal_BTL = doc3.css('#foodtab2 > table.table_type01 > tr:nth-child(7) > td:nth-child(2)').text.strip
        @BTL_meal_time = "아침"
      elsif (Time.zone.now.strftime("%H").to_i >= 9 && Time.zone.now.strftime("%H").to_i < 14 )
        dormitory_meal_BTL = doc3.css('#foodtab2 > table.table_type01 > tr:nth-child(7) > td:nth-child(3)').text.strip
        @BTL_meal_time = "점심"
      else
        dormitory_meal_BTL = doc3.css('#foodtab2 > table.table_type01 > tr:nth-child(7) > td:nth-child(4)').text.strip
        @BTL_meal_time = "저녁"
      end
    end
    
    # 일요일 식단
    if Time.zone.now.strftime("%A") == "Sunday"
      if (Time.zone.now.strftime("%H").to_i > 0 && Time.zone.now.strftime("%H").to_i <= 8 )
        dormitory_meal_BTL = doc3.css('#foodtab2 > table.table_type01 > tr:nth-child(8) > td:nth-child(2)').text.strip
        @BTL_meal_time = "아침"
      elsif (Time.zone.now.strftime("%H").to_i >= 9 && Time.zone.now.strftime("%H").to_i < 14 )
        dormitory_meal_BTL = doc3.css('#foodtab2 > table.table_type01 > tr:nth-child(8) > td:nth-child(3)').text.strip
        @BTL_meal_time = "점심"
      else
        dormitory_meal_BTL = doc3.css('#foodtab2 > table.table_type01 > tr:nth-child(8) > td:nth-child(4)').text.strip
        @BTL_meal_time = "저녁"
      end
    end
    
    @BTL_meal_result = dormitory_meal_BTL
  end

    ### 춘천캠 자유게시판
    everytime_board_list = agent.post("/find/board/article/list", {
      id: "380617" # 게시글 ID값
    })
    everytime_xml_id = everytime_board_list.xml.search('//response//article').map{|node| node['id']}
    everytime_xml_title = everytime_board_list.xml.search('//response//article').map{|node| node['title']}
    everytime_xml_content = everytime_board_list.xml.search('//response//article').map{|node| node['text']}
    
    #### 게시물 수집 및 DB저장 과정 생략 ####
    
    ## 백록관 학식메뉴
    CrawlingEverytime.all.where("title like ? AND title like ?", "%백록관%", "%메뉴%").each do |x|
      if (x.comment_id == nil && x.comment_content == nil)
        everytime_board_write = agent.post("/save/board/comment", {
          id: "#{x.article_id}",
          text: "#{Time.zone.now.strftime('%m월 %d일')} 백록관 백반메뉴(#{@back_meal_time}) : #{@today_back_meal} :: 감자 요정냥이 BOT [BOT 호출 - 게시글 제목 혹은 내용에 '감자요정 명령어' 언급!]",
          is_anonym: "0" # 0: 닉네임 공개 , 1: 익명
        })
        
        everytime_board_show = agent.post("https://everytime.kr/find/board/comment/list", {
          id: "#{x.article_id}"
        })
        
        everytime_xml_comment_text = everytime_board_show.xml.search('//response//comment').map{|node| node['text']}.last
        everytime_xml_comment_id = everytime_board_show.xml.search('//response//comment').map{|node| node['id']}.last
        
        puts "'#{x.title.truncate(15, omission: '...')}(게시글 ID : #{x.article_id})' [백록관 학식메뉴] 봇 활동중.. >_<"
        x.update(comment_id: everytime_xml_comment_id, comment_content: everytime_xml_comment_text)
        sleep 3; # 글 작성 시 Delay가 있어야함 (Delay가 없으면 Everytime 측에서 '반복적인 글 작성'을 사유로 글 작성이 잠깐 막힘.)
      end
    end
    
    ## 천지관 학식메뉴
    CrawlingEverytime.all.where("title like ? AND title like ?", "%천지관%", "%메뉴%").each do |x|
      if (x.comment_id == nil && x.comment_content == nil)
        everytime_board_write = agent.post("/save/board/comment", {
          id: "#{x.article_id}",
          text: "천지관 백반메뉴(#{Time.zone.now.strftime('%m월 %d일')} #{@chun_meal_time}) : #{@today_chun_meal} :: 감자 요정냥이 BOT [BOT 호출 - 게시글 제목 혹은 내용에 '감자요정 명령어' 언급!]",
          is_anonym: "0" # 0: 닉네임 공개 , 1: 익명
        })
        
        everytime_board_show = agent.post("https://everytime.kr/find/board/comment/list", {
          id: "#{x.article_id}"
        })
        
        everytime_xml_comment_text = everytime_board_show.xml.search('//response//comment').map{|node| node['text']}.last
        everytime_xml_comment_id = everytime_board_show.xml.search('//response//comment').map{|node| node['id']}.last
        
        puts "'#{x.title.truncate(15, omission: '...')}(게시글 ID : #{x.article_id})' [천지관 학식메뉴] 봇 활동중.. >_<"
        x.update(comment_id: everytime_xml_comment_id, comment_content: everytime_xml_comment_text)
        sleep 3; # 글 작성 시 Delay가 있어야함 (Delay가 없으면 Everytime 측에서 '반복적인 글 작성'을 사유로 글 작성이 잠깐 막힘.)
      end
    end
    
    ## 재정생활관 학식메뉴
    CrawlingEverytime.all.where("title like ? AND title like ?", "%기숙사%", "%메뉴%").or(CrawlingEverytime.all.where("title like ? AND title like ?", "%긱사%", "%메뉴%")).or(CrawlingEverytime.all.where("title like ? AND title like ?", "%재정생활관%", "%메뉴%")).each do |x|
      if (x.comment_id == nil && x.comment_content == nil)
        everytime_board_write = agent.post("/save/board/comment", {
          id: "#{x.article_id}",
          text: "재정생활관 메뉴(#{Time.zone.now.strftime('%m월 %d일')} #{@dormitory_meal_time}) : #{@dormitory_meal_result} :: 감자 요정냥이 BOT [BOT 호출 - 게시글 제목 혹은 내용에 '감자요정 명령어' 언급!]",
          is_anonym: "0" # 0: 닉네임 공개 , 1: 익명
        })
        
        everytime_board_show = agent.post("https://everytime.kr/find/board/comment/list", {
          id: "#{x.article_id}"
        })
        
        everytime_xml_comment_text = everytime_board_show.xml.search('//response//comment').map{|node| node['text']}.last
        everytime_xml_comment_id = everytime_board_show.xml.search('//response//comment').map{|node| node['id']}.last
        
        puts "'#{x.title.truncate(15, omission: '...')}(게시글 ID : #{x.article_id})' [재정생활관 학식메뉴] 봇 활동중.. >_<"
        x.update(comment_id: everytime_xml_comment_id, comment_content: everytime_xml_comment_text)
        sleep 3; # 글 작성 시 Delay가 있어야함 (Delay가 없으면 Everytime 측에서 '반복적인 글 작성'을 사유로 글 작성이 잠깐 막힘.)
      end
    end
    
    ## BTL 학식메뉴
    CrawlingEverytime.all.where("title like ? AND title like ?", "%BTL%", "%메뉴%").or(CrawlingEverytime.all.where("title like ? AND title like ?", "%비티엘%", "%메뉴%")).each do |x|
      if (x.comment_id == nil && x.comment_content == nil)
        everytime_board_write = agent.post("/save/board/comment", {
          id: "#{x.article_id}",
          text: "BTL 메뉴(#{Time.zone.now.strftime('%m월 %d일')} #{@BTL_meal_time}) : #{@BTL_meal_result} :: 감자 요정냥이 BOT [BOT 호출 - 게시글 제목 혹은 내용에 '감자요정 명령어' 언급!]",
          is_anonym: "0" # 0: 닉네임 공개 , 1: 익명
        })
        
        everytime_board_show = agent.post("https://everytime.kr/find/board/comment/list", {
          id: "#{x.article_id}"
        })
        
        everytime_xml_comment_text = everytime_board_show.xml.search('//response//comment').map{|node| node['text']}.last
        everytime_xml_comment_id = everytime_board_show.xml.search('//response//comment').map{|node| node['id']}.last
        
        puts "'#{x.title.truncate(15, omission: '...')}(게시글 ID : #{x.article_id})' [BTL 학식메뉴] 봇 활동중.. >_<"
        x.update(comment_id: everytime_xml_comment_id, comment_content: everytime_xml_comment_text)
        sleep 3; # 글 작성 시 Delay가 있어야함 (Delay가 없으면 Everytime 측에서 '반복적인 글 작성'을 사유로 글 작성이 잠깐 막힘.)
      end
    end
    
  end
end