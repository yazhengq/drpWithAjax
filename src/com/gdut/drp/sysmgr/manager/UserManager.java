package com.gdut.drp.sysmgr.manager;

import java.awt.image.DataBuffer;
import java.sql.Statement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.gdut.drp.sysmgr.domain.User;
import com.gdut.drp.util.DBUtil;
import com.gdut.drp.util.PageModel;
import com.sun.swing.internal.plaf.synth.resources.synth;
  
/**
 * �û�������
 * @author Administrator
 *
 */
public class UserManager {
	
	//����ʽ
//	private static UserManager instance = new UserManager();
//	
//	private UserManager() {}
//	
//	public static UserManager getInstance() {
//		return instance;
//	}
	
	//����ʽ��lazy��
	private static UserManager instance = null;
	
	private UserManager() {}
	
	public static synchronized UserManager getInstance() {
		if (instance == null) {
			instance = new UserManager();
		}
		return instance;
	}
	
	/**  
	 * ����û�
	 * @param user
	 */
	public void addUser(User user) {
		System.out.println("UserManager.addUser() -->>" + user);
		String sql = "insert into t_user(user_id, user_name, password, " +
				"contact_tel, email, create_date) values(?, ?, ?, ?, ?, ?)";
		System.out.println("UserManager.addUser() -->>sql=" + sql);
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user.getUserId());
			pstmt.setString(2, user.getUserName());
			pstmt.setString(3, user.getPassword());
			pstmt.setString(4, user.getContactTel());
			pstmt.setString(5, user.getEmail());
			pstmt.setTimestamp(6, new Timestamp(user.getCreateDate().getTime())); //ע��Timestamp
			pstmt.executeUpdate();
		}catch(SQLException e) {
			e.printStackTrace();
			//log4j............
		}finally {
			DBUtil.close(pstmt);
			DBUtil.close(conn);
		}
	}
	
	/**
	 * �����û�id��ѯ
	 * @param userId
	 * @return ������ڷ���User���󣬷��򷵻�null
	 */
	public User findUserById(String userId){
		System.out.println("UserManager.findUserById() -->> userId =" + userId);
		String sql = "select * from t_user where USER_ID =?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		User user = null;
		
		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				user = new User();
				user.setUserId(rs.getString("user_id"));
				user.setUserName(rs.getString("user_name"));
				user.setPassword(rs.getString("password"));
				user.setContactTel(rs.getString("contact_tel"));
				user.setEmail(rs.getString("email"));
				user.setCreateDate(rs.getTimestamp("create_date"));
			}
		}catch(SQLException e) {
			e.printStackTrace();
			//log4j............
		}finally {
			DBUtil.close(rs);
			DBUtil.close(pstmt);
			DBUtil.close(conn);
		}
		return user;
	}
	
	/**
	 * ��ҳ��ѯ
	 * @param pageNo �ڼ�ҳ
	 * @param pageSize ÿҳ����������
	 * @return PageModel����
	 */
	public PageModel<User> findAllUser(int pageNo, int pageSize){
		StringBuffer sbSql = new StringBuffer();
		sbSql.append("select * from") 
		.append("(select t.*, rownum rn from") 
		.append("(select * from t_user where user_id <> 'root' order by user_id) t")
		.append(" where rownum<=?)") 
		.append("where rn>?");
//select * from (select t.*, rownum rn from (select * from t_user where user_id <> 'root' order by user_id) t where rownum<=?) where rn>?	
System.out.println("UserManager.findAllUser()------>" + sbSql);
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		User user = null;
		PageModel<User> pageModel= null;
		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sbSql.toString());
			pstmt.setInt(1, pageNo * pageSize);
			pstmt.setInt(2, (pageNo-1) * pageSize);
			rs = pstmt.executeQuery();
			List<User> userList = new ArrayList<User>();
			while (rs.next()) {
				user = new User();
				user.setUserId(rs.getString("user_id"));
				user.setUserName(rs.getString("user_name"));
				user.setPassword(rs.getString("password"));
				user.setContactTel(rs.getString("contact_tel"));
				user.setEmail(rs.getString("email"));
				user.setCreateDate(rs.getTimestamp("create_date"));
				userList.add(user);
			}
			pageModel = new PageModel<User>();
			pageModel.setList(userList);
			pageModel.setTotalRecords(getTotalRecords(conn));
			pageModel.setPageNo(pageNo);
			pageModel.setPageSize(pageSize);
		}catch(SQLException e) {
			e.printStackTrace();
			//log4j............
		}finally {
			DBUtil.close(rs);
			DBUtil.close(pstmt);
			DBUtil.close(conn);
		}
		return pageModel;
	}
	
	/**
	 * ��ȡ�ܵļ�¼��
	 * @return �ܼ�¼��
	 */
	private int getTotalRecords(Connection conn) throws SQLException{
		String sql = "select count(*) from t_user where user_id <> 'root'";		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try{
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			rs.next();
			count = rs.getInt(1);
		}finally{
			rs.close();
			pstmt.close();
			conn.close();
		}
		return count;
	}
	
	/**
	 * �޸��û�
	 */
	public void modifyUser(User user) {
		System.out.println("UserManager.modify() -->>" + user);
		String sql = "update t_user set user_name=?, password=?, contact_tel=?, "
				+ "email=? where user_id=? ";
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user.getUserName());
			pstmt.setString(2, user.getPassword());
			pstmt.setString(3, user.getContactTel());
			pstmt.setString(4, user.getEmail());
			pstmt.setString(5, user.getUserId());
			pstmt.executeUpdate();
		}catch(SQLException e) {
			e.printStackTrace();
			//log4j............
		}finally {
			/**
			 * ���Ĵ򿪵����Ĺأ�
			 */
			DBUtil.close(pstmt);
			DBUtil.close(conn);
		}
	}
	
	/**
	 * �����û�IDɾ���û�
	 * @param userId
	 */
	public void delUser(String userId){
		String sql = "delete from t_user where user_id=?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			pstmt.executeUpdate();
		}catch(SQLException e) {
			e.printStackTrace();
			//log4j............
		}finally {
			/**
			 * ���Ĵ򿪵����Ĺأ�
			 */
			DBUtil.close(pstmt);
			DBUtil.close(conn);
		}
	}
	
	/**
	 * �����û�id�ļ���ɾ��
	 * 
	 * Ҫ�����һ�����ɾ����һ�ε��ã�ʹ��ռλ���ķ�ʽ
	 * 
	 * delete from t_user where user_id in('aaa', 'bbb');(��ʱ��ʹ��ռλ��)
	 * delete from t_user where user_id in(?, ?);
	 * 
	 * @param userIds
	 */
	public void delUser(String[] userIds){
		StringBuffer sbStr = new StringBuffer();
		for(int i=0; i<userIds.length; i++){
//			sbStr.append("'").append(userIds[i]).append("',");
			sbStr.append("?,");
		}
		String sql = "delete from t_user where user_id in(" + sbStr.substring(0, sbStr.length()-1) + ")";
		Connection conn = null;
		PreparedStatement pstmt = null;
		try{
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			for (int i = 0; i < userIds.length; i++) {
				//jdbc����Ŵ�1��ʼ
				pstmt.setString(i+1, userIds[i]);
			}
			pstmt.executeUpdate();
		}catch(SQLException e){
			e.printStackTrace();
		}finally{
			DBUtil.close(pstmt);
			DBUtil.close(conn);
		}
		
	}
	
/*	*//**
	 * ��¼(�����ܿ��쳣)
	 * @param userId
	 * @param password
	 *//*
	public User login(String userId, String password) 
			throws UserNotFoundException, PasswordNotCorrectException{ //�����׳�
		User user = findUserById(userId);
		if(user == null){
			throw new UserNotFoundException("�û����벻���ҵ������� = ��" + userId + "��");
		}
		if(user.getPassword().equals(password)){
			throw new PasswordNotCorrectException("���벻��ȷ");
		}
		
		return user;
	}*/
	
	/**
	 * ��¼(���÷��ܿ��쳣)
	 * �������쳣
	 * @param userId
	 * @param password
	 */
	public User login(String userId, String password){ 
//		throws UserNotFoundException, PasswordNotCorrectException{ //���Ǳ���
		User user = findUserById(userId);
		if(user == null){
			throw new UserNotFoundException("�û����벻���ҵ������� = ��" + userId + "��");
		}
		if(!user.getPassword().equals(password)){
			throw new PasswordNotCorrectException("���벻��ȷ");
		}
		
		return user;
	}
	
	/**
	 * ��¼����ʾsqlע��
	 * @param userId
	 * @param password
	 */
	public boolean login1(String userId, String password){ 
		String sql = "select * from t_user where user_id='" + userId +"' and password='" + password +"'";
		System.out.println("UserManager.login1() sql = " + sql);
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean success = false;
		try{
			conn = DBUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()){
				success = true;
				System.out.println("�û�����������ȷ������");
			}
		}catch(SQLException e){
			e.printStackTrace();
		}finally{
			DBUtil.close(rs);
			DBUtil.close(pstmt);
			DBUtil.close(conn);
		}
		
		return success;
	}
	
	public static void main(String[] args) {
		UserManager um = UserManager.getInstance();
		User user = new User();
		um.findUserById("root");
		um.findAllUser(0, 1);
		um.modifyUser(user);
		
	}
	
}
