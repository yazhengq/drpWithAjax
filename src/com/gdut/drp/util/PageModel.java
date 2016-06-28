package com.gdut.drp.util;

import java.util.List;

/**
 * ��װ��ҳ�߼�
 * ClassName: PageModel 
 * @Description: TODO
 * @author Standard
 * @date 2016��6��13��
 */
public class PageModel<T> {
	
	//�����
	private List<T> list;
	
	//��¼��
	private int totalRecords;
	
	//ÿҳ����������
	private int pageSize;
	
	//�ڼ�ҳ
	private int pageNo;
	
	/**
	 * ������ҳ��
	 * @return
	 */
	public int getTotalPages(){
		return (totalRecords + pageSize - 1) / pageSize;
	}
	
	/**
	 * ��ҳ
	 * @return
	 */
	public int getTopPageNo(){
		return 1;
	}
	
	/**
	 * βҳ
	 * @return
	 */
	public int getButtomPageNo(){
		return getTotalPages();
	}
	
	/**
	 * ǰһҳ
	 * @return
	 */
	public int getPreviousPageNo(){
		if(this.pageNo <= 1){
			return 1;
		}else{
			return this.pageNo - 1;
		}
	}

	/**
	 * ��һҳ
	 * @return
	 */
	public int getNextPageNo(){
		if(this.pageNo >= getTotalPages()){
			return getTotalPages();
		}else{
			return this.pageNo + 1;
		}
	}
	
	public int getPageNo() {
		return pageNo;
	}

	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}
	
	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public List<T> getList() {
		return list;
	}

	public void setList(List<T> list) {
		this.list = list;
	}

	public int getTotalRecords() {
		return totalRecords;
	}

	public void setTotalRecords(int totalRecords) {
		this.totalRecords = totalRecords;
	}
}
