# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

## 테스트 계정 생성(어드민 권한 O)
test1 = User.create( email: 'kbs4674@naver.com', password: '123456', nickname: '어드민', admin: true )
user = User.find(1)
user.add_role :admin

## 테스트 계정 생성(어드민 권한 X)
test2 = User.create( email: 'test4674@naver.com', password: '123456', nickname: '테스트계정1',  admin: false )
user = User.find(2)
user.add_role :normal
user.add_role :block_yellow
user.add_role :block_red

User.create( email: 'test@naver.com', password: '123456', nickname: '테스트계정2',  admin: false )
User.create( email: 'test2@naver.com', password: '123456', nickname: '테스트계정3',  admin: false )
User.create( email: 'test3@naver.com', password: '123456', nickname: '테스트계정4',  admin: false )

## 게시판 생성
Bulletin.create( title: '어드민 게시판', content: '어드민만 글 작성이 가능한 게시판 입니다', opt_admin_only: true, user_nickname: '어드민', user_id: '1' )
Bulletin.create( title: '투표 게시판', content: '게시글 및 댓글에 투표가 가능합니다.', opt_post_vote: true, opt_comment_vote: true , user_nickname: '어드민', user_id: '1' )
Bulletin.create( title: '이메일 전송 게시판', content: '이메일 전송이 가능한 게시판 입니다', opt_email: true, opt_email_quantity: '2', user_nickname: '어드민', user_id: '1' )
Bulletin.create( title: '자유게시판', content: '누구나 글쓰기가 가능한 게시판 입니다', opt_hashtag: true, user_nickname: '어드민', user_id: '1' )
Bulletin.create( title: '해시태그 자유게시판', content: '누구나 글쓰기가 가능한 게시판 입니다', opt_hashtag: true, user_nickname: '어드민', user_id: '1' )

## 데이터 테스트용
# for num in 1..50000
#     AllNotice.create( title: "#{num}", content: "안녕#{num+2}", global_notice: 'false', local_notice: 'false', user_nickname: "어드민", user_id: "1" )
# end