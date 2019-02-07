# 에브리타임 레일즈 크롤러 & 봇
<img src="https://github.com/kbs4674/everytime_crawlbot/blob/master/public/img/bot_logo.png?raw=true">

## 1. INFO
<img src="https://github.com/kbs4674/everytime_crawlbot/blob/master/public/img/everytime.png?raw=true">

#### [개발 이야기] https://blog.naver.com/kbs4674/221460241196

## 2. 루비/루비온 레일즈 정보
* Ruby : 2.4.0
* Rails : 5.1.6


## 3. 프로젝트 개요
- BOT은 10분마다 게시글을 체크합니다.
- 에브리타임 게시판에서 봇이 게시글 Parsing을 하면서 매칭되는 단어가 있으면 단어에 맞는 답변을 합니다.
- Example 1. 신입생 게시판 : "기숙사" + "필수" = (예상질문) 기숙사 입사에 있어 필수용품이 뭐가있을까요?
    - 요정냥이가 알려주는 기숙사 필수 물품 : 헤어드라이기, 샤워도구 및 샤워바구니, 빗자루/쓰레받이, 보온병(물병), 롤링 테이프, 침구류, 빨래바구니, 세제, 휴대폰 충전기, 멀티탭, 슬리퍼, 물티슈 / 참고로 공유기는 없어도 됨. (방마다 구비) :: 감자 요정냥이 BOT
- Example 2. 춘천캠 자유게시판 : "긱사" + "메뉴" = (예상질문) 오늘 긱사 학식메뉴가 뭐야? (18시에 게시글 작성)
    - 재정생활관 메뉴(2월 7일 저녁) : 보리밥 바지락아욱국 훈제오리구이/무쌈 부추양파무침 알타리김치 :: 감자 요정냥이 BOT

## 4. 핵심 코드설명
1. ```lib/tasks/bot_example.rake``` [<a href="/lib/tasks/bot_example.rake">이동</a>] 에브리타임 로그인처리 및 크롤링, 조건단어 탐색 후 댓글 답변을 하는 task 파일 (전체 비공개, 기본 예시만 공개)
2. ```app/controllers/bot_events_controller.rb``` [<a href="/app/controllers/bot_events_controller.rb">이동</a>] 에브리타임에 달아놓은 댓글답변 삭제처리
3. ```app/views/crawling_everytimes/index.html.erb``` [<a href="/app/views/crawling_everytimes/index.html.erb">이동</a>] 메인 페이지 View


## 5. 서버 설정
* 계정 정보가 담긴 ```application.yml``` 파일과 주기적으로 크롤링을 하는 task 파일은 공개를 생략했습니다. (단, 간단한 예시문이 적힌 task 파일은 공개)
* <b>AWS 기준</b> 서버 설정법은 다음 과정을 따라주길 바랍니다.
    * <a href="https://blog.naver.com/kbs4674/221168996150" target="_blank">```https://blog.naver.com/kbs4674/221168996150```</a>
* <b>Heroku</b> 서버 셋팅은 <a href="http://wantknow.tistory.com/61" target="_blank"><b>여기</b></a>를 참고 바랍니다.
* 터미널 명령어 입력
```
git init
rm -rf README.md
git remote add origin https://github.com/kbs4674/everytime_crawlbot
git pull origin master
gem install rails --version=5.1.6
bundle install
rake db:drop;rake db:migrate;rake db:seed
rails s -b $IP -p $PORT
```
* <b>development 환경</b>에서 ```rake db:drop``` 시 오류가 나오는 것은 "정상"입니다.
    * production 모드에서 설정한 PostgreSQL DB 설정 때문이며, 정상 drop 됩니다.
* <b>Heroku</b> 서버 설정 시, ```database.yml``` 파일을 수정해주세요.
* <b>Heroku</b> 에 Deploy 때, <b>You must use Bundler 2 or greater with this lockfile</b> 오류 발생 시,
```heroku login``` 및 ```git remote heroku ...``` 후,  ```heroku buildpacks:set https://github.com/bundler/heroku-buildpack-bundler2``` 명령어를 입력해주세요.