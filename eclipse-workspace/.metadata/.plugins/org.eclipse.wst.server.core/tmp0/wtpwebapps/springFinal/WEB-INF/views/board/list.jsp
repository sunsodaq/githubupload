<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ include file="../includes/header.jsp" %>
<style>
	.active{
		background-color:red;
}
</style>
 <!-- p248 -->
            <script>
                $(document).ready(function(){
                	//등록하고 redirect 하면 modal이 보이고  redirect =>뒤로가기 시 모달 창을 보이지 않음 
                	const checkModal=(result)=>{
                        if(result==='' ||  history.state) return//hitory 상태 초기화 
                        if(parseInt(result)>0) {
                      	  console.log('여기 들어와야지 ', result)
                      	  $(".modal-body").html("게시글 " +parseInt(result) + "번이 등록되었어요")
                      	  $("#myModal").show()
                        }
                    }
                    var result = '<c:out value ="${result}"/>'
                    checkModal(result)
                    history.replaceState({},null,null)
                  
                    //새글 등록 버튼이 눌리면 
                    $("#regBtn").click(function(e){
                    	 self.location="/board/register"
                    })
                    //p312
                    var actionForm = $("#actionForm")
            		$(".paginate_button a").click(function(e){
            			e.preventDefault()
            			console.log("클릭")
            			actionForm.find("input[name='pageNum']").val($(this).attr("href"))
            			// form 태그의 요소의 자손의 input 태그의 속성이 name의 value가 pageNum 인 요소를 찾아서
            			// 현재 클릭된 a 태그(페이지 번호)의 href 의 값으로 세팅하라
            			actionForm.submit();
            		})
            		//p315
            		$(".move").click(function(e){
            			e.preventDefault()
            			actionForm.append("<input type='hidden' name='bno' value='"+$(this).attr("href")+"'>")
            			actionForm.attr("action","/board/get")
            			actionForm.submit()
            		})
                //p342
                var searchForm = $("#searchForm")
                $("#searchForm button").click(function(e){
                  var findSelected=  searchForm.find("option:selected").val()
                  var findKeyword=  searchForm.find("input[name='keyword']").val()
                  var pageNum=  searchForm.find("input[name='pageNum']").val()
                  if(!findSelected){
                    alert("검색 종류를 선택하세요")
                    return false
                  }
                  if(!findKeyword){
                    alert("키워드를 이력하세요")
                    return false
                  }
                  searchForm.find("input[name='pageNum']").val(pageNum)
                  e.preventDefault()
                  searchForm.submit()
                  
                })
                    $("button.close").click(function(e){
                    	console.log("모델 감추기 버튼이 눌렸어요")
                    	 $("#myModal").hide()
                    })
                     $(".modal-footer button").each(function(i,j){
                    	var u = $(j).text()
                    	//$("#myModal").hide()
                    	$(this).click(function(e){
                    		console.log("버튼이 눌렸어요" ,u)
                    	})
                    })
                    $("[data-dismiss='modal']").click(function(e){
                    	console.log("여기는 타입으로 속성 접근했어요")
                    })
                })
            </script>
                    <div style="text-align: center;" class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">게시판</h6>
                        </div>
                        <div class="panel-heading">테이블 목록
                            <button class="btn btn-success btn-xs float-right" id="regBtn">새글등록</button>
                        </div>
                    </div>
                      <div class='card-body'>
						<div class='table-responsive'>
							<table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th>#번호</th>
                                        <th>제목</th>
                                        <th>내용</th>
                                        <th>작성자</th>
                                        <th>작성일</th>
                                        <th>수정일</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${list}" var="board">
                                        <tr>
                                            <td><a href="${board.bno}" class="move"><b>${board.bno}</b></a></td>
                                            <td>${board.title} <b>[${board.replyCnt}]</b> </td>
                                            <td>${board.content}</td>
                                            <td>${board.writer}</td>
                                            <td><fmt:formatDate value="${board.regDate}" pattern="yyyy-MM-dd"/></td>
                                            <td><fmt:formatDate value="${board.updateDate}" pattern="yyyy-MM-dd"/></td>                                           
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            <form action="/board/list" id="searchForm">
                              <select name="type" id="">
                                <option value="" "${pageMaker.cri.type ==null?'selected':''}">--</option>
                                <option value="T" "${pageMaker.cri.type eq 'T' ?'selected':''}">제목</option>
                                <option value="C" "${pageMaker.cri.type eq 'C' ?'selected':''}" >내용</option>
                                <option value="W" "${pageMaker.cri.type eq 'W' ?'selected':''}" >작성자</option>
                                <option value="TC" "${pageMaker.cri.type eq 'TC' ?'selected':''}" >제목 또는 내용</option>
                                <option value="TW" "${pageMaker.cri.type eq 'TW' ?'selected':''}" >제목 또는 작성자</option>
                                <option value="TWC" "${pageMaker.cri.type eq 'TWC' ?'selected':''}">제목 또는 작성자 또는 내용</option>
                              </select>
                              <input type="text" name="keyword"/>
                              <input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}"/>
                              <input type="hidden" name="amount" value="${pageMaker.cri.amount}"/>
                              <button class="btn btn-default">검색</button>
                            </form>
                            <form action="/board/list" id="actionForm">
                                	<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}"/>
                                	<input type="hidden" name="amount" value="${pageMaker.cri.amount}"/>   
                                	<input type="hidden" name="type" value="${pageMaker.cri.type}"/>   
                                	<input type="hidden" name="keyword" value="${pageMaker.cri.keyword}"/>   
                            </form>
                            <div class="pull-right">
                              <ul class="pagination">
                                <c:if test="${pageMaker.prev}">
                                  <li class="paginate_button previous">
                                    <a href="${pageMaker.startPage-1}">이전</a>
                                  </li>
                                </c:if>
                                <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                                  <li class='paginage_button ${pageMaker.cri.pageNum ==num ? "active":""}'>
                                    <a href="/board/list?pageNum=${num}">${num}</a>
                                  </li>
                                </c:forEach>
                                <c:if test="${pageMaker.next}">
                                  <li class="paginate_button next">
                                    <a href="${pageMaker.endPage+1}">다음</a>
                                  </li>
                                </c:if>
                              </ul>
                            </div>
                            <div class="modal" id="myModal" tabindex="-1" role="dialog">
                                <div class="modal-dialog" role="document">
                                  <div class="modal-content">
                                    <div class="modal-header">
                                      <h5 class="modal-title">Modal title</h5>
                                      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                      </button>
                                    </div>
                                    <div class="modal-body">
                                      <p>Modal body text goes here.</p>
                                    </div>
                                    <div class="modal-footer">
                                      <button type="button" class="btn btn-primary">변경 적용</button>
                                      <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                                    </div>
                                  </div>
                                </div>
                              </div>
						</div>
						</div>
            <!-- End of Main Content -->
           
<%@ include file="../includes/footer.jsp" %>
