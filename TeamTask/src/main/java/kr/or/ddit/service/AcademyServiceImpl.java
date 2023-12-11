package kr.or.ddit.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.IAcademyMapper;
import kr.or.ddit.vo.AcademyVO;

@Service
public class AcademyServiceImpl implements IAcademyService {

	@Inject
	private IAcademyMapper mapper;
	
	@Override
	public List<AcademyVO> getAcademyTree() {
		return mapper.getAcademyTree();
	}

	@Override
	public void renameAcademyTree(AcademyVO academyVO) {
		mapper.updateAcademyTree(academyVO);
	}


	@Override
	public void createAcademyTree(AcademyVO academyVO) {
		mapper.createAcademyTree(academyVO);
		
	}

	@Override
	public int countId(AcademyVO academyVO) {
		return mapper.countId(academyVO);
	}

	
	
	@Override
	public void removeAcademyTree(String id) {
		List<AcademyVO> childList = mapper.findChild(id);
		// 자식 트리가 존재하면 removeAcademyTreeChild 메서드로 보냄
		if(childList != null && childList.size() > 0) {		
			removeAcademyTreeChild(childList);
		}
		// 자식 노드 삭제 후 마지막으로 선택한 노드 삭제
		mapper.deleteAcademyTree(id);
		
	}
	
	@Override
	public void removeAcademyTreeChild(List<AcademyVO> childList) { // removeAcademyTree에서 호출하는 메서드
		for(AcademyVO child : childList) {	
			// 자식 노드 id가져와서 삭제
			mapper.deleteAcademyTree(child.getId());
			// 삭제한 트리 노드의 자식이 있는지 찾기
			removeAcademyTreeChild(mapper.findChild(child.getId()));
		}
		
	}
	

}
