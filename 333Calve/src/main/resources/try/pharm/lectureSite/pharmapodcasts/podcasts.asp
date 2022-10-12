<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html>
<head>
<title>lecture podcasts</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../lecStyles.css" type="text/css" rel="stylesheet" media="all" />
<script type="text/javascript"><!--//--><![CDATA[//><!--
sfHover = function() {
	var sfEls = document.getElementById("nav").getElementsByTagName("LI");
	for (var i=0; i<sfEls.length; i++) {
		sfEls[i].onmouseover=function() {
			this.className+=" sfhover";
		}
		sfEls[i].onmouseout=function() {
			this.className=this.className.replace(new RegExp(" sfhover\\b"), "");
		}
	}
}
if (window.attachEvent) window.attachEvent("onload", sfHover);

//--><!]]></script>
</head>
<body>
<a id="top"></a>
<div class="bannerPh">
  <div class="indent120"> <img src="../../pharmBits/images/brown-cattle.jpg" height="105" border="0" /></div>
</div>
<div id="text">
<p>These are large files (mostly 10 - 20MB) which contain the slides for the lectures as well as a recording of the sound. The file format is m4a or m4v, which can be opened in iTunes, Quicktime player or something similar.</p>
<a href="http://calve.massey.ac.nz/pharm/lectureSite/pharmapodcasts/rss.asp" /><img src="RSS.png" border="0" alt="Subscribe to RSS Feed"  /></a>
<!--asp here?-->
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
            oData.Open "Select * from RSSChannelItem Where Channel='Pharmapodcasts' Order By PubDate Desc", objCon, 3, 1
            Do While Not oData.Eof
              %><div class="RSSItem"><p class="RSSItemTitle"><% =oData("Title") %></p><p class="RSSItemDescription"><% =oData("Description") %></p><p class="RSSItemLink"><a href="<% =MEDIA_URL %><% =MEDIA_ABSOLUTE_URL + oData("EnclosureFilename")%>">Presentation</a></p></div><%
                         oData.MoveNext
            Loop
            oData.Close
            objCon.Close  
%>
</div>
<div id="suckerfish">
<!--Son of Suckerfish menu http://www.htmldog.com-->
    <ul id="nav">
      <li><a href="http://calve.massey.ac.nz/">CALVE</a></li>
      <li><a href="/pharm/indexpharm.html">Home</a></li>
      <li><a class="daddy" href="/pharm/indexpharm.html">Pharmacology</a>
        <ul>
          <li><a class="daddy" href="/pharm/pharmBits/adminfiles/adminIndex3.html">admin sem 1</a>
            <ul>
              <li><a href="/pharm/pharmBits/adminfiles/adminAss3.html">Exams</a></li>
              <li><a href="/pharm/pharmBits/adminfiles/adminWGp3.html">Work groups info</a></li>
            </ul>
          </li>
          <li><a href="/pharm/pharmBits/adminfiles/adminIndex3.html">admin sem 2</a></li>
        </ul>
      </li>
      <li><a class="daddy" href="/pharm/toxSite/indexTox.html">Toxicology</a>
        <ul>
          <li><a class="daddy" href="/pharm/toxSite/poisonplants/index.html">Poisonous plants</a>
            <ul>
              <li><a href="/pharm/toxSite/poisonplants/comNames.html">Common names</a></li>
              <li><a href="/pharm/toxSite/poisonplants/latNames.html">Latin names</a></li>
              <li><a href="/pharm/toxSite/poisonplants/toxIndex.html">Plant toxins</a></li>
              <li><a href="/pharm/toxSite/poisonplants/glossary.html">Glossary</a></li>
            </ul>
          </li>
          <li><a href="/pharm/lectureSite/indexLec.html">Lectures</a></li>
        </ul>
      </li>
      <li><a class="daddy" href="/pharm/studyGuideSite/indexSG.html">Study guide</a>
        <ul>
          <li><a href="/pharm/studyGuideSite/basicsFiles/basicsIndex.html">Basics</a></li>
          <li><a href="/pharm/studyGuideSite/PKsFiles/PKsIndex.html">Pharmacokinetics</a></li>
          <li><a href="/pharm/studyGuideSite/autonFiles/autonIndex.html">Autonomic system</a></li>
          <li><a href="/pharm/studyGuideSite/CNSFiles/CNSIndex.html">CNS</a></li>
          <li><a href="/pharm/studyGuideSite/cardioFiles/cardIndex.html">Cardiovascular system</a></li>
          <li><a href="/pharm/studyGuideSite/InfHoFiles/InfHoIndex.html">Inflammation and Hormones</a></li>
          <li><a href="/pharm/studyGuideSite/abFiles/abIndex.html">Antibiotics</a></li>
          <li><a href="/pharm/studyGuideSite/skinFiles/skinIndex.html">Skin</a></li>
          <li><a href="/pharm/studyGuideSite/lawFiles/lawIndex.html">Law</a></li>
        </ul>
      </li>
      <li><a class="daddy" href="/pharm/lectureSite/indexLec.html">Lectures</a>
        <ul>
          <li><a href="/pharm/lectureSite/indexLec.html#sem1">Semester 1</a></li>
          <li><a href="/pharm/lectureSite/indexLec.html#sem2">Semester 2</a></li>
          <li><a href="/pharm/lectureSite/indexLec.html#nurses">Nurses</a></li>
          
          <li><a href="/pharm/lectureSite/pharmapodcasts/index.html">podcasts</a></li>
        </ul>
      </li>
      <li><a href="/pharm/formSite/Aform.html">Formulary</a></li>
      <li><a href="/pharm/casesSite/indexCases.html">Cases</a></li>
      <li><a href="/pharm/search/search.asp">Search</a></li>
    </ul>
</div>

<div id="gototop"> <a href="#top"><b>top</b></a></div>
</body>
</html>