<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	if(session.getAttribute("loginId") == null) {
		response.sendRedirect("./index.jsp?errorMsg=do login");
		return;
	} else if ((Integer)session.getAttribute("loginLevel") < 1)	{
		response.sendRedirect("./boardList");
		return;
	}	

	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardPw = request.getParameter("boardPw");
	System.out.println(boardNo + " <-- no");
	System.out.println(boardPw + " <-- pw");
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://15.165.27.29/blog";
	String dbuser = "root";
	String dbpw = "secret";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	PreparedStatement deleteStmt = conn.prepareStatement("DELETE FROM board WHERE board_no = ? and board_pw = PASSWORD(?)");
	deleteStmt.setInt(1, boardNo);
	deleteStmt.setString(2, boardPw);
	System.out.println(deleteStmt + " <-- stmt");
	
	int row = deleteStmt.executeUpdate(); // 1이면 삭제 성공, 0이면 삭제 실패
	System.out.println(row + " <-- row");
	if(row == 0) {
		response.sendRedirect("./boardOne.jsp?boardNo="+boardNo);
	} else {
		response.sendRedirect("./boardList.jsp");
	}
%>
<%	
	deleteStmt.close();
	conn.close();
%>