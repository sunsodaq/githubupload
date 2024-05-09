package com.izen.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;


@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@ToString
public class ReplyVO {
	 private Long rno;
	 private Long   bno;
	 private String reply;
	 private String   replyer;
	 private Date   replyDate; 
	 private Date   updateDate ;
}
