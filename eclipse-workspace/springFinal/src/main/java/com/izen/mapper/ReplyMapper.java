package com.izen.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.izen.vo.Criteria;
import com.izen.vo.ReplyVO;

public interface ReplyMapper {
	public int insert(ReplyVO vo);
	public List<ReplyVO> list();
	public ReplyVO read(Long rno);
	public int delete(Long rno);
	public int update(ReplyVO vo);
	//p388
	public List<ReplyVO> getListWithPaging(@Param("cri") Criteria cri,@Param("bno") Long bno);
	//p432
	public int getCountByBno(Long bno);
}
