package com.izen.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.izen.vo.BoardVO;
import com.izen.vo.Criteria;

public interface BoardMapper {
	public List<BoardVO> getList();
	//p294(페이지 단위로 데이터 조회
	public List<BoardVO> getListWithPaging(Criteria cri);
	
	public int insert(BoardVO vo);
	//p190
	public void insertSelectKey(BoardVO vo);
	//p193
	public BoardVO read(Long bno);
	//p194
	public int delete (Long bno);
	//p196
	public int update(BoardVO vo);
	//p322
	public int getTotalCount(Criteria cri);//전체 데이터의 갯수 처리 
	//p482
	public void updateReplyCnt(@Param("bno") Long bno ,@Param("amount") int amount);
	
}
