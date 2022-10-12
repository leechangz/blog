<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.Diary"%>
<%
Calendar c = Calendar.getInstance();
if (request.getParameter("y") != null || request.getParameter("m") != null) {
	int y = Integer.parseInt(request.getParameter("y"));
	int m = Integer.parseInt(request.getParameter("m"));

	if (m == -1) { // 1월에서 이전으로 넘어갈 때
		m = 11;
		y -= 1;
	}

	if (m == 12) { // 12월에서 다음으로 넘어갈 때
		m = 0;
		y += 1;
	}

	c.set(Calendar.YEAR, y);
	c.set(Calendar.MONTH, m);
}

int lastDay = c.getActualMaximum(Calendar.DATE);

int startBlank = 0; // 달력 시작 빈 갯수 (td...), 일(0) ~ 토(6) <- (1일의 요일값 -1)
// 출력하는 달의 1일의 날짜객체
Calendar first = Calendar.getInstance();
first.set(Calendar.YEAR, c.get(Calendar.YEAR));
first.set(Calendar.MONTH, c.get(Calendar.MONTH));
first.set(Calendar.DATE, 1); // 1일
startBlank = first.get(Calendar.DAY_OF_WEEK) - 1; // 1일의 요일값 -1 (빈공간의 수는 그 날을 제외한 나머지)

int endBlank = 7 - (startBlank + lastDay) % 7; // 달력 끝 빈 갯수 (td...)
if (endBlank == 7) {
	endBlank = 0;
}

Class.forName("org.mariadb.jdbc.Driver");
String url = "jdbc:mariadb://15.165.27.29/blog";
String dbuser = "root";
String dbpw = "secret";
Connection conn = DriverManager.getConnection(url, dbuser, dbpw);

String sql = "SELECT diary_no diaryNo, diary_date diaryDate, diary_todo diaryTodo FROM diary WHERE YEAR(diary_date) = ? AND MONTH(diary_date) = ? ORDER BY diary_date ";
PreparedStatement stmt = conn.prepareStatement(sql);
stmt.setInt(1, c.get(Calendar.YEAR));
stmt.setInt(2, c.get(Calendar.MONTH) + 1);
ResultSet rs = stmt.executeQuery();

// 특수한 환경의 타입 diary테이블의 ResultSet -> 어떤곳에서는 사용하는 자바 ArrayList<Diary> 변경 
ArrayList<Diary> list = new ArrayList<Diary>();
while (rs.next()) {
	Diary d = new Diary(); // 행의 수 만큼 생성자를 만들어야 하므로 while문 안에서 생성
	d.diaryNo = rs.getInt("diaryNo");
	d.diaryDate = rs.getString("diaryDate");
	System.out.println(rs.getString("diaryDate"));
	d.diaryTodo = rs.getString("diaryTodo");
	list.add(d);
}

// System.out.print(list);
// ArrayList에 담았기에 바로 닫아도 됨.
rs.close();
stmt.close();
conn.close();
%>
<%@ include file="inc/header2.jsp"%>
<div class="container-fluid">
	<div style="background-color: #6B6E6F;">
		<h1 style="text-color: white">DIARY</h1>
		<hr>
	</div>
	<div class="text-center">
		<a
			href="./diary.jsp?y=<%=c.get(Calendar.YEAR)%>&m=<%=c.get(Calendar.MONTH) - 1%>"
			class="btn btn-dark text-uppercase">previos</a> <span><%=c.get(Calendar.YEAR)%>년
			<%=c.get(Calendar.MONTH) + 1%>월</span> <a
			href="./diary.jsp?y=<%=c.get(Calendar.YEAR)%>&m=<%=c.get(Calendar.MONTH) + 1%>"
			class="btn btn-dark text-uppercase">next</a>
	</div>

	<table class="table table-bordered" style="table-layout: fixed">
		<tr>
			<td>SUNDAY</td>
			<td>MONDAY</td>
			<td>TUESDAY</td>
			<td>WEDNESDAY</td>
			<td>THURSDAY</td>
			<td>FRIDAY</td>
			<td>SATURDAY</td>
		</tr>
		<tr>

			<%
			for (int i = 1; i <= startBlank + lastDay + endBlank; i++) { // 조건은 시작 빈공간 + 그 달의 날짜 + 마지막 빈공간
				if (i - startBlank < 1) {
			%>
			<td>&nbsp;</td>
			<!-- 공백 -->
			<%
			} else if (i - startBlank > lastDay) {
			%>
			<td>&nbsp;</td>
			<%
			} else {
			%>
			<td height="150px"><a
				href="./insertDiary.jsp?y=<%=c.get(Calendar.YEAR)%>&m=<%=c.get(Calendar.MONTH) + 1%>&d=<%=i - startBlank%>">
					<%=i - startBlank%>
			</a> <%
 for (Diary d : list) {
 	String date = d.diaryDate.substring(d.diaryDate.length() - 2);
 	if (Integer.parseInt(date) == (i - startBlank)) {
 %>
				<div>
					<a href="./diaryOne.jsp?diaryNo=<%=d.diaryNo%>"><%=d.diaryTodo + ","%></a>
				</div> <%
 }
 }
 %></td>
			<%
			}
			if (i % 7 == 0 && i != startBlank + lastDay) {
			%>
		</tr>
		<tr>
			<%
			}
			}
			%>
		</tr>
	</table>
</div>
<%@ include file="inc/footer.jsp"%>
