package com.gdut.drp.util;

import java.util.List;

/**
 * 封装分页逻辑
 * ClassName: PageModel 
 * @Description: TODO
 * @author Standard
 * @date 2016年6月13日
 */
public class PageModel<T> {
	
	//结果集
	private List<T> list;
	
	//记录数
	private int totalRecords;
	
	//每页多少条数据
	private int pageSize;
	
	//第几页
	private int pageNo;
	
	/**
	 * 返回总页数
	 * @return
	 */
	public int getTotalPages(){
		return (totalRecords + pageSize - 1) / pageSize;
	}
	
	/**
	 * 首页
	 * @return
	 */
	public int getTopPageNo(){
		return 1;
	}
	
	/**
	 * 尾页
	 * @return
	 */
	public int getButtomPageNo(){
		return getTotalPages();
	}
	
	/**
	 * 前一页
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
	 * 后一页
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
