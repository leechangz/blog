<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
if (session.getAttribute("loginId") != null) {
	response.sendRedirect("./index.jsp?errorMsg=do login");
	return;
}
%>
<%@ include file="inc/header.jsp"%>
<div class="d-flex justify-content-center container"
	style="height: 500px">
	<div class="col-md-10 col-lg-8 col-xl-7">
		<h1>회원가입</h1>
		<%
		if (request.getParameter("errorMsg") != null) {
		%>
		<span style="color: red;"><%=request.getParameter("errorMsg")%></span>
		<%
		}
		%>
		<form action="./insertMemberAction.jsp" method="post"
			class="w-100 border p-3 bg-white shadow rounded align-self-center">
			<table class="table table-hover">
				<tr>
					<td>ID</td>
					<td><input type="text" name="id" class="form-control"></td>
				</tr>
				<tr>
					<td>PASSWORD</td>
					<td><input type="password" name="pw" class="form-control"></td>
				</tr>
				<tr>
					<td>NUMBER</td>
					<td><input type="number" name="no" class="form-control"></td>
				</tr>
			</table>
			<div class="text-center mt-3">
				<button type="submit" class="btn btn-dark">회원가입</button>
			</div>
		</form>
	</div>
</div>
<%@ include file="inc/footer.jsp"%>

