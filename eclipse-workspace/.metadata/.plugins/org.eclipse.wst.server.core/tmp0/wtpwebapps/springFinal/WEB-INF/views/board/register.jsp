<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ include file="../includes/header.jsp" %>
<script>
    $(document).ready(function(){
    	var formObj= $("form[role='form']")
        $("button[type='submit']").click(function(e){
            e.preventDefault();
            console.log('전송 버튼이 눌렸어요')
            //p564
            var str=""
            $(".uploadResult ul li").each(function(idx, obj){
            	var jobj= $(obj)
            	console.dir(jobj)
            	var fileName= jobj.data('filename')
            	var uuid= jobj.data('uuid')            	
            	var path= jobj.data('path')
            	var type = jobj.data('type')
            	console.log(fileName, uuid, path, type)
            	str+= "<input type='text' name='attachList["+idx+"].fileName' value='"+fileName+"'>"
				str+= "<input type='text' name='attachList["+idx+"].uuid' value='"+uuid+"'>"
				str+= "<input type='text' name='attachList["+idx+"].uploadPath' value='"+path+"'>"
				str+= "<input type='text' name='attachList["+idx+"].image' value='"+type+"'>"
            })
            formObj.append(str).submit()
        })
        //p506
		var regex= new RegExp("(.*?)\.(exe|sh|zip|alz)$")//정규 표현식 공부 
		var maxSize= 5242880//5MB, 5x1024x1024 ,1k= 1024
		const checkExtension =(fileName ,fileSize)=>{
			if(fileSize>=maxSize){
				alert("파일 크기 초과")
				return
			}
			if(regex.test(fileName)){
				alert("해당 종류의 파일은 업로드 할수 없어요")
				return
			}
			return true
		}
		var cloneObj= $(".uploadDiv").clone()
		$(".uploadResult").on("click","button", function(e){
			console.log("삭제 버튼이 눌렸어요")
			var targetFile =$(this).data("file")
			var type= $(this).data("type")
			console.log(targetFile)
			var targetLi = $(this).closest("li")//가장 가까운  li 태그를 찾아라 
			$.ajax({
				url:'/deleteFile',
				data:{fileName:targetFile, type},
				dataType:'text',
				type:'post',
				success:function(result){
					alert(result)
					targetLi.remove()
				}
			})
		})
		$("input[type='file']").change(function(e){
			var formData= new FormData()
			var inputFile= $("input[name='uploadFile']")
			var files= inputFile[0].files
			console.log(files)
			for (var i = 0; i < files.length; i++) {
				if(!checkExtension(files[i].name,files[i].size)) return false
				formData.append("uploadFile",files[i])
			}
			
			var uploadResult= $(".uploadResult ul")
			//p537 참고
			const showUploadedFile=(uploadResultArr)=>{
				if(!uploadResultArr || uploadResultArr.length ==0) return
				var str=""
				$(uploadResultArr).each(function(idx, obj){ //p525
					console.log(obj)
					if(obj.image) { // 이미지가 맞으면 아래 실행
						var fileCallPath = encodeURIComponent(obj.uploadPath+ "/s_"+obj.uuid+"_"+obj.fileName)
						var originPath = obj.uploadPath+ "/"+obj.uuid+"_"+obj.fileName
						originPath = originPath.replace(new RegExp(/\\/g), "/")  // "\\" => "/"  로 대체한다 (global)
						str+= "<li data-path='"+obj.uploadPath+"'data-uuid='"+obj.uuid+"' data-fileName='"
							+obj.fileName+"'data-type='"+obj.image+"'"
						str+= "><div><span>"+obj.fileName+"</span><button type='button' data-file=\'"
							+fileCallPath+"\' data-type='image' "
						str+= "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>"
						str+= "<img src='/display?fileName=" + fileCallPath +"'></div></li>"
					} else { // 이미지가 아니면 아래 실행
						var fileCallPath = encodeURIComponent(obj.uploadPath+ "/"+obj.uuid+"_"+obj.fileName)
						var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/")
						str+= "<li data-path='"+obj.uploadPath+"'data-uuid='"+obj.uuid+"' data-fileName='"+obj.fileName+
						"'data-type='"+obj.image+"'"
						str+= "><div><span>"+obj.fileName+"</span><button type='button' data-file=\'"
						+fileCallPath+"\' data-type='file' "
						str+= "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button></br>"
						str+= "<img src='/resources/img/attach.jpg'></div></li>"
					}
				})
				uploadResult.append(str)
			}
			$.ajax({
				url: '/uploadAjaxAction',
				processData: false,
				contentType: false,
				data: formData,
				type: 'POST',
				dataType: 'json',
				success: (result)=>{
					//alert("업로드 성공")
					console.log("업로드 성공", result)
					showUploadedFile(result) // 추가2
					//p521 , 이미지를 계속 반복해서 추가가능
					//$(".uploadDiv").html(cloneObj.html())
				}
			}) // ajax
		}) // button[type='file'] click
		$(".uploadResult").on("click","button", function(e) { ///// 변경
			console.log("이미지 삭제")
			var targetFile = $(this).data('file')
			var type= $(this).data('type')
			console.log(targetFile)
			var targetLi = $(this).closest("li")
			
			$.ajax({
				url: '/deleteFile',
				data: {fileName: targetFile, type:type},
				dataType: 'text',
				type: 'POST',
				success: (result)=>{
					alert(result)
					targetLi.remove()
				}
			}) // ajax
		}) // uploadResult click
		

    })
</script>
			<div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">게시글 등록</h1>
                </div>
            </div>		
            <!-- End of Main Content -->
            <!-- p239 -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">게시글 등록</div>
                        <div class="panel-body">
                            <form action="/board/register" method="post" role='form'>

                                <div class="form-group">
                                    <label for="">제목</label>
                                    <input type="text" class="form-control" name="title"/>
                                </div>
                                <div class="form-group">
                                    <label for="">내용</label>
                                    <textarea  id="" class="form-control" rows="5" name="content"></textarea>
                                </div>
                                <div class="form-group">
                                    <label for="">작성자</label>
                                    <input type="text" class="form-control" name="writer"/>
                                </div>
                                <button type="submit" class="btn btn-default">등록</button>
                                <button type="reset" class="btn btn-default">취소</button>
                            </form>
                        </div> <!-- panel body-->
                    </div> <!-- panel-->
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            파일 첨부
                        </div>
                        <div class="panel-body">
                            <div class="form-group uploadDiv">
                                <input type="file" name="uploadFile" multiple>
                            </div>
                            <div class="uploadResult">
                                <ul></ul>
                            </div>
                        </div> <!-- panel-body  -->
                    </div> <!-- panel-default  --> 
                </div> <!-- col-lg-12  --> 
            </div> <!-- row  -->  
<%@ include file="../includes/footer.jsp" %>
