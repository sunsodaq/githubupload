console.log("Reply 모듈.....");
/* var replyService=
	(function(){
		console.log("함수 호출")
		return {f1:(i,j)=>i+j}
	})() // 함수 선언 후 변수에 저장 // IIFE(즉시실행함수 ; Immediately(즉시) Invoked(호출되는) Function(함수) Expression(표현식)) : 선언 즉시 호출 실행
console.log(replyService.f1(2,3)) */
var replyService = (function () {
	// 데이터 등록
	const add = (reply, callback, error) => {
	  	console.log("reply.....")
	   	//p403 ajax (asynchronous json and xml)
	   	
	   	$.ajax({
   			type: 'post',
   			url: '/replies/new',
   			data: JSON.stringify(reply),
   			contentType: "application/json; charset=UTF-8",
   			success: function(result, status, xhr) {
	   			// 컨트롤러(백엔드) 에서 성공하면 여기 함수 호출이 된다
				if(callback) callback(result)
			},
			error: function(xhr,status, er) {
	   			// 컨트롤러에서 에러가 발생하면 호출된다
   				if(error) error(er)
   			}
   		})
	}
	
	// 전체 목록 조회
	const getList = (param, callback) => { //p406
		var bno = param.bno // 호출하는 곳에서 객체로 오니까 param.bno 로 접근가능
		var page = param.page || 1   // 전달되는 객체에 page 가 없으면 1로 설정
		$.getJSON(
			"/replies/pages/"+bno+"/"+page+".json", // url 
			data=> { // 컨트롤러에서 반환 성공하면 호출되는 메서드   //  List -> List+Cnt
				//console.log(data)
				//if(callback) callback(data.replyCnt, data.List) // 1개의 인자 -> 2개의 인자  
				// 책처럼 나누지 않고 하나의 데이터를 보내고 destructuring 함
				if(callback) callback(data)
			})
	}
	// 댓글 삭제 (p408)
	const remove = (rno, callback) => {
		$.ajax({
			type: 'delete',
			url: '/replies/'+ rno,
			success: (deleteResult, status)=>{
				if(callback) callback(deleteResult)
			}
		})
	}
	// 댓글 수정
	//update
	function update(reply, callback, error) {
		$.ajax({
			type : 'put',
			url : '/replies/' + reply.rno,
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr) {
				if (callback) {
					callback(result);
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(er);
				}
			}
		});
	}
	// 데이터 조회 (p412)
	const get=(rno, callback)=>{
		$.get("/replies/"+rno+".json",
			(result)=>{
				//console.log(result)
				if(callback) callback(result)
			})
	}
	//p417~418
	const displayTime=(timeValue)=>{
		var today = new Date()
		var gap = today.getTime() - timeValue
		var dateObj = new Date(timeValue)
		var str=""
		if(gap <(1000*60*60*24)){ // 1일 보다 작으면 시간을 표시하고 그렇지 않으면 날짜로 표시
			var hh = dateObj.getHours()
			var mi = dateObj.getMinutes()
			var ss = dateObj.getSeconds()
			return [ (hh>9 ? '':'0') + hh, ':', (mi >9 ?'':'0') + mi, ':', (ss >9 ? '':'0') + ss].join('')
		} else {
			var yy = dateObj.getFullYear()
			var mm = dateObj.getMonth() + 1
			var dd = dateObj.getDate()
			return [ yy, '/', (mm >9 ? '':'0') +mm, '/', (dd >9 ? '':'0') + dd].join('')
		}
	} // 배열에 저장되어 있는 것을 문자열 결합하기 위해 join 사용함
    return { add , getList, remove, update, get, displayTime }
})(); // replyService 에  {add} 가 저장 되었어요
	// get.jsp 에서 호출해 보세요 (p404)
console.log(replyService);
