<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	if(session.getAttribute("loginId") == null) {
		response.sendRedirect("./index.jsp?errorMsg=do login");
		return;
	}	

	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));	
	String commentContent = request.getParameter("commentContent");	
	String commentPw = request.getParameter("commentPw");	

	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://15.165.27.29/blog";
	String dbuser = "root";
	String dbpw = "secret";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴 목록
	String commentSql = "INSERT INTO comment (board_no, comment_content, create_date, comment_pw) VALUES (?, ?, now(), PASSWORD(?))";
	PreparedStatement commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, boardNo);
	commentStmt.setString(2, commentContent);
	commentStmt.setString(3, commentPw);
	
	int row = commentStmt.executeUpdate();
	System.out.println(row + " <-- row");

	if(row == 0) { // 수정실패
		response.sendRedirect("./boardOne.jsp?boardNo="+boardNo);
	} else {
		response.sendRedirect("./boardOne.jsp?boardNo="+boardNo);
	}
%>
<%	
	commentStmt.close();
	conn.close();
%>