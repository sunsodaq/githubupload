package com.izen.mapper;

import java.util.List;

import com.izen.vo.AttachFileDTO;

public interface BoardAttachMapper {
	public int insert(AttachFileDTO vo);
	public int delete (String uuid);
	public List<AttachFileDTO> findByBno(Long bno);
	public List<AttachFileDTO> list();
	//p578
	public void  deleteAll(Long bno);
}
