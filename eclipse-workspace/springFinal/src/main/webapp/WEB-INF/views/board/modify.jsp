<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ include file="../includes/header.jsp" %>
<script>
	
	$(document).ready(function(){
		//p262
	    var formObj = $("form")
	    $("button").click(function(e){
	        e.preventDefault()
	        var operation = $(this).data("oper")
	        console.log(operation)
	        if(operation==='remove') formObj.attr("action","/board/remove")
	        else if(operation==='list' ){
	        	//self.location= "/board/list";
	        	formObj.attr("action","/board/list").attr("method","get")
	        	var pageNumTag= $("input[name='pageNum']").clone();//복제
	        	var amountTag= $("input[name='amount']").clone();//복제
	        	var keywordTag= $("input[name='keyword']").clone();//복제
	        	var typeTag= $("input[name='type']").clone();//복제
	        	
	        	formObj.empty()
	        	formObj.append(pageNumTag)
	        	formObj.append(amountTag)
	        	formObj.append(keywordTag)
	        	formObj.append(typeTag)
	        	//form 태그의 필요한 부분만 잠시 복사해서 보관해두고 form  태그 내용의 모든 내용은 지워버립니다. 
	        	//이후에 다시 필요한 태그만 추가해서  board/list를 호출하는 형태를 이용 
	        }
	        formObj.submit() //전송 
	    })
	})
    
</script>
			<div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">게시글 수정</h1>
                </div>
            </div>		
            <!-- End of Main Content -->
            <!-- p239 -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">게시글 수정</div>
                        <div class="panel-body">
                        	<form action="/board/modify" method="post">
                        		<input type="hidden" name="pageNum" value="${cri.pageNum}"/>
                               	<input type="hidden" name="amount" value="${cri.amount}"/>   
                               	<input type="hidden" name="type" value="${cri.type}"/>   
                               	<input type="hidden" name="keyword" value="${cri.keyword}"/>   
	                            <div class="form-group">
	                                <label for="">번호</label>
	                                <input type="text" class="form-control" name="bno" readonly value="${board.bno}"/>
	                            </div>
                                <div class="form-group">
                                    <label for="">제목</label>
                                    <input type="text" class="form-control" name="title" value="${board.title}" />
                                </div>
                                <div class="form-group">
                                    <label for="">내용</label>
                                    <textarea  id="" class="form-control" rows="5" name="content" >${board.content}</textarea>
                                </div>
                                <div class="form-group">
                                    <label for="">작성자</label>
                                    <input type="text" class="form-control" name="writer" value="${board.writer}" readonly/>
                                </div>
                                <div class="form-group">
                                    <label for="">등록일</label>
                                    <input type="text" class="form-control" name="regDate" 
                                        value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.regDate}"/>' readonly />
                                </div>
                                <div class="form-group">
                                    <label for="">수정일</label>
                                    <input type="text" class="form-control" name="updateDate" 
                                        value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.updateDate}"/>' readonly />
                                </div>
                                <button type="submit" data-oper="modify"  class="btn btn-default">수정</button>
                                <button type="submit" data-oper="remove"  class="btn btn-danger">삭제</button>
                                <button type="submit" data-oper="list" class="btn btn-info">목록</button>
                             </form>
                        </div>
                    </div>
                </div>
            </div>

<%@ include file="../includes/footer.jsp" %>
