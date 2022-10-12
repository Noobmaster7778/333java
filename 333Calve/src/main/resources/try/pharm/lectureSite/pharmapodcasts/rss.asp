<?xml version="1.0" encoding="ISO-8859-1" ?>
<rss version="2.0">
<channel>
  <title>Pharmapodcasts</title>
  <link>http://calve.massey.ac.nz/pharm/lectureSite/pharmapodcasts/podcasts.asp</link>
  <description>These are large files (mostly 10 - 20MB) which contain the slides for the lectures as well as a recording of the sound.</description>
<%
  Function GetMediaFilename(Filename)
    GetMediaFilename = Server.MapPath(MEDIA_RELATIVE_FOLDER + "\" + Filename)
  End Function
  
  Function GetMediaFileSize(Filename)
    Set oFSO = Server.CreateObject("Scripting.FileSystemObject")
    Set oFile = oFSO.GetFile(GetMediaFilename(Filename))
    GetMediaFileSize = oFile.Size
  End Function
  
  Function GetFileSuffix(Filename)
    Set oFSO = Server.CreateObject("Scripting.FileSystemObject")
    GetFileSuffix = oFSO.GetExtensionName(GetMediaFilename(Filename))
  End Function
  
  Function GetFileMIMEType(Filename)
    Select Case GetFileSuffix(Filename)
      Case "m4a"
        GetFileMIMEType = "audio/x-m4a"
      Case "m4v"
        GetFileMIMEType = "video/x-m4v"
      Case Else
        GetFileMIMEType = "application/octet-stream"
    End Select
  End Function
  
  MEDIA_RELATIVE_FOLDER = "Media"
  MEDIA_ABSOLUTE_URL = "http://calve.massey.ac.nz/pharm/lectureSite/pharmapodcasts/media/"
  CONNECTION_STRING = "Provider=SQLOLEDB.1;Password=Ivabs%2;Persist Security Info=True;User ID=ivabs;Initial Catalog=ivabsintra;Data Source=tur-iis2"
  Set objCon=Server.CreateObject("ADODB.Connection")
  objCon.CursorLocation = 3 ' adUseClient
  objCon.Open CONNECTION_STRING	
  Set oData = Server.CreateObject("ADODB.Recordset")
            oData.Open "Select * from RSSChannelItem Where Channel='Pharmapodcasts' Order By DateCreated Desc", objCon, 3, 1
            Do While Not oData.Eof
              %>
              <item>
              <title><% =oData("Title") %></title>
              <description><% =oData("Description") %></description>
              
              <%
              if oData("EnclosureFilename") <> "" Then %>
              <enclosure url="<% =MEDIA_URL %><% =MEDIA_ABSOLUTE_URL + oData("EnclosureFilename") %>" length="<% =GetMediaFileSize(oData("EnclosureFilename")) %>" type="<% =GetFileMIMEType(oData("EnclosureFilename")) %>"/>
              <% End if
              oData.MoveNext
              %>
              </item>
              <%
              
            Loop
            oData.Close
            objCon.Close  
%></channel>
</rss>