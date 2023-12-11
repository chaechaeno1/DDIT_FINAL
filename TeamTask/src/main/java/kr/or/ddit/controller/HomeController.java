package kr.or.ddit.controller;

import java.util.List;

import javax.inject.Inject;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.IAcademyService;
import kr.or.ddit.vo.AcademyVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class HomeController {

	@Inject
	private IAcademyService academyService;

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home() {
		return "home";
	}

	@ResponseBody
	@RequestMapping(value = "/treelist.do", method = RequestMethod.POST)
	public List<AcademyVO> jqAcademyTree(AcademyVO academyVO) {
		List<AcademyVO> academyList = academyService.getAcademyTree();
		return academyList;
	}

	// 추가 기능
	@ResponseBody
	@RequestMapping(value = "/treecreate.do", method = RequestMethod.POST)
	public ResponseEntity<String> jqAcademyTreeCreate(@RequestBody AcademyVO academyVO) {
		log.info("jqAcademyTreeCreate() 실행...!");		
		academyService.createAcademyTree(academyVO);
		return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
	}
	

	//아이디 갯수
	@ResponseBody
	@RequestMapping(value = "/countId.do", method=RequestMethod.POST)
	public int countId(@RequestBody AcademyVO academyVO) {
		log.info("countId() 실행...!");
		return academyService.countId(academyVO);	
	}
	

	
	// 수정 기능(완료)
	@ResponseBody
	@RequestMapping(value = "/treerename.do", method = RequestMethod.POST)
	public AcademyVO jqAcademyTreeRename(@RequestBody AcademyVO academyVO) {
		log.info("jqAcademyTreeRename() 실행...!");
		academyService.renameAcademyTree(academyVO);
		return academyVO;
	}

	// 삭제 기능(완료)
	@ResponseBody
	@RequestMapping(value = "/treedelete.do", method = RequestMethod.POST)
	public AcademyVO jqAcademyTreeRemove(@RequestBody AcademyVO academyVO) {
		log.info("jqAcademyTreeRemove() 실행...!");
		
		// id값 받아오기
		String id = academyVO.getId();
		

		academyService.removeAcademyTree(id);

		return academyVO;
	}

}
