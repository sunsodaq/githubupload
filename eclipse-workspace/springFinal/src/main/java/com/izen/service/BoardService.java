package com.izen.service;

import java.util.List;

import com.izen.vo.AttachFileDTO;
import com.izen.vo.BoardVO;
import com.izen.vo.Criteria;

public interface BoardService {
	public void register(BoardVO vo);
	public List<BoardVO> getList(Criteria cri);
	public BoardVO get(Long bno);
	public boolean modify(BoardVO vo);
	public boolean remove(Long bno);
	//public List<BoardVO> getList();
	public int getTotal(Criteria cri);
	//p569
	public List<AttachFileDTO>  getAttachList(Long bno);
	
}
