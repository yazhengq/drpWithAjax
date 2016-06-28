package com.gdut.drp.basedata.domain;

import com.gdut.drp.util.datadict.domain.ClientLevel;

/**
 * ������
 * 
 * ClassName: Client 
 * @Description: 
 * @author Standard
 * @date 2016��6��16��
 */

public class Client {

	private int id;
	
	private String name;
	
	private String clientId;
	
	private String bankAcctNo;
	
	private String contactTel;
	
	private String address;
	
	private String zipCode;
	
	//Y:��Ҷ�ӣ�N����Ҷ��
	private String isLeaf;
	
	//Y:�Ƿ����̣�N�����Ƿ�����
	private String isClient;
	
	//private Client parent;
	
	//private Set children;
	
	//parent id
	private int pid;
	
	//�����̼���
	private ClientLevel clientLevel = new ClientLevel();

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getClientId() {
		return clientId == null ? "" : clientId;
	}

	public void setClientId(String clientId) {
		this.clientId = clientId;
	}

	public String getBankAcctNo() {
		return bankAcctNo == null ? "" : bankAcctNo;
	}

	public void setBankAcctNo(String bankAcctNo) {
		this.bankAcctNo = bankAcctNo;
	}

	public String getContactTel() {
		return contactTel == null ? "" : contactTel;
	}

	public void setContactTel(String contactTel) {
		this.contactTel = contactTel;
	}

	public String getAddress() {
		return address == null ? "" : address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getZipCode() {
		return zipCode == null ? "" : zipCode;
	}

	public void setZipCode(String zipCode) {
		this.zipCode = zipCode;
	}

	public String getIsLeaf() {
		return isLeaf;
	}

	public void setIsLeaf(String isLeaf) {
		this.isLeaf = isLeaf;
	}

	public String getIsClient() {
		return isClient;
	}

	public void setIsClient(String isClient) {
		this.isClient = isClient;
	}

	public int getPid() {
		return pid;
	}

	public void setPid(int pid) {
		this.pid = pid;
	}

	public ClientLevel getClientLevel() {
		return clientLevel;
	}

	public void setClientLevel(ClientLevel clientLevel) {
		this.clientLevel = clientLevel;
	}
	
}
