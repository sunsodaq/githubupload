package com.izen.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.izen.service.BoardService;
import com.izen.vo.AttachFileDTO;
import com.izen.vo.BoardVO;
import com.izen.vo.Criteria;
import com.izen.vo.PageDTO;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/board/*")
@Slf4j
public class BoardController {
	@Autowired
	BoardService service;
	
	//p211 =>p214 test
	@GetMapping("/list")
	public String list(Model model,Criteria cri) {
		//cri.setAmount(5);
		System.out.println("컨트롤러:" +cri );
		List<BoardVO> list = service.getList(cri);
		list.forEach(i->log.info("여기 게시글이 넘어와야되는데?"+i));
		model.addAttribute("list", list);
		int total = service.getTotal(cri);
	//	cri.setAmount(5);		)
		model.addAttribute("pageMaker", new PageDTO(cri,total));//총데이터의 갯수가 123개 
		return "board/list";
		//views아래에 board 폴더 생성후 list.jsp 만들어주세요 
	}
	@GetMapping("/register")
	public String registerGet() {
		return "board/register";
	}
	//p216
	@PostMapping("/register")
	public String register(BoardVO vo, RedirectAttributes rttr) {
		log.info("컨틀롤러 등록:" +vo);
		service.register(vo);
		//p565
		if(vo.getAttachList()!=null) vo.getAttachList().forEach(i->System.out.println(i));
		System.out.println("================");
		//rttr.addFlashAttribute("result",vo.getBno());//나중에 댓글 등록할떄 사용함 
		return "redirect:/board/list";

	}
	//p259
	@GetMapping({"/get","/modify"})
	public void get(Long bno , Model model ,  Criteria cri) {//pageNum=7&amount=10
		log.info("get 또는  modify "+bno);
		model.addAttribute("board",service.get(bno));
		model.addAttribute("cri", cri);
	}
	//P219
	@PostMapping("/modify")
	public String modify(BoardVO vo , RedirectAttributes rttr, Criteria cri) {
		log.info("컨트롤러에서 수정:" +vo);
		if(service.modify(vo)) rttr.addFlashAttribute("result", "success");
		rttr.addAttribute("pageNum",cri.getPageNum());
		rttr.addAttribute("amount",cri.getAmount());
		rttr.addAttribute("keyword",cri.getKeyword());
		rttr.addAttribute("type",cri.getType());
		return "redirect:/board/list";
		
	}
	private void deleteFiles(List<AttachFileDTO> attachList) {
		if(attachList ==null || attachList.size()==0) return ;
		log.info("delete attach files ............. ");
		log.info(""+ attachList);
		attachList.forEach(i->{
			try {
				//java.nio로 import 
				Path file = Paths.get("c:\\upload\\"+i.getUploadPath() + "\\" + i.getUuid()+"_"+i.getFileName());
				Files.deleteIfExists(file);
				if(Files.probeContentType(file).startsWith("image")) {//이미지일경우 원래 이미지와 thumbnail 이미지 삭제 
					Path thumbnail =
							Paths.get("c:\\upload\\"+i.getUploadPath() + "\\s_" + i.getUuid()+"_"+i.getFileName());
					Files.delete(thumbnail);
				}
			} catch (Exception e) {
				log.error("delete file error"+ e.getMessage());
			}
		});
	}	
	//p220
	@PostMapping("/remove")
	public String remove(Long bno , RedirectAttributes rttr, Criteria cri) {
		log.info("컨트롤러 삭제:" +bno);
		//서비스 로 갑니다 
		List<AttachFileDTO> attachList = service.getAttachList(bno);
		if(service.remove(bno)) {
			deleteFiles(attachList);// 파일서버의 내용을 삭제 
			rttr.addFlashAttribute("result","success");
		}
		rttr.addAttribute("pageNum",cri.getPageNum());
		rttr.addAttribute("amount",cri.getAmount());
		rttr.addAttribute("keyword",cri.getKeyword());
		rttr.addAttribute("type",cri.getType());
		return "redirect:/board/list";
	}
	//p570
	@GetMapping(value = "/getAttachList" ,produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> getAttachList(Long bno){
		log.info("컨트롤러에서의 첨부파일 가져오기 bno: " +bno);	
		service.getAttachList(bno).forEach(i->log.info("i"+i));
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
	}

	
	
	
	
	
	
	
}
