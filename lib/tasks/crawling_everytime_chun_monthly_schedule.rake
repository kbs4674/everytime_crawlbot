## rake "crawling_everytime_chun_monthly_schedule:crawling_everytime_chun_monthly_schedule"

namespace :crawling_everytime_chun_monthly_schedule do
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
  
  task crawling_everytime_chun_monthly_schedule: :environment do

    #크롤링(nokogiri) : 강원대학교 학사일정
    doc = Nokogiri::HTML(open("http://www.kangwon.ac.kr/www/index.do"))
    @univ_array_title = Array.new;
    @univ_array_time = Array.new;
    @univ = doc.css("#container > section.layer.layer3 > div > section.schedule > ul > li > a")
    @univ.each do |x|
      tit = x.css("span.text").text
      time = x.css("span.date").text
      @univ_array_title.push(tit)
      @univ_array_time.push(time)
    end
    
    @merge_univ_schedule = @univ_array_title.zip(@univ_array_time)

    ### 춘천캠 자유게시판
    everytime_board_list = agent.post("/find/board/article/list", {
      id: "380617" # 게시글 ID값
    })
    everytime_xml_id = everytime_board_list.xml.search('//response//article').map{|node| node['id']}
    everytime_xml_title = everytime_board_list.xml.search('//response//article').map{|node| node['title']}
    everytime_xml_content = everytime_board_list.xml.search('//response//article').map{|node| node['text']}
    
    #### 게시물 수집 및 DB저장 과정 생략 ####
    
    ## 학사일정
    CrawlingEverytime.all.where("title like ? AND title like ?", "%학사일정%", "%알려줘%").or(CrawlingEverytime.all.where("content like ? AND content like ?", "%학사일정%", "%알려줘%")).each do |x|
      if (x.comment_id == nil && x.comment_content == nil)
        everytime_board_write = agent.post("/save/board/comment", {
          id: "#{x.article_id}",
          text: "#{Time.zone.now.strftime('%m월')} 학사일정 : #{@merge_univ_schedule.each { |t| t } } :: 감자 요정냥이 BOT",
          is_anonym: "0" # 0: 닉네임 공개 , 1: 익명
        })
        
        everytime_board_show = agent.post("https://everytime.kr/find/board/comment/list", {
          id: "#{x.article_id}"
        })
        
        everytime_xml_comment_text = everytime_board_show.xml.search('//response//comment').map{|node| node['text']}.last
        everytime_xml_comment_id = everytime_board_show.xml.search('//response//comment').map{|node| node['id']}.last
        
        puts "'#{x.title.truncate(15, omission: '...')}(게시글 ID : #{x.article_id})' [이번 달 학사일정] 봇 활동중.. >_<"
        x.update(comment_id: everytime_xml_comment_id, comment_content: everytime_xml_comment_text)
        sleep 3; # 글 작성 시 Delay가 있어야함 (Delay가 없으면 Everytime 측에서 '반복적인 글 작성'을 사유로 글 작성이 잠깐 막힘.)
        
        everytime_board_write = agent.post("/save/board/comment", {
          id: "#{x.article_id}",
          text: "* BOT 호출 - 게시글 제목 혹은 내용에 '감자요정 명령어' 언급! :: 감자 요정냥이 BOT",
          is_anonym: "0" # 0: 닉네임 공개 , 1: 익명
        })
        sleep 3; # 글 작성 시 Delay가 있어야함 (Delay가 없으면 Everytime 측에서 '반복적인 글 작성'을 사유로 글 작성이 잠깐 막힘.)
      end
    end
    
  end
end