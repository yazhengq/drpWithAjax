package com.gdut.drp.util.datadict.manager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.gdut.drp.util.DBUtil;
import com.gdut.drp.util.datadict.domain.ClientLevel;

/**
 * ���õ��������������ֵ�
 * @ClassName: DataDictManager 
 * @Description: TODO
 * @author Standard
 * @date 2016��6��21��
 */
public class DataDictManager {
	
	//����ʽ
	private static DataDictManager instance = new DataDictManager();
	
	private DataDictManager(){
		
	}
	
	public static DataDictManager getInstance(){
		return instance;
	}
	
	//��������ʽ
	/*private static UserManager instance = null;

	private UserManager() {}

	public static synchronized UserManager getInstance() {
		if (instance == null) {
			instance = new UserManager();
		}
		return instance;
	}*/
	
	/**
	 * ȡ�÷����̼����б�
	 * @return
	 */
	public List<ClientLevel> getClientLevelList(){
		String sql = "select id, name from t_data_dict where category='A'";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<ClientLevel> clientLevelList = new ArrayList<ClientLevel>();
		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ClientLevel cl = new ClientLevel();
				cl.setId(rs.getString("id"));
				cl.setName(rs.getString("name"));
				clientLevelList.add(cl);
			} 
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			DBUtil.close(rs);
			DBUtil.close(pstmt);
			DBUtil.close(conn);
		}
		return clientLevelList;
	}
}
