<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>pharmacology index</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="pharmBits/pharmStyles.css" rel="stylesheet" type="text/css">
</head>
<%
	CONNECTION_STRING = "Provider=SQLOLEDB.1;Password=Ivabs%1;Persist Security Info=True;User ID=ivabs;Initial Catalog=ivabsintra;Data Source=tur-iis2"
  ShowProject = False
    
  Set objCon=Server.CreateObject("ADODB.Connection")
  objCon.CursorLocation = 3 ' adUseClient
  objCon.Open CONNECTION_STRING	
  
  If Request.Form("PageAction") = "Add" Then
    objCon.Execute "insert into Calve_Pharm_GroupStudent (GroupID, StudentID) Values (" & Request.Form("GroupID") & "," & Request.Form("StudentID") & ")"
  End If
  
  ClassYear = Request.QueryString("ClassYear")
  MaxGroupSize = 8
  
	Set oGroups = Server.CreateObject("ADODB.Recordset")
	oGroups.Open "select * from Calve_Pharm_Group Where ClassYear=" & ClassYear & " Order By ID", objCon, 3, 1
	
	Set oStudents = Server.CreateObject("ADODB.Recordset")
	oStudents.Open "select * from Calve_Pharm_Student Where ClassYear=" & ClassYear & " And (Select Count(*) From Calve_Pharm_GroupStudent Where Calve_Pharm_GroupStudent.StudentID = Calve_Pharm_Student.ID)=0 Order By StudentName", objCon, 3, 1

%>
<body alink="#FF0000">
<script src="jumptop.js">

/***********************************************
* Jump To Top Link Script- © Dynamic Drive (www.dynamicdrive.com)
* Last updated Nov 13th, 03'.
* This notice MUST stay intact for legal use
* Visit http://www.dynamicdrive.com/ for full source code
***********************************************/

</script>
<script type='text/javascript'>

//HV Menu v5.411- by Ger Versluis (http://www.burmees.nl/)
//Submitted to Dynamic Drive (http://www.dynamicdrive.com)
//Visit http://www.dynamicdrive.com for this script and more

function Go(){return}

</script>
<script type='text/javascript' src='exmplmenu_var.js'></script>
<script type='text/javascript' src='menu_com.js'></script>
		<noscript>Your browser does not support script</noscript>
		<table width="100%" border="0" align="center">
			<tr bgcolor="#FFFFFF">
				<td height="105" colspan="2" class="box1Pharm"><img src="pharmBits/images/syringe03.jpg" width="140" height="105"><img src="pharmBits/images/blue-cattle.jpg" width="502" height="105"></td>
			</tr>
		</table><br>
		<div align="center">
		  <h2>GROUP PROJECTS (Year <% =ClassYear %>)
		  </h2>
		</div>
 		 <table width="300" border="0" align="center" cellpadding="10" cellspacing="0" bgcolor="#FFFFFF">
           <tr valign="bottom">
             <td><form name="form1" method="post" action="groupregister.asp?ClassYear=<% =ClassYear %>">
                 <strong>Select a group and type your name.</strong><br>
                 <select name="GroupID"><%
                 
                 Do While Not oGroups.Eof
                  %><option value="<% =oGroups("ID") %>"><% =oGroups("GroupName") %></option><%
                  oGroups.MoveNext
                 Loop
                  
                 %>
                 </select>
                 <select name="StudentID"><%
                 
                 Do While Not oStudents.Eof
                  %><option value="<% =oStudents("ID") %>"><% =oStudents("StudentName") %></option><%
                  oStudents.MoveNext
                 Loop
                  
                 %>
                 </select>
&nbsp;
        <input type="submit" name="PageAction" value="Add">
             </form></td>
           </tr>
</table>
		 <br>
		 
		<table width="300" border="0" align="center" cellpadding="4"><%


	Set oGroupStudent = objCon.Execute("Select * from Calve_Pharm_GroupStudent Inner Join Calve_Pharm_Student On Calve_Pharm_Student.ID = StudentID Order By StudentName")
	
  oGroups.MoveFirst
	Do While Not oGroups.Eof
	  %>
			<tr>
				<td width="400" bgcolor="#FFFF99"><strong><% =oGroups("GroupName") %></strong></td>
			</tr><%
			 oGroupStudent.Filter = "GroupID=" & oGroups("ID")
			 If oGroupStudent.Eof Then %><tr>
			  <td bgcolor="#FFFFFF">No students</td>
		  </tr><%
       Else
        oGroupStudent.MoveFirst
       
			 
			 Do While Not oGroupStudent.Eof
			%><tr>
			  <td bgcolor="#FFFFFF"><% =oGroupStudent("StudentName") %></td>
		  </tr><%
		    oGroupStudent.MoveNext
		  Loop
		  End If
      
      If ShowProject Then 
			%><tr>
				<td width="400" bgcolor="#FFFF99"><strong>Project Name </strong></td>
			</tr><%
			End If
			%><tr>
			  <td>&nbsp;</td>
		  </tr><%
		  oGroups.MoveNext
	Loop
		  %></table>
        <br>

		
		
		
		
		
		
		
		<p>&nbsp;</p>
		<table width="90%" border="0" align="center">
  <tr align="center">
    <td> <a href="index.html"><img src="PharmBut.gif" width="100" height="21" border="0"></a></td>
    <td><a href="toxSite/indexTox.html"><img src="ToxBut.gif" width="100" height="21" border="0"></a></td>
    <td><a href="studyGuideSite/indexSG.html"><img src="SGbut.gif" width="100" height="21" border="0"></a></td>
    <td><a href="lectureSite/indexLec.html"><img src="LecBut.gif" width="100" height="21" border="0"></a></td>
    <td><a href="formSite/indexForm.html" target="_blank"><img src="FormBut.gif" width="100" height="21" border="0"></a></td>
    <td><a href="casesSite/indexCases.html"><img src="CaseBut.gif" width="100" height="21" border="0"></a></td>
  </tr>
</table>
		<br>
<table width="90%" border="0" align="center" cellpadding="2" cellspacing="0" bgcolor="#FFFFFF">
  <tr>
    <td width="50%" class="commonname"><img src="pharmBits/images/mulogo.gif" width="144" height="35"></td>
    <td width="50%" align="right" class="references"><div align="right">&copy; 
        Massey University</div>
    </td>
  </tr>
</table>
<p>&nbsp;</p>
</body>
</html>
