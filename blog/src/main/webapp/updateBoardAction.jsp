<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	if(session.getAttribute("loginId") == null) {
		response.sendRedirect("./index.jsp?errorMsg=do login");
		return;
	} else if ((Integer)session.getAttribute("loginLevel") < 1)	{
		response.sendRedirect("./boardList");
		return;
	}
	
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardPw = request.getParameter("boardPw");
	System.out.println(boardNo + " <-- no");
	System.out.println(boardTitle + " <-- title");
	System.out.println(boardContent + " <-- content");
	System.out.println(boardPw + " <-- pw");
	
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://15.165.27.29/blog";
	String dbuser = "root";
	String dbpw = "secret";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 수정
	String updateSql = "UPDATE board SET board_title = ?, board_content = ? WHERE board_no = ? and board_pw = PASSWORD(?)";
	PreparedStatement updateStmt = conn.prepareStatement(updateSql);
	updateStmt.setString(1, boardTitle);
	updateStmt.setString(2, boardContent);
	updateStmt.setInt(3, boardNo);
	updateStmt.setString(4, boardPw);	
	
	int row = updateStmt.executeUpdate();
	System.out.println(row + " <-- row");

	if(row == 0) { // 수정실패
		response.sendRedirect("./updateBoard.jsp?boardNo="+boardNo);
	} else {
		response.sendRedirect("./boardOne.jsp?boardNo="+boardNo);
	}
%>
<%	
	updateStmt.close();
	conn.close();
%>