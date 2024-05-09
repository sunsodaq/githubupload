<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../includes/header.jsp" %>
<script type="text/javascript" src="/resources/js/re.js">
</script>
<style>
/* p524 */
	.uploadResult{
		width: 100%;
		background-color: gray;
	}
	.uploadResult ul{
		display: flex;
		flex-flow: row;
		justify-content: center;
		align-items: center;
	}
	.uploadResult ul li{
		list-style:none;
		padding: 10px;
		align-content: center;
		text-align: center;
	}
	.uploadResult ul  li img{
		width: 100px;
	}
	.uploadResult ul li span{
		color: white;
	}
	.bigPictureWrapper{
		position: absolute;
		display: none;
		justify-content: center;
		align-items: center;
		top: 0%;
		width: 100%;
		height: 100%;
		background-color: gray;
		z-index: 100;
		background: rgba(255, 255,255,0.5);
	}
	.bigPicture{
		position: relative;
		display: flex;
		justify-content: center;
		align-items: center;
	}
	.bigPicture img{
		width: 600px;
	}

</style>
<script>	
  //p265 
 	const f=()=>{
		console.log("폰트 오섬 눌렸어요")
	}
	$(document).ready(function(){

		(function(){
			var bnoValue = '<c:out value="${board.bno}"/>'
			$.getJSON("/board/getAttachList",{bno:bnoValue}, (arr)=>{
				console.log(arr)//P571
				var str=""
				$(arr).each(function(i,obj){
					console.log(obj)
					if(!obj.image){
						var stringFileName = obj.uploadPath+"/s_" + obj.uuid+"_" +obj.fileName
						console.log('f:',stringFileName)
						var fileCallPath= encodeURIComponent(stringFileName)//encodeURIComponent =>한글 깨짐 대응 
						str+= "<li data-path='" +obj.uploadPath+"'data-uuid='"+ obj.uuid+"' data-filename='"
							+ obj.fileName +"' data-type='" + obj.image+"'><div>"
						str += "<span> " + obj.fileName +"</span>"
						str += "<button type='button' data-file=\'"+ fileCallPath +"\'  data-type='image'"
						str +=	"class='btn btn-warning btn-circle'><i class='fa fa-times'>"+
										"</i></button><br>"
										+"<img  src='/display?fileName=" + fileCallPath +
										"'></div></li>" 
						} else{
							var fileCallPath = encodeURIComponent(obj.uploadPath+ "/"+obj.uuid+"_"+obj.fileName)
							var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/")
							str+= "<li data-path='"+obj.uploadPath+"'data-uuid='"+obj.uuid+"' data-fileName='"+obj.fileName+"'data-type='"+obj.image+"'"
							str+= "><div><span>"+obj.fileName+"</span><button type='button' data-file=\'"+fileCallPath+"\' data-type='file' "
							str+= "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button></br>"
							str+= "<img src='/resources/img/attach.jpg'></div></li>"
					}
				}) 
				$(".uploadResult ul").append(str)
			})// getJson
			const showImage=(fileCallPath)=>{
				alert(fileCallPath)
				$(".bigPictureWrapper").css("display","flex").show()
				$(".bigPicture").html("<img src='/display?fileName="+ fileCallPath+"'>")
					.animate({width:'600px' ,height:'400px'} ,1000)
					 setTimeout(function(){
						$(".bigPictureWrapper").fadeOut()
					},1000) 
			}// showImage
			$(".uploadResult").on('click', 'button', function(e){//p588
				console.log("삭제버튼이 눌렸어요")
				if(confirm("정말로 삭제하시겠습니까?")){
					var targetLi =$(this).closest("li")
					targetLi.remove()
				}
			})
			$(".uploadResult").on('click','li',function(e){
				console.log("이미지 보기가 눌렸어요")
				var liObj= $(this)
				var stringF= liObj.data("path")+ "/"	+liObj.data("uuid")+"_"+liObj.data("filename")
				console.log(stringF)
				var path= encodeURIComponent(stringF)
				if(liObj.data("type")) showImage(path.replace(new RegExp(/\\/g),"/"))
				else self.location = "/download?fileName=" +path
				
			})// click li 

				
				var replyUL = $(".chat")
		//p440
		var pageNum = 1
		var replyPageFooter = $(".panel-footer")
		const showReplyPage=(replyCnt)=>{ // 여기 복사해서 p440 으로 변경 (page 단위 처리)
			var endNum = Math.ceil(pageNum /10.0) * 10
			var startNum = endNum - 9
			
			var prev = startNum != 1
			var next = false
			
			if(endNum * 10 >= replyCnt) endNum = Math.ceil(replyCnt/10.0)
			if(endNum * 10 < replyCnt) next = true
			var str = "<ul class='pagination pull-right'>"
			if(prev) {
				str+= "<li class='page-item'><a class='page-link' href='"+ (startNum -1) +"'>이전</a></li>"
			}
			for(var i=startNum; i<=endNum; i++) {
				var active = pageNum == i? "active":""
				str+= "<li class='page-item "+ active + " '><a class='page-link' href='"+ i +"'>"+ i +"</a></li>"
			}
			if(next) {
				str+= "<li class='page-item'><a class='page-link' href='"+(endNum+1)+"'>다음</a></li>"
			}
			str+="</ul></div>"
			console.log(str)
			replyPageFooter.html(str)
		} // showReplyPage
		
		
		const showList=(page)=>{
			var replyUL=$(".chat")	
			replyService.getList({bno:bnoValue, page:page||1},
				({replyCnt, list})=>{
					console.log("list: ", replyCnt, list)
					if(page == -1) { // pageDTO => board (자바버전) => javascript 버전
						pageNum = Math.ceil(replyCnt/10.0) // 무조건 올림
						showList(pageNum)
						return
					}
					var str=""
					if(list ==null || list.length ==0) {
						replyUL.html("")
						return ;
					}
					var len = list.length
					for(var i=0; i<len || 0; i++){
						str+= "<li class='left clearfix' data-rno='" + list[i].rno +"'>"
						str+= "  <div><div class='header'><strong class='primary-font'>" + list[i].replyer +"</strong>"
						str+= "   <small calss='pull-right text-muted'>" + replyService.displayTime(list[i].replyDate) +"</small></div>"
						str+= "   <p>" + list[i].reply +"</p></div></li>"
					}
					replyUL.html(str)
					
					showReplyPage(replyCnt)
				} // lambda 함수 (list)=> {}, getList 의  두번째 인자(성공하면 호출되는 callback)		
			) // getList
		} // showList
		
		showList(1)// page를 1에서 -1로 변경
		var pageNum
		//p441
		replyPageFooter.on("click","li a" ,function(e){
			e.preventDefault()
			var targetPageNum= $(this).attr("href")
			console.log("page clicked ", targetPageNum)
			pageNum= targetPageNum
			//$(".panel-footer li").css('background-color','blue')
			showList(pageNum)
		})
		//p422
		var modal = $("#modal input")		
		var modalModBtn = $("#modalModBtn")
		var modalRemoveBtn = $("#modalRemoveBtn")
		var modalRegisterBtn = $("#modalRegisterBtn")
		$("#addReplyBtn").click(function(e){
			var reply = modal.eq(0).val()
			var replyer = modal.eq(1).val()
			console.log("모달버튼이 눌렸나?")
			console.log(reply)
			var reply={
				reply,
				replyer,
				bno:bnoValue
			}
			replyService.add(reply,(result)=>{//추가시 나오는것 
				alert(result)
				showList()//호출 
			}) 
			
		})
		var rno
		//p424,댓글을 누르면(li)
		$(".chat").on("click","li", function(e){
			rno = $(this).data("rno")
			console.log(rno)
			replyService.get(rno,(reply)=>{
				console.log(reply)
				modal.eq(0).val(reply.reply)
				modal.eq(1).val(reply.replyer)
				modal.eq(2).val(replyService.displayTime(reply.replyDate))
			})
		})
		
		var operForm = $("#operForm")
		$("button[data-oper='modify']").click(function (e) {
			e.preventDefault();
			operForm.attr("action", "/board/modify").submit();//.attr("method", "post")
		});
		$("button[data-oper='list']").click(function (e) {
			e.preventDefault();
			operForm.find("#bno").remove(); // id가 bno인 것을 찾아 내용을 삭제
			operForm.attr("action", "/board/list").submit();//.attr("method", "get")
		});
		$("button").each(function(idx, data){
			var u = $(this).text()
			//console.log(u)
			$(this).click(function(e){
				u = $(this).text()
				console.log(u)
				var reply = modal.eq(0).val()
				var replyer = modal.eq(1).val()
				console.log(reply,replyer)
				if(u.trim()==='수정') replyService.update(
						{bno:bnoValue,reply,replyer,rno},
						(v)=>{
							console.log(v)
						showList(pageNum)
				})
				if(u.trim()==='삭제') {
					replyService.remove(rno,(vv)=>alert(vv))
					showList(pageNum)
				}
			})//click
		})
		})()//function 감싼 마지막(IIFE)
    //attr = attribute 의 약자
	}); //ready 
</script>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">게시글 조회</h1>
	</div>
</div>

<!-- End of Main Content -->
<!-- p239 -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">게시글 조회</div>
			<div class="panel-body">
				<div class="uploadResult">
					<ul></ul>
				</div>
				<div class="bigPictureWrapper">
					<div class="bigPicture"></div>
				</div>
				<div class="form-group">
					<label for="">번호</label>
					<input type="text" class="form-control" name="bno" readonly value="${board.bno}" />
				</div>
				<div class="form-group">
					<label for="">제목</label>
					<input type="text" class="form-control" name="title" readonly value="${board.title}" />
				</div>
				<div class="form-group">
					<label for="">내용</label>
					<textarea id="" class="form-control" rows="5" name="content" readonly> ${board.content}</textarea>
				</div>
				<div class="form-group">
					<label for="">작성자</label>
					<input type="text" class="form-control" name="writer" value="${board.writer}" readonly />
				</div>
				<button data-oper="modify" class="btn btn-default">수정</button>
				<button data-oper="list" class="btn btn-info">목록</button>
				<form id="operForm" action="/board/modify" method="get">
					<input type="hidden" id="bno" name="bno" value="${board.bno}" />
					<input type="hidden" name="pageNum" value="${cri.pageNum}" />
					<input type="hidden" name="amount" value="${cri.amount}" />
					<input type="hidden" name="type" value="${cri.type}" />
					<input type="hidden" name="keyword" value="${cri.keyword}" />
				</form>
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw">댓글
					<button class="btn btn-primary btn-xs pull-right" id="addReplyBtn">댓글 등록</button>
				</i>
			</div>
			<div class="panel-body">
				<ul class="chat">
					<li class="left clearfix" data-rno="12">
						<div>
							<div class="header">
								<strong class="primary-font">user00</strong>
								<small class="pull-right text-muted">2023-04-02 13:13</small>
							</div>
							<p>잘했어요</p>
						</div>
					</li>
				</ul>
			</div>
			<div class='panel-footer'>

			</div>
		</div>
	</div>
</div>
<div id="modal">
	<div>
		<label for="">댓글</label>
		<input type="text" name="reply"/>
	</div>
	<div>
		<label for="">댓글작성자</label>
		<input type="text" name="replyer"/>
	</div>
	<div>
		<label for="">댓글일</label>
		<input type="text" name="replyDate"/>
	</div>
	<div>
		<button class='btn btn-primary' >수정</button>
		<button class='btn btn-danger' >삭제</button>
	</div>
</div>
<%@ include file="../includes/footer.jsp" %>
