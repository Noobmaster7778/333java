<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>pharmacology index</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/pharm/pharmBits/pharmStyles.css" rel="stylesheet" type="text/css">
</head>

<body alink="#FF0000">

<table width="90%" border="0">
<tr>
<td align="center">

<blockquote>
	<blockquote><p>&nbsp;</p>
		<h1>Submission Successful</h1>
	      <p>Your submission on the Pharmacology and Toxicology website was successfully sent.</p>
	      <br>

		  <p align="center"><a href="/pharm/indexpharm.html">Go back to the Pharmacology 
            home page</a> </blockquote>
</blockquote>
<br><br><br><br>

</td>
</tr>
</table>



<% response.buffer=true%>
<html>
<body>
<%
Dim iMsg 
Dim iConf 
Dim Flds 
Dim strHTML 
Dim strSmartHost
Dim theClient 
Const cdoSendUsingPort = 2 
StrSmartHost = "mail.massey.ac.nz" 
set iMsg = CreateObject("CDO.Message") 
set iConf = CreateObject("CDO.Configuration") 
Set Flds = iConf.Fields
' set the CDOSYS configuration fields to use port 25 on the SMTP server 
With Flds
.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = cdoSendUsingPort
.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = strSmartHost 
.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 10
.Update 
End With 

mymail "","pharmfeedback@massey.ac.nz","Pharm site feedback","Pharmacology study guide: " & request.form("SG") & "<br>Lectures: " & request.form("Lec") & "<br>Toxicology: " & request.form("Tox") & "<br>Poisonous plants: " & request.form("Plants") & "<br>Formulary: " & request.form("Form") & "<br>What did you like: " & request.form("like") & "<br>What did you NOT like: " & request.form("dislike")
Function mymail(recipient,sender,thesubject,thebody)
With iMsg 
Set .Configuration = iConf
.To = "j.p.chambers@massey.ac.nz"
.From = sender
.Subject = theSubject
.HTMLBody = thebody
.Send 
End With 
End Function
%>
</body>
</html>