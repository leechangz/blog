<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	String boardNo = request.getParameter("boardNo");
	System.out.println(boardNo + " <-- no");
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://15.165.27.29/blog";
	String dbuser = "root";
	String dbpw = "secret";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴 목록
	String locationSql = "SELECT location_no locationNo, location_name locationName FROM location";
	PreparedStatement locationStmt = conn.prepareStatement(locationSql);
	ResultSet locationRs = locationStmt.executeQuery();
%>

<%@ include file="inc/header2.jsp"%>
	<div class="container-fluid">
		<div style="background-color:#6B6E6F;">
			<h1 style="text-color:white">BOARD_NO.<%=boardNo%>_DELETE</h1>
			<hr>
		</div>
		<div class="row">
			<div class="col-sm-2">
				<!-- left menu -->
				<div>
					<ul>

						<li><a href="./boardList.jsp">전체</a></li>
						<%
						while (locationRs.next()) {
						%>
						<li><a
							href="./boardList.jsp?locationNo=<%=locationRs.getString("locationNo")%>">
								<%=locationRs.getString("locationName")%>
						</a></li>
						<%
						}
						%>
					</ul>
				</div>
			</div>
			<div class="col-sm-10">
				<form action="./deleteBoardAction.jsp" method="post">
					<div class="container">
						<input type="hidden" name="boardNo" value="<%=boardNo%>">
						<input type="password" name="boardPw" value="" placeholder="PASSWORD">
					</div>
					<div class="container">
						<button type="submit" class="btn btn-dark">삭제</button>
						<a href="./boardOne.jsp?boardNo=<%=boardNo%>" class="btn btn-dark">취소</a>
					</div>
				</form>
			</div>
		</div>
	</div>
<%@ include file="inc/footer.jsp"%>
<%	
	locationRs.close();
	locationStmt.close();
	conn.close();
%>