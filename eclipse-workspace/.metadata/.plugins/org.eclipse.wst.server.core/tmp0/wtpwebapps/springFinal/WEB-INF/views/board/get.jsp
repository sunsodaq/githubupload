<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="../includes/header.jsp" %>
<style>
	.uploadResult {
		width: 100%;
		background-color: gray;
	}
	.uploadResult ul {
		display: flex;
		flex-flow: row;
		justify-content: center;
		align-items: center;
	}
	/* p543 수정 */ 
	.uploadResult ul li {
		list-style: none;
		padding: 10px;
		align-content: center;
		text-align: center;
	}
	.uploadResult ul li img {
		width: 100%;
	}
	.uploadResult ul li span {
		color: white;
	}
	.bigPictureWrapper {
		position: absolute;
		display: none;
		justify-content: center;
		align-items: center;
		top: 0%;
		width: 100%;
		height: 100%;
		background-color: gray;
		z-index: 100;
		background: rgba(255,255,255,0.5)
	}
	.bigPicture {
		position: relative;
		display: flex;
		justify-content: center;
		align-items: center;
	}
	.bigPicture img {
		width: 600px;
	}
</style>
<script type="text/javascript" src="/resources/js/re.js"></script>
<script>

const showImage=(fileCallPath)=>{
	console.log("fileCallPath",fileCallPath)
	//alert(fileCallPath)
	// p544
	 $(".bigPictureWrapper").css("display","flex").show();
     $(".bigPicture").html("<img src='/display?fileName=" +fileCallPath+"'>")
    		.animate({width:'100%',height:'100%'},1000);
}
	$(document).ready(function(){
		//p570
		(function(){
			var bno = '<c:out value="${board.bno}"/>'
			$.getJSON("/board/getAttachList",{bno}, (arr)=>{console.log(arr)
				var str=""
				$(arr).each(function(idx, obj){ //p525
					if(obj.fileType) { // 이미지가 맞으면 아래 실행
						console.log("이미지 ")
						var fileCallPath = encodeURIComponent(obj.uploadPath+ "/s_"+obj.uuid+"_"+obj.fileName)
						var originPath = obj.uploadPath+ "/"+obj.uuid+"_"+obj.fileName
						originPath = originPath.replace(new RegExp(/\\/g), "/")  // "\\" => "/"  로 대체한다 (global)
						str+= "<li data-path='"+obj.uploadPath+"'data-uuid='"+obj.uuid+"' data-fileName='"+obj.fileName+"'data-type='"+obj.image+"'"
						str+= "><div><span>"+obj.fileName+"</span><button type='button' data-file=\'"+fileCallPath+"\' data-type='image' "
						str+= "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>"
						str+= "<img src='/display?fileName=" + fileCallPath +"'></div></li>"
					} else { // 이미지가 아니면 아래 실행
						var fileCallPath = encodeURIComponent(obj.uploadPath+ "/"+obj.uuid+"_"+obj.fileName)
						var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/")
						str+= "<li data-path='"+obj.uploadPath+"'data-uuid='"+obj.uuid+"' data-fileName='"+obj.fileName+"'data-type='"+obj.image+"'"
						str+= "><div><span>"+obj.fileName+"</span><button type='button' data-file=\'"+fileCallPath+"\' data-type='file' "
						str+= "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button></br>"
						str+= "<img src='/resources/img/attach.jpg'></div></li>"
					}
				})
				$(".uploadResult ul").append(str)
			
			})
		})()//end function
		$(".uploadResult").on("click","li", function(e) {
			console.log("이미지 보기")
			var liObj = $(this)
			var path= encodeURIComponent(liObj.data("path")+"/" +liObj.data("uuid") +"_" +liObj.data("filename"))
			console.log("path: " , path)
			console.log("type: " , liObj.data('type')) //type=true
            if(liObj.data('type')) showImage(path.replace(new RegExp(/\\/g),"/"))
			else self.location ="/download?fileName="+path
			
			
		}) // uploadResult click
		console.log('replyService',replyService)
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
		
		replyPageFooter.on("click","li a", function(e){
			e.preventDefault()
			console.log("페이지를 클릭")
			
			var targetPageNum = $(this).attr("href")
			console.log("targetPageNum : "+ targetPageNum)
			pageNum = targetPageNum
			showList(pageNum)
		})
		
		console.log("JS TEST.....")
		var bnoValue = '<c:out value="${board.bno}"/>'
		console.log("bno: " + bnoValue)
		
		//showList(1)
		showList(-1) // 마지막 페이지이면 -1 로 설정 (p438) 하단
		
		var modal=$(".modal")
		var modalInputReply = modal.find("input[name='reply']")
		var modalInputReplyer = modal.find("input[name='replyer']")
		var modalInputReplyDate = modal.find("input[name='replyDate']")
		
		var modalModBtn = $("#modalModBtn")
		var modalRemoveBtn = $("#modalRemoveBtn")
		var modalRegisterBtn = $("#modalRegisterBtn")
		
		$("#addReplyBtn").click(function(e){
			modal.find("input").val("")
			modalInputReplyDate.closest("div").hide() // 가장 가까운 div 를 찾아 감춘다
			modal.find("button[id !='modalCloseBtn']").hide() // id 가 modalCloseBtn 이 아닌것을 찾아 감춘다
			
			modalRegisterBtn.show();
			$(".modal").modal("show")
		})
		//p423
		modalRegisterBtn.click(function(e){
			var reply = {
					reply: modalInputReply.val(),
					replyer:modalInputReplyer.val(),
					bno:bnoValue
			}
			console.log("댓글 등록: ", reply)
			replyService.add(reply, (result)=>{
				alert(result)
				modal.find("input").val("")
				modal.modal("hide")
				
				showList(1)
			})
		})
		//p425
		$(".chat").on("click","li", function(e){
			console.log($(this))
			// 해당이 아닌 제일 위에것
			var rno= $(this).data("rno")
			console.log(rno)
			replyService.get(rno, (reply)=>{ // 데이터 하나 조회하여 modal의 input 태그 에 출력함
				modalInputReply.val(reply.reply)
				modalInputReplyer.val(reply.replyer)
				modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly", "readonly")
				modal.data("rno", reply.rno)
				
				modal.find("button[id !='modalCloseBtn']").hide()
				modalModBtn.show()
				modalRemoveBtn.show()
				
				$(".modal").modal("show")
			})
		})
		//p426 수정
		modalModBtn.click(function(e){
			console.log("수정 버튼이 눌렸어요")
			var reply={rno:modal.data("rno"), reply: modalInputReply.val()}
			console.log("reply: ",reply)
			replyService.update(reply, (result)=>{
				alert(result)
				modal.modal("hide")
				showList(1)
			})
		})
		//p427 삭제
		modalRemoveBtn.click(function(e){
			console.log("삭제 버튼이 눌렸어요")
			var rno = modal.data("rno")
			console.log("rno: ", rno)
			replyService.remove(rno, (result)=>{
				alert(result)
				modal.modal("hide")
				showList(1)
			})
		})
		// 수정, 추가는 정보를 담아서 보내야 되니까 객체로 담아서 보내고
		// 삭제, 조회, 댓글삭제는 rno 만 보내면 되는데
		// 댓글 조회 같은 경우는 bno 와 같이 보내야 하니 bno, rno 같이 보내야 한다
		var operForm =$("form")
		$("button[data-oper='modify']").click(function(e){
			e.preventDefault()
			console.log($(this).attr("data-oper"))
			var bno=$("#form-control").eq(0).val()
			operForm.attr("action", "/board/modify?bno="+bno).attr("method","get").submit();
		})
		$("button[data-oper='list']").click(function(e){
			e.preventDefault()
			console.log($(this).attr("data-oper"))
			operForm.attr("action", "/board/list")
				.empty()
				.attr("method","get").submit();
			// empty => form 태그의 내용을 다 비워라
		})
	})
</script>
                <!-- Begin Page Content -->
                <div class="container-fluid">

                    <!-- Page Heading -->
                    <h1 class="h3 mb-2 text-gray-800" style="text-align:center">게시글 조회</h1>
                    <p class="mb-4">DataTables is a third party plugin that is used to generate the demo table below.
                        For more information about DataTables, please visit the <a target="_blank"
                            href="https://datatables.net">official DataTables documentation</a>.</p>

                    <!-- DataTables Example -->
                    <div class="card shadow mb-4" style="text-align:center">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">게시글 조회</h6>
                        </div>

                        <div class="card-body">
                        	<form action="#" role="form" method="post">
                        	    <div class="form-group">
                        			<label>번호</label> <input class="form-control" name='bno' value='${board.bno}' readonly/>
                        		</div>
                        		<div class="form-group">
                        			<label>제목</label> <input class="form-control" name='title' value='${board.title}' readonly/>
                        		</div>
                        		<div class="form-group">
                        			<label>내용</label>
                        			<textarea class="form-control" rows="3" name='content' readonly>${board.content}</textarea>
                        		</div>
                        		<div class="form-group">
                        			<label>작성자</label> <input class="form-control" name='writer' value='${board.writer}' readonly/>
                        		</div>
                        		<button data-oper="modify" class="btn btn-primary">수정하러가기</button>
                        		<button data-oper="list" class="btn btn-info">목록으로이동</button>
                        		<!-- p345 4개의 정보를 hidden 으로 유지되도록 처리 -->
                        		<form id="operForm" action="/board/modify">
                        			<input type="hidden" id="bno" name="bno" value="${board.bno}"/>
                        			<input type="hidden" name="pageNum" value="${cri.pageNum}"/>
                        			<input type="hidden" name="amount" value="${cri.amount}"/>
                        			<input type="hidden" name="keyword" value="${cri.keyword}"/>
                        			<input type="hidden" name="type" value="${cri.type}"/>
                       			</form>
                        	</form>
                        </div>
						<div class="row">
							<div class="col-lg-12">
								<div class="panel-heading">
									<div class="panel-body">
										<div class="uploadResult">
											<ul>
											
											</ul>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="bigPictureWrapper">
							<div class="bigPicture">
								
							</div>
						</div>
                        <div class="row">
                        	<div class="col-lg-12">
                        		<div class="panel-heading">
                        			<i class="fa fa-comments fa-fw">댓글</i>
                        			<button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>댓글 등록</button>
                        		</div>
                        		<div class="panel-body">
                        			<ul class="chat">
                        				<!--  댓글 시작 -->
                        				<li class="left clearfix" data-rno="1">
                        					<div>
                        						<div class="header">
                        							<strong class="primary-font">user00</strong>
                        							<small class="pull-right text-muted">2023-03-14</small>
                        						</div>
                        						<p>참 잘했어요</p>
                        					</div>
                        				</li>
                        			</ul>
                        		</div>
                        		
                        		<div class="panel-footer">
                        		
                        		</div>
                        	</div>
                        </div>
                    </div>

                </div>
                <!-- /.container-fluid -->

            </div>
            <!-- End of Main Content -->
<!-- Button trigger modal -->
<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal">
  Launch demo modal
</button>

<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="myModalLabel">댓글 Modal</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div class="form-group">
        	<label>댓글</label>
        	<input class="form-control" name="reply" value="신규 댓글"/>
        </div>
        <div class="form-group">
        	<label>작성자</label>
        	<input class="form-control" name="replyer" value="댓글작성자"/>
        </div>
        <div class="form-group">
        	<label>입력일</label>
        	<input class="form-control" name="replyDate" value="댓글작성일"/>
        </div>
      </div>
      <div class="modal-footer">
        <button id="modalModBtn" type="button" class="btn btn-warning">수정</button>
        <button id="modalRemoveBtn" type="button" class="btn btn-danger">삭제</button>
        <button id="modalRegisterBtn" type="button" class="btn btn-secondary" data-dismiss="modal">등록</button>
        <button id="modalCloseBtn" type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>
<%@ include file="../includes/footer.jsp" %>