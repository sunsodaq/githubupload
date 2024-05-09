package com.izen.vo;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class ReplyPageDTO {//p433
	private int replyCnt; //댓글의 갯수
	private List<ReplyVO> list; //댓글들 
}
