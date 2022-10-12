<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
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
		<h1 style="text-color:white">GUESTBOOK</h1>
		<hr>
	</div>	
   <div class="row">      
      <div class="col-sm-2">
      </div>
      <!-- start main -->
      <div class="col-sm-8">
      	<h3>Guestbook</h3>
         <%
            if(session.getAttribute("loginId") != null) {
         %>
               <form method="post" action="./insertGuestbookAction.jsp">
                  <div class="form-group">
                     <textarea rows="3" cols="50" name="guestbookContent" class="form-control"></textarea>
                  </div>
                  <div>
                  	 <br>
                     <button type="submit" class="btn btn-dark" style="float:right;">글입력</button>
                  </div>
               </form>
         <%
            }
         %>
         <!-- to do -->
         <%
            int ROW_PER_PAGE = 10;
            int beginRow = 0;
            
            String guestbookSql = "SELECT guestbook_no guestbookNo, guestbook_content guestbookContent, id, create_date createDate FROM guestbook ORDER BY create_date DESC LIMIT ?,?";
            PreparedStatement guestbookStmt = conn.prepareStatement(guestbookSql);
            guestbookStmt.setInt(1, beginRow);
            guestbookStmt.setInt(2, ROW_PER_PAGE);
            ResultSet guestbookRs = guestbookStmt.executeQuery();
         %>
               <%
                  while(guestbookRs.next()) {
               %>
               		 <div>
               		 <br>
                     <table class="table table-primary table-boarderd" style="table-layout: fixed">
						<tr>
						</tr>
                        <tr>
                        	<td colspan="2">NO.<%=guestbookRs.getString("guestbookNo")%></td>
                        	<td colspan="8"><%=guestbookRs.getString("id")%></td>
                        </tr>
                        <tr>
                        	<td colspan="1"></td>
                            <td colspan="6"><%=guestbookRs.getString("guestbookContent")%></td>
                            <td colspan="1">DATE</td>
                            <td colspan="2"><%=guestbookRs.getString("createDate")%></td>
                        </tr>
                     </table>
                     </div>
                     <%
                        String loginId = (String)session.getAttribute("loginId");
                        if(loginId != null && loginId.equals(guestbookRs.getString("id"))) {
                     %>
                        <div>
                           <a href="./deleteGuestbook.jsp?guestbookNo=<%=guestbookRs.getInt("guestbookNo")%>" class="btn btn-dark" style="float:right;">삭제</a>
                     	   <br>	
                     	</div>
                     <%
                        }

                  }
               %>
            
      </div><!-- end main -->
      <div class="col-sm-2">
      </div>
   </div>
</div>
<%@ include file="inc/footer.jsp"%>

<%
	guestbookRs.close();
	guestbookStmt.close();
	locationRs.close();
	locationStmt.close();
	conn.close();
%>