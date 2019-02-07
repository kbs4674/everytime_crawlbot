## rake "bot_example:bot_example"

namespace :bot_example do
  ## 크롤링/세션 로그인 구성 Package
  require 'nokogiri'
  require 'open-uri'
  require 'mechanize'
  
  ## 에브리타임 로그인 처리
  agent = Mechanize.new # 세션 생성
  page = agent.get("https://kangwon.everytime.kr/login?redirect=/380617") # 로그인 페이지 URL (GET 방식)
  login = page.form_with(:action => "/user/login") # 로그인 Action URL
  login.field_with(:name => "userid").value= "#{ENV["EVERYTIME_ID"]}" # 에브리타임 ID
  login.field_with(:name => "password").value= "#{ENV["EVERYTIME_PASSWORD"]}" # 에브리타임 암호
  login_result = agent.submit login # 에브리타임 로그인 실행
  
  task bot_example: :environment do
    
    ## 3일 전 내 서버 내에 저장해놨던(크롤링 해놨던) 게시글은 삭제
    CrawlingEverytime.where("created_at < ?", 3.days.ago).each do |x|
      x.destroy
    end

    ## [에브리타임 : 새내기 게시판] 글 목록 파싱
    everytime_board_list = agent.post("/find/board/article/list", {
      id: "385899" # 에브리타임 게시글 ID값
    })
    everytime_xml_content_id = everytime_board_list.xml.search('//response//article').map{|node| node['id']} # 크롤링 대상 (새내기 게시판 글 번호, XML)
    everytime_xml_content_text = everytime_board_list.xml.search('//response//article').map{|node| node['text']} # 크롤링 대상 (새내기 게시판 제목(= 내용), XML)
    
    ## 에브리타임에서 파싱된 게시글을 내 서버의 DB에 저장
    for i in 0..19
      CrawlingEverytime.create(title: everytime_xml_content_text[i], article_id: everytime_xml_content_id[i], category_id: "385899", category_name: "새내기 게시판")
    end
    
    ## 기숙사 제출 서류 관련 BOT 답변
    CrawlingEverytime.all.where("title like ? AND title like ?", "%기숙사%", "%서류%").or(CrawlingEverytime.all.where("title like ?", "%결핵%")).each do |x|
      if (x.comment_id == nil && x.comment_content == nil)
        everytime_board_write = agent.post("/save/board/comment", {
          id: "#{x.article_id}", # 에브리타임 게시글 아이디
          text: "기숙사 입사 약 1주일 전에 미리 보건소나 병원가서 '결핵검사'를 받고 '결핵검사진단서'를 받아놓으라옹! 해당 서류는 기숙사 거주생이라면 공통적으로 내야하는 서류댜, 냥! / 결핵진단 차(버스)가 오긴 오나, 무조건 오는건 아니니 존버만은 타지마럇! :: 감자 요정냥이 BOT", # 작성 될 댓글 내용
          is_anonym: "0" # 0: 닉네임 공개 , 1: 익명
        })
        
        # 에타 게시글 내 댓글 열람
        everytime_board_show = agent.post("https://everytime.kr/find/board/comment/list", {
          id: "#{x.article_id}" # 에브리타임 게시글 ID
        })
        
        everytime_xml_comment_id = everytime_board_show.xml.search('//response//comment').map{|node| node['id']}.last # 크롤링 대상 (게시글 내 내가 작성했던 댓글 ID 값, XML)
        everytime_xml_comment_text = everytime_board_show.xml.search('//response//comment').map{|node| node['text']}.last # 크롤링 대상 (게시글 내 내가 작성했던 댓글 내용, XML)
        
        puts "'#{x.title.truncate(15, omission: '...')}(게시글 ID : #{x.article_id})' [기숙사 제출 서류] 봇 활동중.. >_<" # Console에 보여지는 메세지
        x.update(comment_id: everytime_xml_comment_id, comment_content: everytime_xml_comment_text) # 내 DB의 Attribute 내용 업데이트(변경, 댓글 작성기록 추가)
        sleep 3; # 글 작성 시 Delay가 있어야함 (Delay가 없으면 Everytime 측에서 '반복적인 글 작성'을 사유로 글 작성이 잠깐 막힘.)
      end
    end
    
    # 크롤링(nokogiri) : 강원대학교 학사일정
    doc = Nokogiri::HTML(open("http://www.kangwon.ac.kr/www/index.do")) # 강원대 메인 페이지 접속
    @univ_array_title = Array.new; # [학사일정 : 제목]을 담을 배열
    @univ_array_time = Array.new; # [학사일정 : 기간]을 담을 배열
    @univ = doc.css("#container > section.layer.layer3 > div > section.schedule > ul > li > a") # 크롤링 대상 CSS
    @univ.each do |x|
      tit = x.css("span.text").text # 위 CSS 위치에 이어나가 [학사일정 : 제목] CSS 위치를 가리킨다. => 이어서 .text 메소드를 이용해서 <span> 과 같은 태그 제거
      time = x.css("span.date").text # 위 CSS 위치에 이어나가 [학사일정 : 기간] CSS 위치를 가리킨다. => 이어서 .text 메소드를 이용해서 <span> 과 같은 태그 제거
      @univ_array_title.push(tit) # 사전에 만들어놨던 배열에 [학사일정 : 제목] 을 Push 한다.
      @univ_array_time.push(time) # 사전에 만들어놨던 배열에 [학사일정 : 기간] 을 Push 한다.
    end
    
    @merge_univ_schedule = @univ_array_title.zip(@univ_array_time) ## 제목과 기간을 zip 함수를 이용해서 하나로(2차원 배열) 합친다.
    
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
        
        everytime_xml_comment_id = everytime_board_show.xml.search('//response//comment').map{|node| node['id']}.last
        everytime_xml_comment_text = everytime_board_show.xml.search('//response//comment').map{|node| node['text']}.last
        
        puts "'#{x.title.truncate(15, omission: '...')}(게시글 ID : #{x.article_id})' [이번 달 학사일정] 봇 활동중.. >_<"
        x.update(comment_id: everytime_xml_comment_id, comment_content: everytime_xml_comment_text)
        sleep 3; # 글 작성 시 Delay가 있어야함 (Delay가 없으면 Everytime 측에서 '반복적인 글 작성'을 사유로 글 작성이 잠깐 막힘.)
      end
    end
    
  end
end