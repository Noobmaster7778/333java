<% response.buffer=true%>
<html>
<body>
<%
If request("Button")="Submit" then
Set objMail = Server.CreateObject("CDONTS.NewMail")
For each sRequest in Request.Form
	'response.write sRequest
	Select Case sRequest
	Case "From"
		objMail.From=request(sRequest)
		sBody=sBody & sRequest & " - " & request(sRequest) & chr(13)
	Case "Button"
	Case else
		sBody=sBody & sRequest & " - " & request(sRequest) & chr(13)
	End select
Next
'response.write sBody
objMail.Body=sBody
objMail.To="j.p.chambers@massey.ac.nz"
objMail.From="j.p.chambers@massey.ac.nz"
objMail.Subject="website feedback"
objMail.Send
set objMail = nothing
response.write "Submitting......"
Response.Clear
Response.Redirect "sub_sent_pharm.asp"
else
response.write "There was a problem sending your request.  Please try again later"
Response.Clear
Response.Redirect "pharm_form.asp"
End if
%>
</body>
</html>