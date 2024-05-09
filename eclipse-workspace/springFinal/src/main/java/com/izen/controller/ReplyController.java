
package com.izen.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.izen.service.ReplyService;
import com.izen.vo.Criteria;
import com.izen.vo.ReplyPageDTO;
import com.izen.vo.ReplyVO;

import lombok.extern.slf4j.Slf4j;

@RequestMapping("/replies/*")
@RestController
@Slf4j
public class ReplyController {

	@Autowired
	private ReplyService service;
	
	@PostMapping(value="/new", consumes = "application/json",
			produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> create(@RequestBody ReplyVO vo){
		log.info("replyvo:"+ vo);
		int insertCount = service.register(vo);
		log.info("댓글 추가된 갯수:" + insertCount);
		//댓글이 추가되면  FRONTEND에 success를 전송함 
		return insertCount==1?
				new ResponseEntity<>("success", HttpStatus.OK)
				:new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); 
	}
	
	//p395								{bno}/{page}
	//http://localhost:8080/replies/pages/1/6
	@GetMapping(value = "/pages/{bno}/{page}",			
			produces = {MediaType.APPLICATION_XML_VALUE,
					MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<ReplyPageDTO> getList(
			@PathVariable("page") int page,			
			@PathVariable("bno") Long bno) {
		log.info("페이지 컨트롤러:page:" +page +",bno:"+ bno);
		Criteria cri = new Criteria(page,10);
		log.info("cri:"+cri);		
		return new ResponseEntity<>(service.getListPage(cri, bno),HttpStatus.OK);
	}
	//p397
	@GetMapping(value= "/{rno}",
			produces = {MediaType.APPLICATION_XML_VALUE,
					MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno){
		log.info("댓글 조회 :rno"+rno);
		return new ResponseEntity<>(service.get(rno), HttpStatus.OK);
		
	}

	//p397
	@DeleteMapping(value = "/{rno}" ,produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> remove(@PathVariable("rno") Long rno){
		log.info("댓글 컨트롤러 삭제 ,rno=" + rno);
		return service.remove(rno)==1? new ResponseEntity<>("success",HttpStatus.OK):
			new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	@RequestMapping(method = { RequestMethod.PUT,
            RequestMethod.PATCH }, value = "/{rno}", consumes = "application/json", produces = {
                    MediaType.TEXT_PLAIN_VALUE })
    public ResponseEntity<String> modify(@RequestBody ReplyVO vo, @PathVariable("rno") Long rno) {

        vo.setRno(rno);

        return service.modify(vo) == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);

    }
	
}
