<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	request.setCharacterEncoding("utf-8");
	
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

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<script
	src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.slim.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container-fluid">
		<h1>Blog</h1>
		<hr>
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
				<!-- to do -->
			</div>
		</div>
	</div>
</body>
</html>