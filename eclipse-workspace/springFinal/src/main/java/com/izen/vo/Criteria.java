package com.izen.vo;

import org.springframework.web.util.UriComponentsBuilder;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

//@AllArgsConstructor
//@NoArgsConstructor
@Getter
@Setter
@ToString
public class Criteria {
	private int pageNum; // 현재 페이지
	private int amount; // 페이지 당 몇개씩 출력
	// 검색하기 위한 멤버변수 선언
	private String type; // TCW, TC, C, T 
	private String keyword; // 입력하는 문자열
	
	// localhost:8080/board/get?pageNum=3&amount=7
	public Criteria() {
		this(1,10);
	}
	public Criteria(int pageNum, int amount) {
		this.pageNum=pageNum;
		this.amount=amount;
	}
	// 문자열 반환
	public String[] getTypeArr() {
		// type 이 null 이면 빈 문자열 배열을 반환하고 그렇지 않으면 문자열을 공백으로 잘라서 반환
		// TC = ["T","C"] 
		return type == null? new String[] {}: type.split("");
	}
	//p580
	public String getListLink() {
		UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
				.queryParam("pageNum", this.pageNum)
				.queryParam("amount", this.amount)
				.queryParam("type", this.type)
				.queryParam("keyword", this.keyword);
			return builder.toString();
	}
	
}
