package com.gdut.drp.util.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.gdut.drp.sysmgr.domain.User;
import com.gdut.drp.sysmgr.manager.UserManager;
import com.gdut.drp.util.PageModel;

/**
 * userDel的servlet
 * 
 * @ClassName: UserDelServlet 
 * @Description: TODO
 * @author Standard
 * @date 2016年6月27日
 */
public class UserDelServlet extends HttpServlet {
	
	PrintWriter pw = null;
	int pageNo = 1;
	int pageSize = 7;
	

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		PageModel<User> pageModel = null;
		List<User> userList = null;
		response.setContentType("text/html;charset=gb2312");
		String userIds = request.getParameter("selectValue");
		System.out.println("取得的userIds --------------> " + userIds);
		String[] arrayUserIds = userIds.split(",");
		
		UserManager.getInstance().delUser(arrayUserIds);
		
		//做完删除操作后，需要再做查询！
		pageModel = UserManager.getInstance().findAllUser(pageNo, pageSize);
		userList = pageModel.getList();
		
		pw = response.getWriter();
		
		pw.println("<div id='subFormSpan'>");
		pw.println("<table width='95%' border='1' cellspacing='0' cellpadding='0' align='center' class='table1'>");
		pw.println("<tr>");
		pw.println("<td width='55' class='rd6'><input type='checkbox' name='ifAll' onClick='checkAll()'></td>");
		pw.println("<td width='119' class='rd6'>用户代码</td>");
		pw.println("<td width='152' class='rd6'>用户名称</td>");
		pw.println("<td width='166' class='rd6'>联系电话</td>");
		pw.println("<td width='150' class='rd6'>email</td>");
		pw.println("<td width='153' class='rd6'>创建日期</td>");
		pw.println("</tr>");
		
		for (Iterator<User> iter = userList.iterator(); iter.hasNext();) {
			User user = iter.next();
			pw.println("<tr>");
			pw.println("<td class='rd8'><input type='checkbox' name='selectFlag' class='checkbox1' value='"+ user.getUserId()+"'></td>");
			pw.println("<td class='rd8'>" + user.getUserId() + "</td>");
			pw.println("<td class='rd8'>" + user.getUserName() + "</td>");
			pw.println("<td class='rd8'>" + user.getContactTel() + "</td>");
			pw.println("<td class='rd8'>" + user.getEmail() + "</td>");
			pw.println("<td class='rd8'>" + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(user.getCreateDate()) + "</td>");
			pw.println("</tr>");
		}
		pw.println("</table>");
		pw.println("</div>");
	}
	
}
