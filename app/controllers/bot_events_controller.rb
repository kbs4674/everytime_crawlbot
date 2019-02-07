class BotEventsController < ApplicationController
  # 로그인 된 사용자만 접근 가능
  # before_action :authenticate_user!, only: [:index, :new, :show, :edit]
  
  def destroy_comment
    @event = CrawlingEverytime.find(params[:crawling_everytimes_id])
    
    # Everytime 로그인
    require 'nokogiri'
    require 'open-uri'
    require 'mechanize'
    
    agent = Mechanize.new
    page = agent.get("https://everytime.kr/login?redirect=/385899/v/62765146")
    login = page.form_with(:action => "/user/login")
    login.field_with(:name => "userid").value = "#{ENV["EVERYTIME_ID"]}"
    login.field_with(:name => "password").value = "#{ENV["EVERYTIME_PASSWORD"]}"
    login_result = agent.submit login
    
    everytime_destroy = agent.post("/remove/board/comment", {
      id: "#{@event.comment_id}" # 댓글 ID
    })
    
    @event.update(comment_id: nil, comment_content: nil)
    
    redirect_to request.referrer, { notice: "Everytime 원본 댓글을 삭제했습니다." }
  end
  
  def activate_newbie
    if (current_user.has_role? :admin)
      %x[rake "crawling_everytime_newbie:crawling_everytime_newbie"]
      redirect_to request.referrer, { notice: "새내기 게시판의 강제 BOT 활동을 마쳤습니다." }
    end
  end
  
  def activate_info
    if (current_user.has_role? :admin)
      %x[rake "crawling_everytime_chun_info:crawling_everytime_chun_info"; rake "crawling_everytime_chun_normal:crawling_everytime_normal"; rake "crawling_everytime_chun_meal:crawling_everytime_chun_meal"; rake "crawling_everytime_chun_monthly_schedule:crawling_everytime_chun_monthly_schedule"]
      redirect_to request.referrer, { notice: "춘천캠 자유게시판의 강제 BOT 활동을 마쳤습니다." }
    end
  end
end
