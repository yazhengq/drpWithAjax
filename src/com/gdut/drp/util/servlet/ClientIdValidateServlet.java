package com.gdut.drp.util.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.gdut.drp.basedata.manager.ClientManager;

/**
 * ��֤�����̴����Ƿ��ظ�.servlet
 * 
 * @ClassName: ClientValidateServlet 
 * @Description: TODO
 * @author Standard
 * @date 2016��6��22��
 */
public class ClientIdValidateServlet extends HttpServlet {

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html;charset=GB18030");
		String clientId = request.getParameter("clientId");
		if(ClientManager.getInstance().findClientByClientId(clientId)){
			response.getWriter().print("�����̴����Ѿ����ڣ�");
		}
	}

	@Override
	public void init() throws ServletException {
		System.out.println("ClientIdValidateServlet.init()");
	}

	
	
}
