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
 * 用户管理类
 * @author Administrator
 *
 */
public class UserManager {
	
	//饿汉式
//	private static UserManager instance = new UserManager();
//	
//	private UserManager() {}
//	
//	public static UserManager getInstance() {
//		return instance;
//	}
	
	//懒汉式（lazy）
	private static UserManager instance = null;
	
	private UserManager() {}
	
	public static synchronized UserManager getInstance() {
		if (instance == null) {
			instance = new UserManager();
		}
		return instance;
	}
	
	/**  
	 * 添加用户
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
			pstmt.setTimestamp(6, new Timestamp(user.getCreateDate().getTime())); //注意Timestamp
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
	 * 根据用户id查询
	 * @param userId
	 * @return 如果存在返回User对象，否则返回null
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
	 * 分页查询
	 * @param pageNo 第几页
	 * @param pageSize 每页多少条数据
	 * @return PageModel对象
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
	 * 获取总的记录数
	 * @return 总记录数
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
	 * 修改用户
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
			 * 在哪打开的在哪关！
			 */
			DBUtil.close(pstmt);
			DBUtil.close(conn);
		}
	}
	
	/**
	 * 根据用户ID删除用户
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
			 * 在哪打开的在哪关！
			 */
			DBUtil.close(pstmt);
			DBUtil.close(conn);
		}
	}
	
	/**
	 * 根据用户id的集合删除
	 * 
	 * 要求采用一条语句删除，一次调用，使用占位符的方式
	 * 
	 * delete from t_user where user_id in('aaa', 'bbb');(暂时不使用占位符)
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
				//jdbc的序号从1开始
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
	 * 登录(采用受控异常)
	 * @param userId
	 * @param password
	 *//*
	public User login(String userId, String password) 
			throws UserNotFoundException, PasswordNotCorrectException{ //必须抛出
		User user = findUserById(userId);
		if(user == null){
			throw new UserNotFoundException("用户代码不能找到，代码 = 【" + userId + "】");
		}
		if(user.getPassword().equals(password)){
			throw new PasswordNotCorrectException("密码不正确");
		}
		
		return user;
	}*/
	
	/**
	 * 登录(采用非受控异常)
	 * 运行期异常
	 * @param userId
	 * @param password
	 */
	public User login(String userId, String password){ 
//		throws UserNotFoundException, PasswordNotCorrectException{ //不是必须
		User user = findUserById(userId);
		if(user == null){
			throw new UserNotFoundException("用户代码不能找到，代码 = 【" + userId + "】");
		}
		if(!user.getPassword().equals(password)){
			throw new PasswordNotCorrectException("密码不正确");
		}
		
		return user;
	}
	
	/**
	 * 登录，演示sql注入
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
				System.out.println("用户名和密码正确！！！");
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
