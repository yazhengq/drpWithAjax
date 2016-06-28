package com.gdut.drp.basedata.manager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.gdut.drp.util.Constants;
import com.gdut.drp.util.DBUtil;

/**
 * �����ȡ��������
 * @ClassName: ClientTreeReader 
 * @Description: TODO
 * @author Standard ����
 * @author Standard ���XX()����
 * @date 2016��6��16��
 */
class ClientTreeReader {

	//html�ַ���
	private StringBuffer sbTree = new StringBuffer();
	
	/**
	 * ��ȡ����������(���ط���)
	 * @return html�ַ���
	 */
	public String read(){
		Connection conn = null;

		try {
			conn = DBUtil.getConnection();
			read(conn, 0, 0);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBUtil.close(conn);
		}
		return sbTree.toString();
	}
	
	/**
	 * �ݹ��ȡ��������
	 * 
	 * ��һ���������ǹ�����߼��������ȶ�ȡ����
	 * �ڶ�������������
	 * ��������Ҷ�ӽڵ���롰-������Ҷ�ӽڵ���롰+��
	 * ���Ĳ�������div������νṹ
	 * @param conn
	 * @param id
	 * @param level ���Ʋ�θ�
	 */
	private void read(Connection conn, int id, int level){
		String sql = "select * from t_client where pid = ?";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				sbTree.append("<div>");
				sbTree.append("\n");
				for (int i=0; i<level; i++) {
					sbTree.append("<img src=\"../images/white.gif\">");
					sbTree.append("\n");
				}
				if ("N".equals(rs.getString("is_leaf"))) {
					sbTree.append("<img alt=\"չ��\" style=\"cursor:hand;\" onClick=\"display('" + rs.getInt("id") +"');\" id=\"img" + rs.getInt("id") + "\" src=\"../images/plus.gif\">");
					sbTree.append("\n");
					sbTree.append("<img id=\"im" + rs.getInt("id") + "\" src=\"../images/closedfold.gif\">");
					sbTree.append("\n");
					sbTree.append("<a href=\"client_node_crud.jsp?id=" + rs.getInt("id") + "\" target=\"clientDispAreaFrame\">" + rs.getString("name") + "</a>");
					sbTree.append("\n");
					sbTree.append("<div style=\"display:none;\" id=\"div" + rs.getInt("id") + "\">");
					sbTree.append("\n");
					read(conn, rs.getInt("id"), level+1); //�ݹ��ȡ
					sbTree.append("</div>");
					sbTree.append("\n");
				}else {
					sbTree.append("<img src=\"../images/minus.gif\">");
					sbTree.append("\n");
					sbTree.append("<img src=\"../images/openfold.gif\">");
					sbTree.append("\n");
					if (Constants.NO.equals(rs.getString("is_client"))) { 
						sbTree.append("<a href=\"client_node_crud.jsp?id=" + rs.getInt("id") + "\" target=\"clientDispAreaFrame\">" + rs.getString("name") + "</a>");
					}else {
						sbTree.append("<a href=\"client_crud.jsp?id=" + rs.getInt("id") + "\" target=\"clientDispAreaFrame\">" + rs.getString("name") + "</a>");
					}
					sbTree.append("\n");
				}
				sbTree.append("</div>");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally{
			DBUtil.close(rs);
			DBUtil.close(pstmt);
		}
	}

}
