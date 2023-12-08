package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.vo.AcademyVO;

public interface IAcademyMapper {

	public List<AcademyVO> getAcademyTree();

	public void updateAcademyTree(AcademyVO academyVO);

	public void deleteAcademyTree(AcademyVO academyVO);

	public void createAcademyTree(AcademyVO academyVO);

	public String countId(AcademyVO academyVO);


}
