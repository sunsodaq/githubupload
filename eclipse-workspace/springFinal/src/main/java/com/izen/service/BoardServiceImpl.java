package com.izen.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.izen.mapper.BoardAttachMapper;
import com.izen.mapper.BoardMapper;
import com.izen.vo.AttachFileDTO;
import com.izen.vo.BoardVO;
import com.izen.vo.Criteria;

@Service
public class BoardServiceImpl implements BoardService{
	@Autowired
	private BoardMapper mapper;
	
	@Autowired
	private BoardAttachMapper boardAttachMapper;//추가 

	@Transactional
	@Override
	public void register(BoardVO vo) {
		System.out.println("서비스 등록:" +vo);
		mapper.insertSelectKey(vo);		//게시글 등록과 
		//p567
		if(vo.getAttachList() ==null || vo.getAttachList().size()<=0) return ;
		vo.getAttachList().forEach(i->{
			//여기는 첨부파일 db에 저장되는지 확인 
			i.setBno(vo.getBno());//bno를 채우고
			boardAttachMapper.insert(i);//db에 저장 . 첨부파일 추가가 동시에 이루어지던지 그렇지 않던지
			//transactional 
		});
	}

	@Override
	public BoardVO get(Long bno) {
		System.out.println("서비스 데이터 하나 조회 :" +bno);
		return mapper.read(bno);
	}

	@Transactional
	@Override
	public boolean modify(BoardVO vo) {
	    System.out.println("서비스 데이터 수정 :" + vo);
	    

	    boardAttachMapper.deleteAll(vo.getBno());
	    
	    System.out.println("여기에 수정이 들어오는가 100)");
	    
	    boolean modifyResult = mapper.update(vo) == 1;
	    
	    List<AttachFileDTO> list = vo.getAttachList();
	    if (modifyResult && list != null && !list.isEmpty()) {
	        System.out.println("여기에 수정이 들어오는가 200) if ");
	        for (AttachFileDTO attachment : list) {
	            attachment.setBno(vo.getBno());
	            boardAttachMapper.insert(attachment);
	            System.out.println("여기에 수정이 들어오는가  300) insert ");
	        }
	    }
	    
	    return modifyResult;
	}

	@Transactional
	@Override
	public boolean remove(Long bno) {
		System.out.println("서비스 삭제 :" +bno);
		//p579
		boardAttachMapper.deleteAll(bno);
		return mapper.delete(bno)==1;//삭제가  하나되었다라는 것을 알려준다 
		//삭제되지 않으면 0을 반환 
	}

//	@Override
//	public List<BoardVO> getList() {
//		System.out.println("서비스 에서 데이터 전체 조회 ");
//		return mapper.getList();
//	}

	@Override
	public List<BoardVO> getList(Criteria cri) {
		System.out.println("서비스 에서 데이터 페이지 단위로 조회 :   " +cri);
		return mapper.getListWithPaging(cri);
	}

	@Override
	public int getTotal(Criteria cri) {
		
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<AttachFileDTO> getAttachList(Long bno) {
		//p59
		System.out.println("서비스에서 첨부파일 목록 가져오기 " +bno);
		return boardAttachMapper.findByBno(bno);
	}

}
