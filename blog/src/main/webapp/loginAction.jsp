<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	
	if(session.getAttribute("loginId") != null) {
		response.sendRedirect("./index.jsp?errorMsg=fail");
		return;
	} // 로그인 중에 중복 로그인 막기
	
	
	request.setCharacterEncoding("utf-8");
	
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");

	if(id==null || pw==null) {
		response.sendRedirect("./index.jsp?errorMsg=Invalid Access");
		return; // retrun; 대신 esle 블록을 사용해도 된다.
	} 
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://15.165.27.29/blog";
	String dbuser = "root";
	String dbpw = "secret";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	String sql = "SELECT id,level FROM member WHERE id=? AND pw=PASSWORD(?)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, id);
	stmt.setString(2, pw);
	ResultSet rs = stmt.executeQuery();
	
	if(rs.next()) { // 로그인 성공
		// setAttribute(String, Object)
		session.setAttribute("loginId", rs.getString("id")); // Object <-다형성 String 추상화,상속,다형성,캡슐화
		session.setAttribute("loginLevel", rs.getInt("level")); // Object <-다형성 Integer <-오토박싱 int
		response.sendRedirect("./index.jsp");
	} else { // 로그인 실패
		response.sendRedirect("./index.jsp?errorMsg=Invalid ID or PW");
	}
	
%>
<%
	rs.close();
	stmt.close();
	conn.close();
%>