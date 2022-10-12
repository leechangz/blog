<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	if(session.getAttribute("loginId") == null) {
		response.sendRedirect("./index.jsp?errorMsg=do login");
		return;
	} else if ((Integer)session.getAttribute("loginLevel") < 1)	{
		response.sendRedirect("./boardOne.jsp?boardNo="+boardNo+"&errorMsg=InvalidAccess");
		return;
	}
	
	request.setCharacterEncoding("utf-8");
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentPw = request.getParameter("commentPw");
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://15.165.27.29/blog";
	String dbuser = "root";
	String dbpw = "secret";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴 목록
	String locationSql = "SELECT location_no locationNo, location_name locationName FROM location";
	PreparedStatement locationStmt = conn.prepareStatement(locationSql);
	ResultSet locationRs = locationStmt.executeQuery();
	
	// 삭제
	String deleteSql = "DELETE FROM comment WHERE comment_no = ? and comment_pw = PASSWORD(?)";
	PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
	deleteStmt.setInt(1, commentNo);
	deleteStmt.setString(2, commentPw);
	
	int row = deleteStmt.executeUpdate();
	
	response.sendRedirect("./boardOne.jsp?boardNo="+boardNo);
%>
<%	
	deleteStmt.close();
	locationRs.close();
	locationStmt.close();
	conn.close();
%>