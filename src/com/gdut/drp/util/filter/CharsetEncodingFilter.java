package com.gdut.drp.util.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

/**
 * ClassName: CharsetEncodingFilter 
 * @Description: ͳһ�����ַ���
 * @author Standard
 * @date 2016��6��15��
 */
public class CharsetEncodingFilter implements Filter {

	private String encoding;
	
	@Override
	public void destroy() {

	}

	@Override
	public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse,
			FilterChain filterChain) throws IOException, ServletException {
		//�����ַ���
		servletRequest.setCharacterEncoding(encoding);
//		System.out.println("CharsetEncodingFilter.doFilter---->begin");
		filterChain.doFilter(servletRequest, servletResponse);
//		System.out.println("CharsetEncodingFilter.doFilter---->end");
	}

	/**
	 * ��Ӧweb.xml��filter������
	 */
	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		//ȡ�ó�ʼ������
		this.encoding = filterConfig.getInitParameter("encoding");
//		System.out.println("CharsetEncodingFilter.init() encoding---->" + this.encoding);
	}

}
