<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	if(session.getAttribute("loginId") != null) {
		response.sendRedirect("./index.jsp?errorMsg=do login");
		return;
	}	

	request.setCharacterEncoding("utf-8");
	
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	
	// if(id==null || pw==null || id.equals("") || pw.equals("")) { 여러 조건 가능 잘못된 접근, 4자 이상 ... else if로 조건 늘리기
	if(id==null || pw==null || id.length() < 4 || pw.length() < 4 ) {
		response.sendRedirect("./insertMemberForm.jsp?errorMsg=error"); //
		return; // return; 대신 else 블록을 사용해도 된다. 하지만 길어짐
	}
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://15.165.27.29/blog";
	String dbuser = "root";
	String dbpw = "secret";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴 목록
	String sql = "INSERT INTO member(id,pw,level) VALUES (?,PASSWORD(?),0)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, id);
	stmt.setString(2, pw);
	stmt.executeUpdate();
	
	response.sendRedirect("./index.jsp");
%>
<%
	stmt.close();
	conn.close();
%>