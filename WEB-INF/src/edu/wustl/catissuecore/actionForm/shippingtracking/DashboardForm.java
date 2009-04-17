/**
 * <p>Title: DashboardForm Class</p>
 * <p>Description:DashboardForm class is the subclass of he AbstractActionForm bean classes. </p>
 * Copyright: Copyright (c) 2008
 * Company:
 * @author vijay_chittem
 * @version 1.00
 * Created on July 16, 2008
 */
package edu.wustl.catissuecore.actionForm.shippingtracking;

import org.apache.struts.action.ActionForm;

/**
 * ShippingTracking dashboard form. Dashboard contains received requests,
 * received shipments and outgoing shipments.
 */
public class DashboardForm extends ActionForm
{
	/**
	 * integer containing records per page on the dashboard.
	 */
	protected int recordsPerPage = 0;
	/**
	 * sets the records per page of the dashboard.
	 * @return recordsPerPage.
	 */
	public int getRecordsPerPage()
	{
		return recordsPerPage;
	}
	/**
	 * sets the records per page of the dashboard.
	 * @param recordsPerPage containing count of pages.
	 */
	public void setRecordsPerPage(int recordsPerPage)
	{
		this.recordsPerPage = recordsPerPage;
	}
}