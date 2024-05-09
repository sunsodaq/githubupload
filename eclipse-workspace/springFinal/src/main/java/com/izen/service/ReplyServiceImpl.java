package com.izen.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.izen.mapper.BoardMapper;
import com.izen.mapper.ReplyMapper;
import com.izen.vo.Criteria;
import com.izen.vo.ReplyPageDTO;
import com.izen.vo.ReplyVO;

@Service
public class ReplyServiceImpl implements ReplyService {
	@Autowired
	private ReplyMapper mapper;
	
	@Autowired 
	private BoardMapper boardMapper;

	@Transactional // 원자(atomic)으로 처리하면 하나라도 되면되는 것이고 하나라도 안되는 다 안되는것이다 
	@Override
	public int register(ReplyVO vo) {
		System.out.println("댓글 서비스 등록 " +vo);
		boardMapper.updateReplyCnt(vo.getBno(), 1);
		return mapper.insert(vo);
	}

	@Override
	public ReplyVO get(Long rno) {
		System.out.println("댓글 서비스 하나 조회 " +rno);
		return mapper.read(rno);
	}

	@Override
	public int modify(ReplyVO vo) {
		System.out.println("댓글 서비스 수정 " +vo);
		return mapper.update(vo);
	}

	@Transactional
	@Override
	public int remove(Long rno) {
		System.out.println("댓글 서비스 삭제 " +rno);
		ReplyVO vo =mapper.read(rno);
		boardMapper.updateReplyCnt(vo.getBno(),-1);
		return mapper.delete(rno);
	}

	@Override
	public List<ReplyVO> getList(Criteria cri, Long bno) {
		System.out.println("댓글 서비스 전체 조회 : cri " +cri +", bno: " +bno);
		return mapper.getListWithPaging(cri, bno);
	}



	@Override
	public ReplyPageDTO getListPage(Criteria cri, Long bno) {
		List<ReplyVO> list = mapper.getListWithPaging(cri, bno);
		int cnt = mapper.getCountByBno(bno);
		return   new ReplyPageDTO(cnt, list) ;//댓글의 갯수와 댓글 목록을 페이지 단위로 가지고 다님 
	}

}
