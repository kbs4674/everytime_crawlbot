## rake "crawling_everytime_chun_info:crawling_everytime_chun_info"

namespace :crawling_everytime_chun_info do
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
  
  task crawling_everytime_chun_info: :environment do
    
    ### 춘천캠 자유게시판
    everytime_board_list = agent.post("/find/board/article/list", {
      id: "380617" # 게시글 ID값
    })
    everytime_xml_id = everytime_board_list.xml.search('//response//article').map{|node| node['id']}
    everytime_xml_title = everytime_board_list.xml.search('//response//article').map{|node| node['title']}
    everytime_xml_content = everytime_board_list.xml.search('//response//article').map{|node| node['text']}
    
    for i in 0..19
      CrawlingEverytime.create(title: everytime_xml_title[i], content: everytime_xml_content[i], article_id: everytime_xml_id[i], category_id: "380617", category_name: "춘천캠 자유게시판")
    end
    
    ## 감자요정 호출용어
    CrawlingEverytime.all.where("title like ? AND title like ?", "%감자요정%", "%명령어%").or(CrawlingEverytime.all.where("content like ? AND content like ?", "%감자요정%", "%명령어%")).or(CrawlingEverytime.all.where("title like ? AND title like ?", "%감자요정%", "%소환%")).or(CrawlingEverytime.all.where("content like ? AND content like ?", "%감자요정%", "%소환%")).each do |x|
      if (x.comment_id == nil && x.comment_content == nil)
        @text_content = ['무슨일이냥!', '앗냥~! ♡〜٩( ˃́▿˂̀ )۶〜♡ ', '앗냥~! ٩(º౪º๑)۶', '노라줄거냐옹!', '츄르먹기 좋은 날이다옹!'].sample
        everytime_board_write = agent.post("/save/board/comment", {
          id: "#{x.article_id}",
          text: "#{@text_content}",
          is_anonym: "0" # 0: 닉네임 공개 , 1: 익명
        })
        sleep 3; # 글 작성 시 Delay가 있어야함 (Delay가 없으면 Everytime 측에서 '반복적인 글 작성'을 사유로 글 작성이 잠깐 막힘.)
        
        everytime_board_write = agent.post("/save/board/comment", {
          id: "#{x.article_id}",
          text: "감자요정 누구 : 나에 대한 소개댜 냥! / 학사일정 알려줘 : 이번 달 학사일정을 조회한다! / 백록관 메뉴 : 백록관 백반 학식을 조회한다! / 천지관 메뉴 : 천지관 백반 학식을 조회한다! / 긱사 메뉴 : 재정생활관 학식 메뉴를 조회한다! / BTL 메뉴 : BTL 기숙사 학식 메뉴를 조회한다! / 메뉴 추천 : 음식 메뉴를 추천한다! / 배달 추천 : 배달음식을 추천한다! (광고 받는댜냥! 흥미있다면 쪽지주랴옹!) / 명령어는 게시글 제목 혹은 내용에 쓰면 된댜!! :: 감자 요정냥이 BOT",
          is_anonym: "0" # 0: 닉네임 공개 , 1: 익명
        })
        
        everytime_board_show = agent.post("https://everytime.kr/find/board/comment/list", {
          id: "#{x.article_id}"
        })
        
        everytime_xml_comment_text = everytime_board_show.xml.search('//response//comment').map{|node| node['text']}.last
        everytime_xml_comment_id = everytime_board_show.xml.search('//response//comment').map{|node| node['id']}.last
        
        puts "'#{x.title.truncate(15, omission: '...')}(게시글 ID : #{x.article_id})' [감자요정은 누구?] 봇 활동중.. >_<"
        x.update(comment_id: everytime_xml_comment_id, comment_content: everytime_xml_comment_text)
        sleep 3; # 글 작성 시 Delay가 있어야함 (Delay가 없으면 Everytime 측에서 '반복적인 글 작성'을 사유로 글 작성이 잠깐 막힘.)
      end
    end
    
    ## 학교 와이파이 암호
    CrawlingEverytime.all.where("title like ? AND title like ?", "%와이파이%", "%암호%").or(CrawlingEverytime.all.where("title like ? AND title like ?", "%와이파이%", "%비밀번호%")).or(CrawlingEverytime.all.where("title like ? AND title like ?", "%와이파이%", "%비번%")).or(CrawlingEverytime.all.where("content like ? AND content like ?", "%와이파이%", "%암호%")).or(CrawlingEverytime.all.where("content like ? AND content like ?", "%와이파이%", "%비밀번호%")).or(CrawlingEverytime.all.where("content like ? AND content like ?", "%와이파이%", "%비번%")).each do |x|
      if (x.comment_id == nil && x.comment_content == nil)
        everytime_board_write = agent.post("/save/board/comment", {
          id: "#{x.article_id}",
          text: "[교내 WIFI 정보] KNU_WLAN_Open : (암호)beyondme / KNU_WLAN_Secure : (아이디)학번, (암호)포탈암호 [단, 노트북은 정보화본부 사이트에서 Cuvic 프로그램을 다운받아야 함!] / U+ Zone : (암호)lguplus100 [WIFI 이름 띄어쓰기 확인必!] :: 감자 요정냥이 BOT [BOT 호출 - 게시글 제목 혹은 내용에 '감자요정 명령어' 언급!]",
          is_anonym: "0" # 0: 닉네임 공개 , 1: 익명
        })
        
        everytime_board_show = agent.post("https://everytime.kr/find/board/comment/list", {
          id: "#{x.article_id}"
        })
        
        everytime_xml_comment_text = everytime_board_show.xml.search('//response//comment').map{|node| node['text']}.last
        everytime_xml_comment_id = everytime_board_show.xml.search('//response//comment').map{|node| node['id']}.last
        
        puts "'#{x.title.truncate(15, omission: '...')}(게시글 ID : #{x.article_id})' [학교 와이파이 암호] 봇 활동중.. >_<"
        x.update(comment_id: everytime_xml_comment_id, comment_content: everytime_xml_comment_text)
        sleep 3; # 글 작성 시 Delay가 있어야함 (Delay가 없으면 Everytime 측에서 '반복적인 글 작성'을 사유로 글 작성이 잠깐 막힘.)
      end
    end
    
    ## 복사 가능 시설
    CrawlingEverytime.all.where("title like ? AND title like ?", "%복사%", "%어디%").or(CrawlingEverytime.all.where("title like ? AND title like ?", "%인쇄%", "%어디%")).or(CrawlingEverytime.all.where("title like ? AND title like ?", "%프린트%", "%어디%")).or(CrawlingEverytime.all.where("title like ? AND title like ?", "%프린터%", "%어디%")).each do |x|
      if (x.comment_id == nil && x.comment_content == nil)
        everytime_board_write = agent.post("/save/board/comment", {
          id: "#{x.article_id}",
          text: "교내 복사 가능 시설(춘천) : 재정생활관 기숙사 컴퓨터실, 60주년 기념관 2층(외부), 천지관 2층(시험기간에는 주말에도 오픈, 방학 때 교내에서 유일하게 오픈) / 복사카드(1만원)을 통해 이용 가능하댜 냐! / 복사카드는 교내 복사집에서 판매한댜! / 제본도 해준댜! :: 감자 요정냥이 BOT [BOT 호출 - 게시글 제목 혹은 내용에 '감자요정 명령어' 언급!]",
          is_anonym: "0" # 0: 닉네임 공개 , 1: 익명
        })
        
        everytime_board_show = agent.post("https://everytime.kr/find/board/comment/list", {
          id: "#{x.article_id}"
        })
        
        everytime_xml_comment_text = everytime_board_show.xml.search('//response//comment').map{|node| node['text']}.last
        everytime_xml_comment_id = everytime_board_show.xml.search('//response//comment').map{|node| node['id']}.last
        
        puts "'#{x.title.truncate(15, omission: '...')}(게시글 ID : #{x.article_id})' [복사 안내] 봇 활동중.. >_<"
        x.update(comment_id: everytime_xml_comment_id, comment_content: everytime_xml_comment_text)
        sleep 3; # 글 작성 시 Delay가 있어야함 (Delay가 없으면 Everytime 측에서 '반복적인 글 작성'을 사유로 글 작성이 잠깐 막힘.)
      end
    end
    
    ## 방학기간 복사
    CrawlingEverytime.all.where("title like ? AND title like ?", "%방학%", "%복사%").or(CrawlingEverytime.all.where("content like ? AND content like ?", "%방학%", "%복사%")).each do |x|
      if (x.comment_id == nil && x.comment_content == nil)
        everytime_board_write = agent.post("/save/board/comment", {
          id: "#{x.article_id}",
          text: "방학 때 복사 가능한 곳은 천지관 2층 복사실 뿐이다 냥! :: 감자 요정냥이 BOT [BOT 호출 - 게시글 제목 혹은 내용에 '감자요정 명령어' 언급!]",
          is_anonym: "0" # 0: 닉네임 공개 , 1: 익명
        })
        
        everytime_board_show = agent.post("https://everytime.kr/find/board/comment/list", {
          id: "#{x.article_id}"
        })
        
        everytime_xml_comment_text = everytime_board_show.xml.search('//response//comment').map{|node| node['text']}.last
        everytime_xml_comment_id = everytime_board_show.xml.search('//response//comment').map{|node| node['id']}.last
        
        puts "'#{x.title.truncate(15, omission: '...')}(게시글 ID : #{x.article_id})' [방학기간 복사 안내] 봇 활동중.. >_<"
        x.update(comment_id: everytime_xml_comment_id, comment_content: everytime_xml_comment_text)
        sleep 3; # 글 작성 시 Delay가 있어야함 (Delay가 없으면 Everytime 측에서 '반복적인 글 작성'을 사유로 글 작성이 잠깐 막힘.)
      end
    end
    
    ## ATM기 위치
    CrawlingEverytime.all.where("title like ?", "%ATM%").or(CrawlingEverytime.all.where("content like ?", "%ATM%")).each do |x|
      if (x.comment_id == nil && x.comment_content == nil)
        everytime_board_write = agent.post("/save/board/comment", {
          id: "#{x.article_id}",
          text: "[춘천캠] ATM기는 백록관 : 신한은행 및 농협, 공대쪽문 : 신한은행(00시 쯤에 마감), 후문 : 신한은행, 천지관에 신한은행 및 우체국과 농협(2층), BTL(남자동) 및 재정생활관 식당 : 신한은행 이 있댜! / 주말에도 운영한댜! :: 감자 요정냥이 BOT [BOT 호출 - 게시글 제목 혹은 내용에 '감자요정 명령어' 언급!]",
          is_anonym: "0" # 0: 닉네임 공개 , 1: 익명
        })
        
        everytime_board_show = agent.post("https://everytime.kr/find/board/comment/list", {
          id: "#{x.article_id}"
        })
        
        everytime_xml_comment_text = everytime_board_show.xml.search('//response//comment').map{|node| node['text']}.last
        everytime_xml_comment_id = everytime_board_show.xml.search('//response//comment').map{|node| node['id']}.last
        
        puts "'#{x.title.truncate(15, omission: '...')}(게시글 ID : #{x.article_id})' [ATM기 위치] 봇 활동중.. >_<"
        x.update(comment_id: everytime_xml_comment_id, comment_content: everytime_xml_comment_text)
        sleep 3; # 글 작성 시 Delay가 있어야함 (Delay가 없으면 Everytime 측에서 '반복적인 글 작성'을 사유로 글 작성이 잠깐 막힘.)
      end
    end
    
  end
end