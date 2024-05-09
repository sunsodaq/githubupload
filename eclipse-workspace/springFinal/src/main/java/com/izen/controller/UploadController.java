package com.izen.controller;



import java.io.File;
import java.io.FileOutputStream;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.izen.vo.AttachFileDTO;

import lombok.extern.slf4j.Slf4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Slf4j
public class UploadController {


	//p500
	@GetMapping("/uploadAjax")
	public void uploadAjax() {
		log.info("upload ajax controller....");
	}
	
	//p508
	private String getFolder() {//오늘 날짜를 이용하여 폴더를 생성하는 함수 
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		return str.replace("-", File.separator);
	}
	//p513
	private boolean checkImageType(File file) {
		try {
			//probe(조사하다) 
			String contentType= Files.probeContentType(file.toPath());
			boolean isImageType = contentType.startsWith("image");
			System.out.println("여기에서 isImageType이 false가 나올듯 "+isImageType);
			return isImageType;// 문자열이 image로 시작하면 file이 image 타입 
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		return false;
	}
	@PostMapping(value="/uploadAjaxAction",produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile ,Model model) {
		List<AttachFileDTO> list =new ArrayList<>();
		log.info("uploadform post");
		String uploadFolder = "c:\\upload";
		String uploadFolderPath= getFolder();
		File uploadPath=new File(uploadFolder, uploadFolderPath);
		for ( MultipartFile m: uploadFile) {
			log.info("==================");
			String uploadFilename = m.getOriginalFilename();
			AttachFileDTO attachDto = new AttachFileDTO();
			//p511 UUID 적용 (고유한 번호 발생기 ,자바) 
			UUID uuid = UUID.randomUUID();
			String uuidUploadFilename =uuid.toString()+"_" +uploadFilename;
			log.info("uploadFile name:"+ uploadFilename);
			log.info("upload filesize:"+ m.getSize());
			if(uploadPath.exists()==false)  uploadPath.mkdirs();//폴더가 없으면 폴더 생성 
			File saveFile =new File(uploadPath,uuidUploadFilename);
			try {
				//파일은 객체이고 stream을 이진수의 조합이므로 네트워크로 데이터를 전송하기 위해서는 stream으로 변경 
				m.transferTo(saveFile);//저장
				attachDto.setUuid(uuid.toString());
				attachDto.setUploadPath(uploadFolderPath);
				attachDto.setFileName(uploadFilename);
				if(checkImageType(saveFile)) {
					attachDto.setImage(true);
					System.out.println("attachDto내에 image가 ture가 되어야됨 " +attachDto);
					//thumnail image의 파일명을  s_를 앞에 붙여서 관리					
					FileOutputStream thumbnail =new FileOutputStream(new File(uploadPath,"s_"+uuidUploadFilename));
					Thumbnailator.createThumbnail(m.getInputStream(), thumbnail, 100,100);
					thumbnail.close();
				}
				list.add(attachDto);
			}catch(Exception e) {
				log.error(e.getMessage());
			}
		}
		return new ResponseEntity<>(list,HttpStatus.OK);
	}
	//p526 
	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName){	//파일명 을 받아서 이미지를 byte의 배열형태로 변환하여 반환  
		log.info("display , fileName:" +fileName);
		File file = new File("c:\\upload\\"+fileName);
		log.info("file:"+file);
		ResponseEntity<byte[]> result =null;
		try {
			HttpHeaders header = new HttpHeaders();//header에 어떤 형태의 type인지를 같이 정보를 전송함 
			//그래야 브라우저가  판단하여 화면에 출력함 
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result =new ResponseEntity<>(FileCopyUtils.copyToByteArray(file),header, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return result;
	}
	//p531 
	@GetMapping(value="/download",produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(String fileName){
		log.info("download fileName:" +fileName);
		FileSystemResource resource = new FileSystemResource("c:\\upload\\"+ fileName);
		log.info("resource:"+resource);
		String resourceName = resource.getFilename();
		HttpHeaders headers =new HttpHeaders();
		try {
			headers.add("Content-Disposition", 
					"attachment; filename=" +new String(resourceName.getBytes("UTF-8"),"ISO-8859-1")
					);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseEntity<>(resource,headers, HttpStatus.OK);
	}
	//p548
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type){
		log.info("delete file : " +fileName);
		File file;
		try {
			file = new File("c:\\upload\\" +URLDecoder.decode(fileName,"UTF-8"));
			file.delete();
			if(type.equals("image")) {//이미지일경우 원래 이미지와 thumbnail 이미지 삭제 
				String largeFileName= file.getAbsolutePath().replace("s_", "");
				log.info("large name:" + largeFileName);
				file =new File(largeFileName);
				file.delete();
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity<>("deleted", HttpStatus.OK);
	}
	

}
