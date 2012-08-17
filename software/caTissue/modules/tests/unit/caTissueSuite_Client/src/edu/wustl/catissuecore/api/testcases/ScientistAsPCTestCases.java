package edu.wustl.catissuecore.api.testcases;

import gov.nih.nci.system.applicationservice.ApplicationException;

import java.util.List;

public class ScientistAsPCTestCases extends AbstractCaCoreApiTestCasesWithRegularAuthentication {

	public ScientistAsPCTestCases() {
		loginName = PropertiesLoader.getPCScientistUsername();
		password = PropertiesLoader.getPCScientistUsername();
	}

	public void testForParticipantAsPC() {
		try {
			List<Object> result = getApplicationService().query(
					CqlUtility.getParticipantsForCP(PropertiesLoader
							.getPCScientistCPTitle()));

		} catch (ApplicationException e) {
			e.printStackTrace();
			assertFalse("Not able to retrieve Participants",
					true);
		}
	}
}