<?xml version="1.0" encoding="ISO-8859-1" ?>
<rss version="2.0">
<channel>
  <title>Pharmapodcastse</title>
  <link>http://calve.massey.ac.nz/pharm/lectureSite/pharmapodcasts/Podcasts</link>
  <description>These are large files (mostly 10 - 20MB) which contain the slides for the lectures as well as a recording of the sound.</description>
<%
  Function GetMediaFileSize(Filename)
    Set oFSO = Server.CreateObject("Scripting.FileSystemObject")
    Set oFile = oFSO.GetFile(Server.MapPath(MEDIA_FOLDER + "\" + Filename))
    GetFileSize = oFile.Size
  End Function
  
  Function GetFileSuffix(Filename)
  End Function
  
  Function GetFileMIMEType(Suffix)
  End Function
  
  MEDIA_FOLDER = "Media"
  CONNECTION_STRING = "Provider=SQLOLEDB.1;Password=Ivabs%2;Persist Security Info=True;User ID=ivabs;Initial Catalog=ivabsintra;Data Source=tur-iis2"
  Set objCon=Server.CreateObject("ADODB.Connection")
  objCon.CursorLocation = 3 ' adUseClient
  objCon.Open CONNECTION_STRING	
  Set oData = Server.CreateObject("ADODB.Recordset")
            oData.Open "Select * from RSSChannelItem Where Channel='Pharmapodcasts'", objCon, 3, 1
            Do While Not oData.Eof
              %>
              <item>
              <title><% =oData("Title") %></title>
              <description><% =oData("Description") %><% =Server.MapPath(MEDIA_FOLDER) %></description>
              
              <%
              if oData("EnclosureURL") <> "" Then %>
              <enclosure url="http://calve.massey.ac.nz/pharm/lectureSite/pharmapodcasts/Podcasts/media/<% =oData("EnclosureURL") %>" length="<% =GetMediaFileSize(oData("EnclosureURL")) %>" type="<% =oData("EnclosureMIMEType") %>"/>
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