package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.vo.AcademyVO;

public interface IAcademyMapper {

	public List<AcademyVO> getAcademyTree();

	public void updateAcademyTree(AcademyVO academyVO);

	public void createAcademyTree(AcademyVO academyVO);

	public int countId(AcademyVO academyVO);

	public List<AcademyVO> findChild(String id);

	public void deleteAcademyTree(String id);

}
