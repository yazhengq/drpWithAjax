package com.gdut.drp.util.generator;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.gdut.drp.util.DBUtil;

/**
 * id������
 * 
 * @ClassName: IDGenrator 
 * @Description: TODO
 * @author Standard
 * @date 2016��6��21��
 */
public class IDGenerator {

	private static IDGenerator instance = new IDGenerator();
	private void IDGenrator(){
		
	}
	public static IDGenerator getInstance(){
		
		return instance;
	}
	
	/**
	 * ������id
	 * synchronized ͬ�� ������ ֻ��һ�����Ը�
	 * @param tableName
	 * @return
	 */
	public synchronized long newID(String tableName){
		String sql = "select value from t_table_id where table_name = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		long value = 0L;
		try {
			conn = DBUtil.getConnection();
			//��������
			DBUtil.setAutoCommit(conn, false);
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, tableName);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				value = rs.getLong("value");
			}else {
				throw new RuntimeException("����Id����");
			}
			value = value + 1;

			//����value
			modifyValueField(conn, tableName, value);
			//�ύ����
			DBUtil.commit(conn);
		}catch(Exception e) {
			e.printStackTrace();
			//�ع�����
			DBUtil.rollback(conn);
			throw new RuntimeException("����Id����");
		}finally {
			DBUtil.close(rs);
			DBUtil.close(pstmt);
			DBUtil.close(conn);
		}
		return value;
	}
	
	/**
	 * ����value
	 * @param conn
	 * @param tableName
	 * @param value
	 * @throws SQLException
	 */
	private void modifyValueField(Connection conn, String tableName, long value) 
	throws SQLException {
		String sql = "update t_table_id set value=? where table_name=?";
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, value);
			pstmt.setString(2, tableName);
			pstmt.executeUpdate();
		}finally {
			DBUtil.close(pstmt);
		}
	} 
	
	public static void main(String[] args) {
		long newId = IDGenerator.getInstance().newID("t_client");
		System.out.println(newId);
	}
}
