<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="inc/header.jsp"%>
	<div class="d-flex justify-content-center container"
		style="height: 500px">
		<div class="col-md-10 col-lg-8 col-xl-7">
			<hr>
			<%
			if (request.getParameter("errorMsg") != null) {
			%>
			<div style="color: red;"><%=request.getParameter("errorMsg")%></div>
			<%
			}
			%>
			<%
			if (session.getAttribute("loginId") == null) { // 로그인 전
			%>
			<h3>LOGIN</h3>
			<form method="get" action="./loginAction.jsp"
				class="w-100 border p-3 bg-white shadow rounded align-self-center">
				<table class="table">
					<tr>
						<td class="table-primary">ID</td>
						<td class="table-primary"><input type="text" name="id"
							class="form-control"></td>
					</tr>
					<tr>
						<td class="table-primary">PW</td>
						<td class="table-primary"><input type="password" name="pw"
							class="form-control"></td>
					</tr>
				</table>
				<div class="text-center mt-3">
					<button type="submit" class="btn btn-dark text-uppercase">LOGIN</button>
					<a href="./insertMemberForm.jsp"
						class="btn btn-dark text-uppercase">회원가입</a>
				</div>
			</form>
			<%
			} else {
			%>
			<div class="text-center mt-3">
				<h3>
					<%=session.getAttribute("loginId")%>님 반갑습니다
				</h3>
			</div>
			<%
			}
			%>
		</div>
	</div>
<%@ include file="inc/footer.jsp"%>