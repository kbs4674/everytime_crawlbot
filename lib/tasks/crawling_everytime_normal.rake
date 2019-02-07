## rake "crawling_everytime_chun_normal:crawling_everytime_chun_normal"

namespace :crawling_everytime_chun_normal do
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
  
  task crawling_everytime_chun_normal: :environment do
    
    ## 3개월 전 게시글은 삭제
    CrawlingEverytime.where("created_at < ?", 3.days.ago).each do |x|
      x.destroy
    end
    
    ### 춘천캠 자유게시판
    everytime_board_list = agent.post("/find/board/article/list", {
      id: "380617" # 게시글 ID값
    })
    everytime_xml_id = everytime_board_list.xml.search('//response//article').map{|node| node['id']}
    everytime_xml_title = everytime_board_list.xml.search('//response//article').map{|node| node['title']}
    everytime_xml_content = everytime_board_list.xml.search('//response//article').map{|node| node['text']}
    
    ## 감자요정은 누구?
    CrawlingEverytime.all.where("title like ? AND title like ?", "%감자요정%", "%뭐임%").or(CrawlingEverytime.all.where("title like ? AND title like ?", "%감자요정%", "%뭐야%")).or(CrawlingEverytime.all.where("title like ? AND title like ?", "%감자요정%", "%누구%")).or(CrawlingEverytime.all.where("title like ? AND title like ?", "%감자요정%", "%뭐하는%")).or(CrawlingEverytime.all.where("content like ? AND content like ?", "%감자요정%", "%뭐임%")).or(CrawlingEverytime.all.where("content like ? AND content like ?", "%감자요정%", "%뭐야%")).or(CrawlingEverytime.all.where("content like ? AND content like ?", "%감자요정%", "%누구%")).or(CrawlingEverytime.all.where("content like ? AND content like ?", "%감자요정%", "%뭐하는%")).each do |x|
      if (x.comment_id == nil && x.comment_content == nil)
        everytime_board_write = agent.post("/save/board/comment", {
          id: "#{x.article_id}",
          text: "감자요정은 강원대의 수호신이댜 냥! 내가 더 궁금하다면 게시글 제목 혹은 내용에 '감자요정 명령어' 라고 입력해랴, 냥! (10분 주기로 글을 확인한댜 냥!) :: 감자 요정냥이 BOT",
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
    
    ## 감자요정 사람
    CrawlingEverytime.all.where("title like ? AND title like ?", "%감자요정%", "%사람%").or(CrawlingEverytime.all.where("content like ? AND content like ?", "%감자요정%", "%사람%")).each do |x|
      if (x.comment_id == nil && x.comment_content == nil)
        everytime_board_write = agent.post("/save/board/comment", {
          id: "#{x.article_id}",
          text: "지금은 로봇이어도 때론 나를 만든 주인님이 직접 글을 쓰기도 한댜옹! :: 감자 요정냥이 BOT [BOT 호출 - 게시글 제목 혹은 내용에 '감자요정 명령어' 언급!]",
          is_anonym: "0" # 0: 닉네임 공개 , 1: 익명
        })
        
        everytime_board_show = agent.post("https://everytime.kr/find/board/comment/list", {
          id: "#{x.article_id}"
        })
        
        everytime_xml_comment_text = everytime_board_show.xml.search('//response//comment').map{|node| node['text']}.last
        everytime_xml_comment_id = everytime_board_show.xml.search('//response//comment').map{|node| node['id']}.last
        
        puts "'#{x.title.truncate(15, omission: '...')}(게시글 ID : #{x.article_id})' [감자요정은 사람인가?] 봇 활동중.. >_<"
        x.update(comment_id: everytime_xml_comment_id, comment_content: everytime_xml_comment_text)
        sleep 3; # 글 작성 시 Delay가 있어야함 (Delay가 없으면 Everytime 측에서 '반복적인 글 작성'을 사유로 글 작성이 잠깐 막힘.)
      end
    end
    
    ## 멋쟁이 사자처럼
    CrawlingEverytime.all.where("title like ?", "%멋쟁이사자처럼%").or(CrawlingEverytime.all.where("title like ?", "%likelion%")).or(CrawlingEverytime.all.where("title like ?", "%멋쟁이 사자처럼%")).or(CrawlingEverytime.all.where("title like ?", "%멋사%")).or(CrawlingEverytime.all.where("content like ?", "%멋쟁이사자처럼%")).or(CrawlingEverytime.all.where("content like ?", "%likelion%")).or(CrawlingEverytime.all.where("content like ?", "%멋쟁이 사자처럼%")).or(CrawlingEverytime.all.where("content like ?", "%멋사%")).each do |x|
      if (x.comment_id == nil && x.comment_content == nil)
        @text_content = ['멋사.. 날 낳아준 부모같은 존재댜 냐!! (https://www.facebook.com/likelionkangwon/)', '멋쟁이 사자처럼은 18년도에 대동제 사이트를 만든 동아리이기도 하댜, 냐! (https://www.facebook.com/likelionkangwon/)', '멋쟁이 사자처럼은 18년도 때 대동제 사이트를 만든 동아리이기도 하댜, 냐! (https://www.facebook.com/likelionkangwon/)', '코딩을 즐겨보고 싶다면 모집기간 때 멋사 한번 지원 넣어봐랴! (https://www.facebook.com/likelionkangwon/)', '날 만든 창조주는 고양이를 좋아하는 엄청난 관심종자였댜! (https://www.facebook.com/likelionkangwon/)'].sample
        everytime_board_write = agent.post("/save/board/comment", {
          id: "#{x.article_id}",
          text: "#{@text_content} :: 감자 요정냥이 BOT [BOT 호출 - 게시글 제목 혹은 내용에 '감자요정 명령어' 언급!]",
          is_anonym: "0" # 0: 닉네임 공개 , 1: 익명
        })
        
        everytime_board_show = agent.post("https://everytime.kr/find/board/comment/list", {
          id: "#{x.article_id}"
        })
        
        everytime_xml_comment_text = everytime_board_show.xml.search('//response//comment').map{|node| node['text']}.last
        everytime_xml_comment_id = everytime_board_show.xml.search('//response//comment').map{|node| node['id']}.last
        
        puts "'#{x.title.truncate(15, omission: '...')}(게시글 ID : #{x.article_id})' [멋쟁이 사자처럼] 봇 활동중.. >_<"
        x.update(comment_id: everytime_xml_comment_id, comment_content: everytime_xml_comment_text)
        sleep 3; # 글 작성 시 Delay가 있어야함 (Delay가 없으면 Everytime 측에서 '반복적인 글 작성'을 사유로 글 작성이 잠깐 막힘.)
      end
    end
    
    ## 맛귀신
    CrawlingEverytime.all.where("title like ?", "%맛귀신%").or(CrawlingEverytime.all.where("content like ?", "%맛귀신%")).each do |x|
      if (x.comment_id == nil && x.comment_content == nil)
        @text_content = ['앗! 야생의 맛귀신이냥!👻', '제 점수는냥...', '오늘은 어디냥!', '맛귀신.. 그의 이름만 올라서면 난 무조건 쫓아간다옹!! 👻', '어흥~!'].sample
        everytime_board_write = agent.post("/save/board/comment", {
          id: "#{x.article_id}",
          text: "#{@text_content} :: 감자 요정냥이 BOT [BOT 호출 - 게시글 제목 혹은 내용에 '감자요정 명령어' 언급!]",
          is_anonym: "0" # 0: 닉네임 공개 , 1: 익명
        })
        
        everytime_board_show = agent.post("https://everytime.kr/find/board/comment/list", {
          id: "#{x.article_id}"
        })
        
        everytime_xml_comment_text = everytime_board_show.xml.search('//response//comment').map{|node| node['text']}.last
        everytime_xml_comment_id = everytime_board_show.xml.search('//response//comment').map{|node| node['id']}.last
        
        puts "'#{x.title.truncate(15, omission: '...')}(게시글 ID : #{x.article_id})' [맛귀신] 봇 활동중.. >_<"
        x.update(comment_id: everytime_xml_comment_id, comment_content: everytime_xml_comment_text)
        sleep 3; # 글 작성 시 Delay가 있어야함 (Delay가 없으면 Everytime 측에서 '반복적인 글 작성'을 사유로 글 작성이 잠깐 막힘.)
      end
    end
    
    ## 배달음식 추천
    CrawlingEverytime.all.where("title like ? AND title like ?", "%배달%", "%추천%").or(CrawlingEverytime.all.where("title like ? AND title like ? AND title like ?", "%배달%", "%음식%", "%추천%")).or(CrawlingEverytime.all.where("content like ? AND content like ?", "%배달%", "%추천%")).or(CrawlingEverytime.all.where("content like ? AND content like ? AND content like ?", "%배달%", "%음식%", "%추천%")).each do |x|
      if (x.comment_id == nil && x.comment_content == nil)
        @text_content = ['치킨', '백반', '중국집 음식', '직접 나가서 사먹쟈', '국밥', '보쌈', '돈까스', '찜닭', '수제 햄버거', '분식류(떡튀순 JMT!)', '피자', '닭강정'].sample
        everytime_board_write = agent.post("/save/board/comment", {
          id: "#{x.article_id}",
          text: "글쓴이의 추천 배달음식은 [#{@text_content}] 이댜, 냥! :: 감자 요정냥이 BOT [BOT 호출 - 게시글 제목 혹은 내용에 '감자요정 명령어' 언급! / 가게 광고신청 받는댜냥! 흥미있다면 쪽지주랴옹!]",
          is_anonym: "0" # 0: 닉네임 공개 , 1: 익명
        })
        
        everytime_board_show = agent.post("https://everytime.kr/find/board/comment/list", {
          id: "#{x.article_id}"
        })
        
        everytime_xml_comment_text = everytime_board_show.xml.search('//response//comment').map{|node| node['text']}.last
        everytime_xml_comment_id = everytime_board_show.xml.search('//response//comment').map{|node| node['id']}.last
        
        puts "'#{x.title.truncate(15, omission: '...')}(게시글 ID : #{x.article_id})' [배달음식 추천] 봇 활동중.. >_<"
        x.update(comment_id: everytime_xml_comment_id, comment_content: everytime_xml_comment_text)
        sleep 3; # 글 작성 시 Delay가 있어야함 (Delay가 없으면 Everytime 측에서 '반복적인 글 작성'을 사유로 글 작성이 잠깐 막힘.)
      end
    end
    
    ## 메뉴 추천
    CrawlingEverytime.all.where("title like ? AND title like ?", "%음식%", "%추천%").or(CrawlingEverytime.all.where("title like ? AND title like ?", "%메뉴%", "%추천%")).or(CrawlingEverytime.all.where("content like ? AND content like ?", "%음식%", "%추천%")).or(CrawlingEverytime.all.where("content like ? AND content like ?", "%메뉴%", "%추천%")).each do |x|
      if (x.comment_id == nil && x.comment_content == nil)
        @text_content = ['치킨', '피자', '편의점 도시락', '컵라면', '백반', '수제햄버거', '부리또', '짜장', '짬뽕', '중국집 음식', '직접 나가서 사먹쟈', '찜닭', '국밥', '닭갈비', '카레', '덮밥류', '보쌈', '돈까스', '국수', '분식류(떡튀순 JMT!)', '닭강정'].sample
        everytime_board_write = agent.post("/save/board/comment", {
          id: "#{x.article_id}",
          text: "글쓴이의 추천 음식은 [#{@text_content}] 이댜, 냥! :: 감자 요정냥이 BOT [BOT 호출 - 게시글 제목 혹은 내용에 '감자요정 명령어' 언급!]",
          is_anonym: "0" # 0: 닉네임 공개 , 1: 익명
        })
        
        everytime_board_show = agent.post("https://everytime.kr/find/board/comment/list", {
          id: "#{x.article_id}"
        })
        
        everytime_xml_comment_text = everytime_board_show.xml.search('//response//comment').map{|node| node['text']}.last
        everytime_xml_comment_id = everytime_board_show.xml.search('//response//comment').map{|node| node['id']}.last
        
        puts "'#{x.title.truncate(15, omission: '...')}(게시글 ID : #{x.article_id})' [메뉴 추천] 봇 활동중.. >_<"
        x.update(comment_id: everytime_xml_comment_id, comment_content: everytime_xml_comment_text)
        sleep 3; # 글 작성 시 Delay가 있어야함 (Delay가 없으면 Everytime 측에서 '반복적인 글 작성'을 사유로 글 작성이 잠깐 막힘.)
      end
    end
    
  end
end