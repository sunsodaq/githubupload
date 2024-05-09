package com.izen.persistence;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.izen.mapper.BoardAttachMapper;
import com.izen.vo.AttachFileDTO;

import lombok.extern.slf4j.Slf4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(
	"file:src/main/webapp/WEB-INF/spring/root-context.xml"
)
@Slf4j
public class AttachMapperTests {
	@Autowired
	private BoardAttachMapper mapper;
	
	
	//@Test
	public void imageVeryStrange() {
		mapper.insert(new AttachFileDTO("FFvcxzv", "BBfdas", "CCasdf", true, 108L ));
	}
	
	@Test
	public void imageList() {
		mapper.list();
	}
	
	    
	
}
