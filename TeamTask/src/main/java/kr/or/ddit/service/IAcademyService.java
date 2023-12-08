package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.vo.AcademyVO;

public interface IAcademyService {

	public List<AcademyVO> getAcademyTree();

	public void renameAcademyTree(AcademyVO academyVO);

	public void removeAcademyTree(AcademyVO academyVO);

	public void createAcademyTree(AcademyVO academyVO);

	public String countId(AcademyVO academyVO);


}
