/*L
 *  Copyright Washington University in St. Louis
 *  Copyright SemanticBits
 *  Copyright Persistent Systems
 *  Copyright Krishagni
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/catissue-core/LICENSE.txt for details.
 */

package edu.wustl.catissuecore.testcase;

import junit.framework.TestSuite;
import edu.wustl.catissuecore.testcase.admin.BiohazardTestCases;
import edu.wustl.catissuecore.testcase.admin.CancerReaserchGroupTestCases;
import edu.wustl.catissuecore.testcase.admin.DepartmentTestCases;
import edu.wustl.catissuecore.testcase.admin.DistributionProtocolTestCases;
import edu.wustl.catissuecore.testcase.admin.InstitutionTestCases;
import edu.wustl.catissuecore.testcase.admin.MenuTestCases;
import edu.wustl.catissuecore.testcase.admin.ProblemTestCase;
import edu.wustl.catissuecore.testcase.admin.SiteTestCases;
import edu.wustl.catissuecore.testcase.admin.SpecimenArrayTypeTestCases;
import edu.wustl.catissuecore.testcase.admin.StorageContainerTestCases;
import edu.wustl.catissuecore.testcase.admin.StorageTypeTestCases;
import edu.wustl.catissuecore.testcase.annotations.AnnotationTestCases;
import edu.wustl.catissuecore.testcase.biospecimen.AddToMyListTestCases;
import edu.wustl.catissuecore.testcase.biospecimen.CaCoreAppServiceDelegatorTestCase;
import edu.wustl.catissuecore.testcase.biospecimen.ConsentsTestCase;
import edu.wustl.catissuecore.testcase.biospecimen.FlexInterfaceTestCase;
import edu.wustl.catissuecore.testcase.biospecimen.LabelGeneratorTestCase;
import edu.wustl.catissuecore.testcase.biospecimen.ParticipantTestCases;
import edu.wustl.catissuecore.testcase.biospecimen.SpecimenArrayTestCase;
import edu.wustl.catissuecore.testcase.biospecimen.SpecimenCollectionGroupTestCases;
import edu.wustl.catissuecore.testcase.biospecimen.SpecimenEventsTestcases;
import edu.wustl.catissuecore.testcase.biospecimen.SpecimenTestCases;
import edu.wustl.catissuecore.testcase.collectionprotocol.CollectionProtocolTestCases;
import edu.wustl.catissuecore.testcase.login.FirstTimeLoginTestCase;
import edu.wustl.catissuecore.testcase.login.LoginTestCase;
import edu.wustl.catissuecore.testcase.login.LogoutTestcase;
import edu.wustl.catissuecore.testcase.login.UserSignUpTestCase;
import edu.wustl.catissuecore.testcase.ordering.DirectDistributionTestCase;
import edu.wustl.catissuecore.testcase.user.ScientistTestCases;
import edu.wustl.catissuecore.testcase.user.SupervisorTestCases;
import edu.wustl.catissuecore.testcase.user.TechnicianTestcases;
import edu.wustl.catissuecore.testcase.user.UserTestCases;

/**
 * Test suite
 */


public class CaTissueSuiteTestSuite
{
	/**
	 * Default constructor.
	 */
	public CaTissueSuiteTestSuite()
	{
		super();
	}


	/**
	 * @param args :
	 */
	public static void main(String[] args)
	{
		//org.junit.runner.JUnitCore.main("edu.wustl.dao.test.HibernateInsertTestCase");

		junit.awtui.TestRunner.run(CaTissueSuiteTestSuite.class);
		//junit.swingui.TestRunner.run(CaTissueSuiteTestSuite.class);
	}


	/**
	 * @return daoSuite.
	 */
	public static junit.framework.Test suite()
	{
		TestSuite strutsSuite = new TestSuite("caTissue Junit Test Cases");
//		daoSuite.addTestSuite(HibernateTestCaseForCatissue.class);

		strutsSuite.addTestSuite(InitializationTestCase.class);
		strutsSuite.addTestSuite(FirstTimeLoginTestCase.class);
	    strutsSuite.addTestSuite(LoginTestCase.class);
		strutsSuite.addTestSuite(MenuTestCases.class);
		strutsSuite.addTestSuite(InstitutionTestCases.class);
		strutsSuite.addTestSuite(DepartmentTestCases.class);
		strutsSuite.addTestSuite(CancerReaserchGroupTestCases.class);
		strutsSuite.addTestSuite(UserSignUpTestCase.class);
		strutsSuite.addTestSuite(SiteTestCases.class);
		strutsSuite.addTestSuite(BiohazardTestCases.class);
		strutsSuite.addTestSuite(DistributionProtocolTestCases.class);
		strutsSuite.addTestSuite(SpecimenArrayTypeTestCases.class);
		strutsSuite.addTestSuite(StorageTypeTestCases.class);
		strutsSuite.addTestSuite(StorageContainerTestCases.class);
		strutsSuite.addTestSuite(CollectionProtocolTestCases.class);
		strutsSuite.addTestSuite(ParticipantTestCases.class);
		strutsSuite.addTestSuite(SpecimenCollectionGroupTestCases.class);
		strutsSuite.addTestSuite(SpecimenTestCases.class);
	    strutsSuite.addTestSuite(FlexInterfaceTestCase.class);
		strutsSuite.addTestSuite(SpecimenEventsTestcases.class);
		strutsSuite.addTestSuite(ConsentsTestCase.class);
		strutsSuite.addTestSuite(SpecimenArrayTestCase.class);
		strutsSuite.addTestSuite(DirectDistributionTestCase.class);
		strutsSuite.addTestSuite(ProblemTestCase.class);
		strutsSuite.addTestSuite(LabelGeneratorTestCase.class);

//		strutsSuite.addTestSuite(InstitutionBizTestCases.class);
//		strutsSuite.addTestSuite(DepartmentBizTestCases.class);
//		strutsSuite.addTestSuite(CancerResearchGrpBizTestCases.class);
//		strutsSuite.addTestSuite(UserBizTestCases.class);
//		strutsSuite.addTestSuite(SiteBizTestCases.class);
//		strutsSuite.addTestSuite(BioHazardBizTestCases.class);
//		strutsSuite.addTestSuite(CollectionProtocolBizTestCases.class);
//		strutsSuite.addTestSuite(ParticipantBizTestCases.class);
//		strutsSuite.addTestSuite(SpecimenCollectGroupBizTestCases.class);
//		strutsSuite.addTestSuite(DistributionProtocolBizTestCases.class);
//		strutsSuite.addTestSuite(IdentifiedSurgicalPathologyReportBizTestCases.class);
//		strutsSuite.addTestSuite(DeIdentifiedSurgicalPathologyReportBizTestCases.class);
//		strutsSuite.addTestSuite(SpecimenBizTestCases.class);
//		strutsSuite.addTestSuite(StorageTypeBizTestCases.class);
//		strutsSuite.addTestSuite(StorageContainerBizTestCases.class);
//		strutsSuite.addTestSuite(AliquotBizTestCase.class);
//		strutsSuite.addTestSuite(BulkTransferTestCases.class);
//		strutsSuite.addTestSuite(BulkDisposalTestCases.class);
//		strutsSuite.addTestSuite(SpecimenEventBizTestCases.class);
//		strutsSuite.addTestSuite(StorageContainerRestrictionsBizTestCases.class);

		strutsSuite.addTestSuite(AddToMyListTestCases.class);
		strutsSuite.addTestSuite(CaCoreAppServiceDelegatorTestCase.class);
		strutsSuite.addTestSuite(UserTestCases.class);
		strutsSuite.addTestSuite(SupervisorTestCases.class);
		strutsSuite.addTestSuite(ScientistTestCases.class);
		strutsSuite.addTestSuite(AnnotationTestCases.class);
		strutsSuite.addTestSuite(TechnicianTestcases.class);

		strutsSuite.addTestSuite(LogoutTestcase.class);
		return strutsSuite;
	}


}
