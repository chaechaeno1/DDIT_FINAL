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
	public void removeAcademyTree(AcademyVO academyVO) {
		mapper.deleteAcademyTree(academyVO);
		
	}

	@Override
	public void createAcademyTree(AcademyVO academyVO) {
		mapper.createAcademyTree(academyVO);
		
	}

	@Override
	public String countId(AcademyVO academyVO) {
		return mapper.countId(academyVO);
	}



}
