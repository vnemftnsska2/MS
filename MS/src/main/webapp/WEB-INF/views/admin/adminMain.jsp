<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Management System</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
* {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

.left_area {
	width: 30%;
	padding-top: 3%;
	padding-left: 4%;
	float: left;
}

.right_area {
	width: 70%;
	float: right;
}

/* 사용자 정보 표시 */
.left_content {
	position: absolute;
	border-radius: 15px;
	border: 1px solid black;
	text-align: center; /* 컨텐트 안의 모든 요소 가운데 정렬 */
	min-width: 25%;
	height: 75%;
}

.left_btn_wrap {
	vertical-align: bottom;
}

.seatTable {
	margin: 0 auto;
	border-spacing: 40px;
	border-collapse: separate;
}

.seatTable td {
	width: 200px;
	height: 200px;
	border-radius: 15px;
	font-size: 40px;
	color: gray;
	text-align: center;
	background-color: lightgray;
}

.seatTable td:hover {
	opacity: 0.7;
	cursor: pointer;
}

/* 좌석 정보 중 타이틀(동적 생성) */
.seatTable td > div:nth-child(1) {
	border-top-left-radius: 10px;
	border-top-right-radius: 10px;
	background-color: #33b5e5;
	padding-left: 5px;
	padding-right: 5px;
}

/* 사용 종료 */
.end_btn {
	border-bottom-left-radius: 10px;
	border-bottom-right-radius: 10px;
	border: none;
	margin-top: 30px;
	font-size: 20px;
	width: 100%;
	height: 40px;
	cursor: no-drop;
}

/* modal창 감싸고 있는 배경 Div */
.add_time_modal {
	display: none; /* Hidden by default */
	position: fixed; /* Stay in place */
	z-index: 1; /* Sit on top */
	padding-top: 100px; /* Location of the box */
	left: 0;
	top: 0;
	width: 100%; /* Full width */
	height: 100%; /* Full height */
	overflow: auto; /* Enable scroll if needed */
	background-color: rgb(0, 0, 0); /* Fallback color */
	background-color: rgba(0, 0, 0, 0.4); /* Black w/ opacity */
}

/* 시간충전 modal창 내용 */
.modal_contents {
	background-color: #fefefe;
	margin: auto;
	padding: 15px;
	border: 1px solid #888;
	border-radius: 20px;
	width: 50%;
	text-align: center;
}

/* 충전하기 버튼 */
.add_time_btn {
	width: 150px;
	background-color: #f8585b;
	border: none;
	border-radius: 10px;
	color: #fff;
	padding: 15px 0;
	margin-top: 10px;
	text-align: center;
	font-size: 18px;
	cursor: pointer;
}

/* close 버튼 */
.close {
	color: #aaaaaa;
	float: right;
	font-size: 28px;
	font-weight: bold;
	font-size: 28px;
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/common/header.jsp"%>
	<%@ include file="/WEB-INF/views/modal/addTimeModal.jsp"%>
	
	<div class="adminMain_container">
		<div class="left_area">
			<div class="left_content">
				
				<div class="left_btn_wrap">
					<button type="button" class="btn btn-mdb-color">쪽지함</button>
					<button type="button" class="btn btn-deep-orange">자리 변경</button>
				</div>
			</div>
		</div>
		<div class="right_area">
			<table class="seatTable" id="seatTable">

			</table>
		</div>
	
	</div>
</body>

<script>
	$(document).ready(function() {
		var seatArr = new Array(20).fill(false); // 좌석 사용 여부 검사 배열
		var firstAddTime = false; // 처음 충전 여부
		var useTime = 0; // 사용 시간(초)	
		
		setInterval(function () { useTime++; }, 1000); // 사용 시간 계산

		/* 페이지 로드 시 좌석 초기화 */
		$.ajax({
			url: '<%=request.getContextPath()%>/admin/getUserInfoAll', 
			type: 'get',
			success:function(data){ // 좌석을 사용 중인 사용자 모두 가져오기
				for(var i=0; i<data.length; i++){
					seatArr[data[i].seat_id-1] = true; // 선택된 좌석 모두 사용 중으로 변경
					
					resetSeat($('#seatTable td').eq(data[i].seat_id-1), data[i].seat_id, data[i].user_id);
					timer(data[i].user_time, data[i].seat_id);
				}
			}
		});
		
		//////////////////////////////////////////////////////////////////////////////////////////////
		
		/* 웹페이지 닫기, 새로고침, 다른 URL로 이동 시에 발생 */
		 window.onbeforeunload = function() {
			
			// 처음 충전할 경우 사용 시간 1으로 만들고 파라미터 전송
			if(firstAddTime){
				useTime = 0; // n분 59초로 시작하기 위해서...
			}
			
			$.ajax({
				// 사용 시간 전송
				url: '<%=request.getContextPath()%>/admin/updateSaveTimeAll?useTime='+useTime, 
				type: 'get',
				
				success:function(){
					console.log("시간 저장 완료");
				}
			});
		};
		 
		//////////////////////////////////////////////////////////////////////////////////////////////
		
		/* 스크롤따라 움직이는 Div */
		var currentPosition = parseInt($('.left_content').css('top'));

		$(window).scroll(function() {
			var position = $(window).scrollTop();
			$('.left_content').stop().animate({
				'top' : position + currentPosition + 'px'
			}, 1000);
		});

		//////////////////////////////////////////////////////////////////////////////////////////////

		/* 좌석 테이블 동적 생성 */
		var str = '';
		var resetSeatId = 1;

		for (var i = 0; i < 5; i++) {
			str += '<tr>';

			for (var j = 0; j < 4; j++) {
				str += '<td id=' + resetSeatId + '>' + resetSeatId + '</td>';
				resetSeatId++;
			}
			str += '</tr>';
		}
		$('#seatTable').append(str);

		//////////////////////////////////////////////////////////////////////////////////////////////

		/* 좌석 클릭 시 처리 */
		var seatId = null;
		
		$('#seatTable td').click(function() {
			seatId = $(this).attr('id'); // 선택한 좌석 객체를 변수에 저장
			
			if(seatArr[seatId-1]){ // 사용 중인 좌석에만 충전 가능
				$('#add_time_modal').show(); // 시간 충전 modal창 띄우기
			}
		}); // end 좌석 선택 처리

		//////////////////////////////////////////////////////////////////////////////////////////////

		/* 시간 충전 select option 초기화  */
		for (var i = 1; i <= 12; i++) {
			var option = '<option value='+ i + '>' + i + ' 시간</option>';
			$('#select_add_time').append(option);
		}

		/* 충전하기 클릭 시 처리 */
		$('#add_time_btn').click(function() {
			
			if ($('#select_add_time option:selected').val() == 0) {
				alert('충전하실 시간을 선택하세요.');
				return;
			}
			var addTime = $('#select_add_time option:selected').val()*60*60; // 충전할 시간(초 단위)
			
			$.ajax({
				// 충전 시간, 좌석번호를 파라미터로 넘겨줌.
				url: '<%=request.getContextPath()%>/admin/updateAddTime?addTime=' + addTime + '&seatId=' + seatId, 
				type: 'get',
				
				success:function(){
					location.reload();
					
				} // end success 
			}); // end ajax 
		}); // end 충전하기
		
		//////////////////////////////////////////////////////////////////////////////////////////////

		/* 시간 충전 modal 창 닫기 버튼 클릭 시 처리 */
		$('.close').on('click', function() {
			$('#add_time_modal').hide();
		});

		/* modal 창 외 윈도우 클릭 시 처리 */
		$(window).on('click', function() {
			if (event.target == $('#add_time_modal').get(0)) {
				$('#add_time_modal').hide();
			}
		});	
			
	}); // end $(document).ready(function())}
	
	//////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////
	
	/* 좌석 생성 함수(좌석 객체, 좌석 번호, 유저 아이디) */
	function resetSeat(obj, seatId, userId) {	
		$(obj).css({
			'font-size' : 25,
			'color' : 'white',
			'background-color' : '#0099CC',
			'text-align' : 'right',
			'padding' : 10,
			'vertical-align': 'top'
		});
		
		str = '<div>';
		str += '<span style="color: black; font-weight: bold; float: left">'+ seatId +'</span>';
		str += '<span>'+ userId +'</span>';
		str += '</div>';
		str += '<div><span id="countTimeMinute'+ seatId +'"></span>분';
		str += '<span id="countTimeSecond'+ seatId +'"></span>초</div>';
		str += '<div>5000</div>';
		str += '<button class="end_btn">사용 종료</button>';
		
		// 자신의 좌석에만 사용 종료 버튼 표시
		/* if(userId == '${userSession.user_id}'){
			str += '<button class="end_btn">사용 종료</button>';
		} */

		/* $('.end_btn').on('click', function(event) {
			event.stopPropagation();
			console.log("호호");
		});	 */
		
		$(obj).text(''); // 중앙에 써있던 좌석 번호 지우기
		$(obj).append(str); // 좌석 사용 정보 보여주기
		
		// 로그인한 유저의 좌석 외 다른 좌석은 빨간색으로 변경
		/* if(userId != '${userSession.user_id}'){ 
			$(obj).css('background-color', '#CC0000'); // 배경색 변경
			$(obj).children().eq(0).css('background-color', '#ff4444'); // 타이틀 색 변경
		} */
	}
	
	/* 시간 타이머(초, 좌석 아이디) */
	function timer(s, seatId){	
		var min = Math.floor(s/60); // 분 계산
		var sec = Math.floor(s%60); // 초 계산
		
		// 써주지 않으면 처음 로드 시 1초 후 보이게 됨
		$('#countTimeMinute'+seatId).html(min); // 분 텍스트
		$('#countTimeSecond'+seatId).html(sec); // 초 텍스트
		
		if(sec < 10){ // 10초 이하일 경우 두 자리 표시 ex)09
			$('#countTimeSecond'+seatId).html('0' + sec); 
		}
		
		var timer = setInterval(function () {
			
			$('#countTimeMinute'+seatId).html(min); // 분 텍스트
			$('#countTimeSecond'+seatId).html(sec); // 초 텍스트				
			
			if(sec == 1 && min == 0){ // 사용 시간 종료
				$('#countTimeSecond'+seatId).html('00'); 
				clearInterval(timer);
				
				$.ajax({
					// 좌석 삭제(좌석 번호)
					url: '<%=request.getContextPath()%>/admin/deleteSeat?seatId=' + seatId, 
					type: 'get',
					
					success:function(){
						location.reload();
						
					} // end success 
				}); // end ajax

			}else{
				sec--;
				
				if(sec < 10){ // 10초 이하일 경우 두 자리 표시 ex)09
					$('#countTimeSecond'+seatId).html('0' + sec); 
				}
				
				if(sec < 1){
					min--;
					sec = 59;
				}
			}
    	}, 1000);
	}
	
	/* 사용 종료 버튼 클릭 시 처리(실행 순서로 인한 미작동으로 onclick으로 구현) */
	/* function end(event){	
		event.stopPropagation();
		event.cancelBubble = true;
		console.log("종료함");
	} */
	
</script>
</html>