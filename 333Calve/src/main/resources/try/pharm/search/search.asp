<%
' ----------------------------------------------------------------------------
' Zoom Search Engine 5.1 (31/1/2008)
' Standard version for ASP
' A fast custom website search engine
' Copyright (C) Wrensoft 2000 - 2008
'
' email: zoom@wrensoft.com
' www: http://www.wrensoft.com
' ----------------------------------------------------------------------------
Dim UseUTF8, Charset, NoCharset, MapAccents, MinWordLen, Highlighting, GotoHighlight, PdfHighlight, TemplateFilename, FormFormat, Logging, LogFileName
Dim MaxKeyWordLineLen, DictIDLen, NumKeywords, NumPages, DictReservedLimit, DictReservedPrefixes, DictReservedSuffixes, DictReservedNoSpaces
Dim WordSplit, ZoomInfo, Timing, DefaultToAnd, SearchAsSubstring, ToLowerSearchWords, ContextSize, MaxContextKeywords, AllowExactPhrase
Dim MaxContextSeeks, UseLinkTarget, LinkTarget, UseDateTime, WordJoinChars, Spelling, SpellingWhenLessThan, NumSpellings, UseCats, LinkBackURL
Dim DisplayNumber, DisplayTitle, DisplayMetaDesc, DisplayContext, DisplayTerms, DisplayScore, DisplayURL, DisplayDate, Version, SearchMultiCats
Dim AccentChars, NormalChars, MaxMatches, StripDiacritics, UseZoomImage, Recommended, NumRecommended, RecommendedMax, DisplayFilesize

Dim STR_FORM_SEARCHFOR, STR_FORM_SUBMIT_BUTTON, STR_FORM_RESULTS_PER_PAGE, STR_FORM_CATEGORY, STR_FORM_CATEGORY_ALL, STR_FORM_MATCH
Dim STR_FORM_ANY_SEARCH_WORDS, STR_FORM_ALL_SEARCH_WORDS, STR_NO_QUERY, STR_RESULTS_FOR, STR_RESULTS_IN_ALL_CATEGORIES, STR_RESULTS_IN_CATEGORY
Dim STR_POWEREDBY, STR_NO_RESULTS, STR_RESULT, STR_RESULTS, STR_PHRASE_CONTAINS_COMMON_WORDS, STR_SKIPPED_FOLLOWING_WORDS
Dim STR_SKIPPED_PHRASE, STR_SUMMARY_NO_RESULTS_FOUND, STR_SUMMARY_FOUND_CONTAINING_ALL_TERMS, STR_SUMMARY_FOUND_CONTAINING_SOME_TERMS
Dim STR_SUMMARY_FOUND, STR_PAGES_OF_RESULTS, STR_POSSIBLY_GET_MORE_RESULTS, STR_ANY_OF_TERMS, STR_ALL_CATS, STR_DIDYOUMEAN, STR_SORTEDBY_RELEVANCE
Dim STR_SORTBY_RELEVANCE, STR_SORTBY_DATE, STR_SORTEDBY_DATE, STR_RESULT_TERMS_MATCHED, STR_RESULT_SCORE, STR_RESULT_URL, STR_RESULT_PAGES
Dim STR_RESULT_PAGES_PREVIOUS, STR_RESULT_PAGES_NEXT, STR_SEARCH_TOOK, STR_SECONDS, STR_MORETHAN, STR_MAX_RESULTS, STR_OR
Dim STR_RECOMMENDED

Dim zoomit, zoomfso, PerPageOptions
Dim query, queryForSearch, queryForHTML, queryForURL
Dim per_page, NewSearch, zoompage, andq, zoomsort, selfURL, zoomtarget
Dim zoomcat, num_zoom_cats, query_zoom_cats
Dim UseWildCards, SkippedOutputStr, SkippedWords, SkippedExactPhrase
Dim catnames, NumCats, catpages, catindex
Dim IsZoomQuery
Dim pageinfofile, pageinfo_count, pageinfoline, fp_pagedata, FoundEOL, pgdataline, templine, newlinepos
Dim LogQuery, DateString, LogString

%>
<!-- #include file="settings.asp" -->
<%
if (ScriptEngine <> "VBScript" OR ScriptEngineMajorVersion < 5) then
    Response.Write("This script requires VBScript 5.5 or later installed on the web server. Please download the latest Windows Script package from Microsoft and install this on your server, or consult your web host<br />")
    Response.End
end if
if (ScriptEngineMajorVersion = 5 AND ScriptEngineMinorVersion < 5 AND AllowExactPhrase = 1) then
    Response.Write("This script requires VBScript 5.5 or later installed on the web server. Please download the latest Windows Script package from Microsoft and install this on your server, or consult your web host<br />")
    Response.Write("Note that you may be able to run this on VBScript 5.1 if you have Exact Phrase matching disabled.<br />")
    Response.End
end if

Function MapPath(path)
    Dim IsHSP
    on error resume next
    IsHSP = Server.IsHSPFile
    if (err.Number = 0 AND IsHSP) then
        MapPath = Server.MapExternalPath(path) ' for HSP support
    else
        MapPath = Server.MapPath(path)
    end if
    on error goto 0
End Function

Function ConvertBinaryToString(Binary)
	Dim I, St
	For I = 1 To LenB(Binary)
		St = St & Chr(AscB(MidB(Binary, I, 1)))
	Next
	ConvertBinaryToString = St
End Function

Function GetPageData(index)
	fp_pagedata.Position = pgdataoffset(index)
	FoundEOL = False
	pgdataline = ""
	do while FoundEOL = False AND fp_pagedata.EOS = False
		templine = ConvertBinaryToString(fp_pagedata.Read(1024))		
		newlinepos = InStr(templine, vbCr)
		if (newlinepos > 0) then
			FoundEOL = True			
			templine = Left(templine, newlinepos)
		end if
		pgdataline = pgdataline & templine
	loop			
	GetPageData = Split(pgdataline, "|")
End Function

function unUDate(intTimeStamp)
	unUDate = DateAdd("s", intTimeStamp, "01/01/1970 00:00:00")
end function


' Check for dependant files
set zoomfso = CreateObject("Scripting.FileSystemObject")
if (zoomfso.FileExists(MapPath("settings.asp")) = False OR zoomfso.FileExists(MapPath("zoom_wordmap.zdat")) = FALSE OR zoomfso.FileExists(MapPath("zoom_dictionary.zdat")) = FALSE) then
    Response.Write("<b>Zoom files missing error:</b> Zoom is missing one or more of the required index data files.<br />Please make sure the generated index files are uploaded to the same path as this search script.<br />")
    Response.End
end if

' ----------------------------------------------------------------------------
' Settings
' ----------------------------------------------------------------------------

' The options available in the dropdown menu for number of results
' per page
PerPageOptions = Array(10, 20, 50, 100)

' Index format information
Dim PAGEDATA_URL, PAGEDATA_TITLE, PAGEDATA_DESC, PAGEDATA_IMG
Dim PAGEINFO_OFFSET, PAGEINFO_DATETIME, PAGEINFO_FILESIZE, PAGEINFO_CAT
PAGEDATA_URL = 0
PAGEDATA_TITLE = 1
PAGEDATA_DESC = 2
PAGEDATA_IMG = 3
PAGEINFO_OFFSET = 0
PAGEINFO_DATETIME = 1
PAGEINFO_FILESIZE = 2
PAGEINFO_CAT = 4

' ----------------------------------------------------------------------------
' Parameter initialisation
' ----------------------------------------------------------------------------
if (NoCharset = 0) then
    Response.Charset = Charset
end if

' we use the method=GET and 'zoom_query' parameter now (for sub-result pages etc)
IsZoomQuery = 0
if Request.QueryString("zoom_query").Count <> 0 then
    query = Request.QueryString("zoom_query")
	IsZoomQuery = 1
end if

' number of results per page, defaults to 10 if not specified
if Request.QueryString("zoom_per_page").Count <> 0 then
    per_page = Request.QueryString("zoom_per_page")
    if (per_page < 1) then
    	per_page = 1
    end if
else
    per_page = 10
end if

' current result page number, defaults to the first page if not specified
NewSearch = 0
if Request.QueryString("zoom_page").Count <> 0 then
    zoompage = Request.QueryString("zoom_page")
else
    zoompage = 1
    NewSearch = 1
end if

' AND operator.
' 1 if we are searching for ALL terms
' 0 if we are searching for ANY terms (default)
if Request.QueryString("zoom_and").Count <> 0 then
    andq = Request.QueryString("zoom_and")
elseif (IsEmpty(DefaultToAnd) = false AND DefaultToAnd = 1) then
    andq = 1
else
    andq = 0
end if

' categories
num_zoom_cats = 0
if Request.QueryString("zoom_cat[]").Count <> 0 then    	
	Redim zoomcat(Request.QueryString("zoom_cat[]").Count)
    num_zoom_cats = Request.QueryString("zoom_cat[]").Count
    for catit = 1 to num_zoom_cats
    	zoomcat(catit-1) = CInt(Request.QueryString("zoom_cat[]")(catit))
	next	
elseif Request.QueryString("zoom_cat").Count <> 0 then
	zoomcat = Array(Int(Request.QueryString("zoom_cat")))
	num_zoom_cats = 1
else
    zoomcat = Array(-1)
    num_zoom_cats = 1
end if

' for sorting options
' zero is default (relevance)
' 1 is sort by date (if date/time data is available)
if Request.QueryString("zoom_sort").Count <> 0 then
    zoomsort = Int(Request.QueryString("zoom_sort"))
else
    zoomsort = 0
end if

if (IsEmpty(LinkBackURL)) then
    selfURL = Request.ServerVariables("URL")
else
    selfURL = LinkBackURL
end if

zoomtarget = ""
if (UseLinkTarget = 1) then
    zoomtarget = " target=""" & LinkTarget & """ "
end if

Sub PrintEndOfTemplate
    'Let others know about Zoom.
    if (ZoomInfo = 1) then
        Response.Write("<center><p><small>" & STR_POWEREDBY & " <a href=""http://www.wrensoft.com/zoom/"" target=""_blank""><b>Zoom Search Engine</b></a></small></p></center>") & VbCrlf
    end if
    if (UBound(Template) > 0) then
        'If rest of template exists
        Response.Write(Template(1)) & VbCrLf
    end if
End Sub


' Translate a wildcard pattern to a regexp pattern
' Supports '*' and '?' only at the moment.
Function pattern2regexp(orig_pattern)
    ' ASP/VBScript's RegExp has some 7-bit ASCII char issues
    ' and treats accented characters as an end of word for boundaries ("\b")
    ' So we use ^ and $ instead, since we're matching single words anyway
    
    ' make a copy of the original pattern first (otherwise the changes are applied to the source)
    Dim pattern
    pattern = orig_pattern    
    ' we have to do this first before we introduce any other regexp patterns
    pattern = Replace(pattern, "\", "\\")

    if (InStr(pattern, "#") <> False) then
        pattern = Replace(pattern, "#", "\#")
    end if

    if (InStr(pattern, "$") <> False) then
        pattern = Replace(pattern, "$", "\$")
    end if

    pattern = Replace(pattern, ".", "\.")
    pattern = Replace(pattern, "*", "[\d\S]*")
    pattern = Replace(pattern, "?", ".")        
    pattern2regexp = pattern
End Function

'Returns true if a value is found within the array
Function IsInArray(strValue, arrayName)
    Dim iLoop, bolFound
    IsInArray = False
    if (IsArray(arrayName) = False) then
        Exit Function
    End if
    For iLoop = 0 to UBound(arrayName)
        if (CStr(arrayName(iLoop)) = CStr(strvalue)) then
            IsInArray = True
            Exit Function
        end if
    Next
End Function

Sub SkipSearchWord(sw)
    if (SearchWords(sw) <> "") then
        if (SkippedWords > 0) then
            SkippedOutputStr = SkippedOutputStr & ", "
        end if
        SkippedOutputStr = SkippedOutputStr & """<b>" & SearchWords(sw) & "</b>"""
        SearchWords(sw) = ""
    end if
    SkippedWords = SkippedWords + 1
End Sub

Function PrintHighlightDescription(line)
	if (Highlighting = 0) then
		Response.Write(line)
		Exit Function
	end if		
    For zoomit = 0 to numwords-1
        if Len(RegExpSearchWords(zoomit)) > 0 then
            if (SearchAsSubstring = 1) then
                regExp.Pattern = "(" & RegExpSearchWords(zoomit) & ")"
                line = regExp.Replace(line, "[;:]$1[:;]")
            else
                regExp.Pattern = "(\W|^|\b)(" & RegExpSearchWords(zoomit) & ")(\W|$|\b)"
                line = regExp.Replace(line, "$1[;:]$2[:;]$3")
            end if
        end if
    Next

    line = replace(line, "[;:]", "<span class=""highlight"">")
    line = replace(line, "[:;]", "</span>")
    Response.Write(line)
End Function

Function PrintNumResults(num)
    if (num = 0) then
        PrintNumResults = STR_NO_RESULTS
    elseif (num = 1) then
        PrintNumResults = num & " " & STR_RESULT
    else
        PrintNumResults = num & " " & STR_RESULTS
    end if
End Function

Function AddParamToURL(url, paramStr)
    if (InStr(url, "?") <> 0) then
        AddParamToURL = url & "&amp;" & paramStr
    else
        AddParamToURL = url & "?" & paramStr
    end if
End Function

Function SplitMulti(string, delimiters)
    For zoomit = 1 to UBound(delimiters)
        string = Replace(string, delimiters(zoomit), delimiters(0))
    Next
    string = Trim(string)   'for replaced quotes
    SplitMulti = Split(string, delimiters(0))
End Function

Sub ShellSort(array)
    Dim first, last, num, distance, index, index2
    Dim value, value0, value2, value3, value4, value5
    last = UBound(array, 2)
    first = 0	'LBound(array, 2)
    num = last - first + 1
    ' find the best value for distance
    do
        distance = distance * 3 + 1
    loop until (distance > num)
    do
        distance = distance \ 3
        for index = (distance + first) to last
            value = array(1, index)
            value0 = array(0, index)
            value2 = array(2, index)
            value3 = array(3, index)
            value4 = array(4, index)
            value5 = array(5, index)
            index2 = index
            do while (index2 - distance => first)
                if (array(2, index2 - distance) > value2) then
                    exit do
                end if
                if (array(2, index2 - distance) = value2) then
                    if (array(1, index2 - distance) >= value) then
                        exit do
                    end if
                end if
                array(0, index2) = array(0, index2 - distance)
                array(1, index2) = array(1, index2 - distance)
                array(2, index2) = array(2, index2 - distance)
                array(3, index2) = array(3, index2 - distance)
                array(4, index2) = array(4, index2 - distance)
                array(5, index2) = array(5, index2 - distance)
                index2 = index2 - distance
            loop
            array(1, index2) = value
            array(0, index2) = value0
            array(2, index2) = value2
            array(3, index2) = value3
            array(4, index2) = value4
            array(5, index2) = value5
        next
    loop until distance = 1
End Sub

Sub ShellSortByDate(array, datetime)
    dim first, last, num, distance, index, index2
    dim value, value0, value2, value3, value4, value5
    last = UBound(array, 2)
    first = 0	'LBound(array, 2)
    num = last - first + 1
    ' find the best value for distance
    do
        distance = distance * 3 + 1
    loop until (distance > num)
    do
        distance = distance \ 3
        for index = (distance + first) to last
            value = array(1, index)
            value0 = array(0, index)
            value2 = array(2, index)
            value3 = array(3, index)
            value4 = array(4, index)
            value5 = array(5, index)
            index2 = index
            do while (index2 - distance => first)
                'if (cdate(datetime(array(0, index2 - distance))) > cdate(datetime(value0))) then
                if (datetime(array(0, index2 - distance)) > datetime(value0)) then
                    exit do
                end if
                if (datetime(array(0, index2 - distance)) = datetime(value0)) then
                    if (array(2, index2 - distance) >= value2) then
                        exit do
                    end if
                end if
                array(0, index2) = array(0, index2 - distance)
                array(1, index2) = array(1, index2 - distance)
                array(2, index2) = array(2, index2 - distance)
                array(3, index2) = array(3, index2 - distance)
                array(4, index2) = array(4, index2 - distance)
                array(5, index2) = array(5, index2 - distance)
                index2 = index2 - distance
            loop
            array(1, index2) = value
            array(0, index2) = value0
            array(2, index2) = value2
            array(3, index2) = value3
            array(4, index2) = value4
            array(5, index2) = value5
        next
    loop until distance = 1
End Sub


Function GetBytes(binfile, bytes)
    bytes_buffer = binfile.Read(bytes)
    GetBytes = 0
    bytes_count = LenB(bytes_buffer)
    for k = 1 to bytes_count
        GetBytes = GetBytes +  Ascb(Midb(bytes_buffer, k, 1)) * (256^(k-1))
    next
End Function

Function GetNextDictWord(bin_pagetext)
    Dim dict_id    
    GetNextDictWord = GetBytes(bin_pagetext, DictIDLen)    
End Function

Function GetDictID(word)

    GetDictID = -1
    
    if (ToLowerSearchWords = 1) then
		word = Lcase(word)
    end if
    
    for zoomit = 0 to dict_count
    
    	dictword = dict(0, zoomit)
    	if (ToLowerSearchWords = 1) then
			dictword = Lcase(dictword)
        end if
    	
        if (dictword = word) then
            GetDictID = zoomit
            exit for
        end if
    next
End Function

' Custom read file method to avoid TextStream's ReadAll function
' which fails to scale reliably on certain machines/setups.
function ReadDatFile(zoomfso, filename)
    Dim fileObj, tsObj
    set fileObj = zoomfso.GetFile(MapPath(filename))
    set tsObj = fileObj.OpenAsTextStream(1, 0)
    ReadDatFile = tsObj.Read(fileObj.Size)
    tsObj.Close
end function

function GetSPCode(word)
    Dim metalen, tmpword, strPtr, wordlen
    metalen = 4

    ' initialize return variable
    GetSPCode = ""

    tmpword = UCase(word)

    wordlen = Len(tmpword)
    if wordlen < 1 then
        Exit Function
    end if

    ' if ae, gn, kn, pn, wr then drop the first letter
    strPtr = Left(tmpword, 2)
    if (strPtr = "AE" OR strPtr = "GN" OR strPtr = "KN" OR strPtr = "PN" OR strPtr = "WR") then
        tmpword = Right(tmpword, wordlen-1)
    end if

    ' change x to s
    if (Left(tmpword, 1) = "X") then
        tmpword = "S" & Right(tmpword, wordlen-1)
    end if

    ' get rid of the 'h' in "wh"
    if (Left(tmpword, 2) = "WH") then
        tmpword = "W" & Right(tmpword, wordlen-2)
    end if

    ' update the word length
    wordlen = Len(tmpword)    

    ' remove an 's' from the end of the string
    if (Right(tmpword, 1) = "S") then
        tmpword = Left(tmpword, wordlen-1)
        wordlen = Len(tmpword)
    end if

    Dim i, char, vowelBefore, Continue, silent
    Dim prevChar, nextChar, vowelAfter, frontvAfter, nextChar2, lastChr, nextChar3
    lastChr = wordlen

    i = 1
    do while (i <= wordlen AND Len(GetSPCode) < metalen)
        char = Mid(tmpword, i, 1)
        vowelBefore = False
        Continue = False
        if (i > 1) then
            prevChar = Mid(tmpword, i-1, 1)
            if (prevChar = "A" OR prevChar = "E" OR prevChar = "I" OR prevChar = "O" OR prevChar = "U") then
                vowelBefore = True
            end if
        else
            prevChar = ""
            if (char = "A" OR char = "E" OR char = "I" OR char = "O" OR char = "U") then
                GetSPCode = Left(tmpword, 1)
                Continue = True
            end if
        end if

        if (Continue = False) then
            vowelAfter = False
            frontvAfter = False
            nextChar = ""
            if (i < wordlen) then
                nextChar = Mid(tmpword, i+1, 1)
                if (nextChar = "A" OR nextChar = "E" OR nextChar = "I" OR nextChar = "O" OR nextChar = "U") then
                    vowelAfter = True
                end if
                if (nextChar = "E" OR nextChar = "I" OR nextChar = "Y") then
                    frontvAfter = True
                end if
            end if

            ' skip double letters except ones in list
            if (char = nextChar AND (nextChar <> ".")) then
                Continue = True
            end if

            if (Continue = False) then
                nextChar2 = ""
                if (i < (lastChr-1)) then
                    nextChar2 = Mid(tmpword, i+2, 1)
                end if

                nextChar3 = ""
                if (i < (lastChr-2)) then
                    nextChar3 = Mid(tmpword, i+3, 1)
                end if

                if (char = "B") then
                    silent = False
                    if (i = wordlen AND prevChar = "M") then
                        silent = True
                    end if
                    if (silent = False) then
                        GetSPCode = GetSPCode & char
                    end if
                elseif (char = "C") then
                    if (NOT(i > 2 AND prevChar = "S" AND frontvAfter)) then
                        if (i > 1 AND nextChar = "I" AND nextChar2 = "A") then
                            GetSPCode = GetSPCode & "X"
                        elseif (frontvAfter) then
                            GetSPCode = GetSPCode & "S"
                        elseif (i > 2 AND prevChar = "S" AND nextChar = "H") then
                            GetSPCode = GetSPCode & "K"
                        else
                            if (nextChar = "H") then
                                if (i = 1 AND (nextChar2 <> "A" AND nextChar2 <> "E" AND nextChar3 <> "I" AND nextChar3 <> "O" AND nextChar3 <> "U")) then
                                    GetSPCode = GetSPCode & "K"
                                else
                                    GetSPCode = GetSPCode & "X"
                                end if
                            else
                                if (prevChar = "C") then
                                    GetSPCode = GetSPCode & "C"
                                else
                                    GetSPCode = GetSPCode & "K"
                                end if
                            end if
                        end if
                    end if
                elseif (char = "D") then
                    if (nextChar = "G" AND (nextChar2 = "E" OR nextChar2 = "I" OR nextChar3 = "Y")) then
                        GetSPCode = GetSPCode & "J"
                    else
                        GetSPCode = GetSPCode & "T"
                    end if
                elseif (char = "G") then
                    silent = False
                    ' silent -gh- except for -gh and no vowel after h
                    if ((i < (wordlen-1) AND nextChar = "H") AND (nextChar2 <> "A" AND nextChar2 <> "E" AND nextChar2 <> "I" AND nextChar2 <> "O" AND nextChar2 <> "U")) then
                        silent = True
                    end if

                    if (i = (wordlen-3) AND nextChar = "N" AND nextChar2 = "E" AND nextChar3 = "D") then
                        silent = True
                    else
                        if ((i = (wordlen-1)) AND nextChar = "N") then
                            silent = True
                        end if
                    end if

                    if (prevChar = "D" AND frontvAfter) then
                        silent = True
                    end if

                    if (prevChar = "G") then
                        hard = True
                    else
                        hard = False
                    end if

                    if (silent = False) then
                        if (frontvAfter AND (NOT hard)) then
                            GetSPCode = GetSPCode & "J"
                        else
                            GetSPCode = GetSPCode & "K"
                        end if
                    end if
                elseif (char = "H") then
                    silent = False
                    'variable sound - those modified by adding a "H"
                    if (prevChar = "C" OR prevChar = "S" OR prevChar = "P" OR prevChar = "T" OR prevChar = "G") then
                        silent = True
                    end if
                    if (vowelBefore AND NOT vowelAfter) then
                        silent = True
                    end if
                    if (NOT silent) then
                        GetSPCode = GetSPCode & char
                    end if
                elseif (char = "F" OR char = "J" OR char = "L" OR char = "M" OR char = "N" OR char = "R") then
                    GetSPCode = GetSPCode & char
                elseif (char = "K") then
                    if (prevChar <> "C") then
                        GetSPCode = GetSPCode & char
                    end if
                elseif (char = "P") then
                    if (nextChar = "H") then
                        GetSPCode = GetSPCode & "F"
                    else
                        GetSPCode = GetSPCode & "P"
                    end if
                elseif (char = "Q") then
                    GetSPCode = GetSPCode & "K"
                elseif (char = "S") then
                    if (i > 2 AND nextChar = "I" AND (nextChar2 = "O" OR nextChar2 = "A")) then
                        GetSPCode = GetSPCode & "X"
                    elseif (nextChar = "H") then
                        GetSPCode = GetSPCode & "X"
                    else
                        GetSPCode = GetSPCode & "S"
                    end if
                elseif (char = "T") then
                    if (i > 2 AND nextChar = "I" AND (nextChar2 = "O" OR nextChar2 = "A")) then
                        GetSPCode = GetSPCode & "X"
                    elseif (nextChar = "H") then    'the=0, tho=T, withrow=0
                        if (i > 1 OR (nextChar2 = "A" OR nextChar2 = "E" OR nextChar2 = "I" OR nextChar = "O" OR nextChar2 = "U")) then
                            GetSPCode = GetSPCode & "0"
                        else
                            GetSPCode = GetSPCode & "T"
                        end if
                    elseif (NOT (i < (wordlen-2) AND nextChar = "C" AND nextChar2 = "H")) then
                        GetSPCode = GetSPCode & "T"
                    end if
                elseif (char = "V") then
                    GetSPCode = GetSPCode & "F"
                elseif (char = "W" OR char = "Y") then
                    if (i < wordlen AND vowelAfter) then
                        GetSPCode = GetSPCode & char
                    end if
                elseif (char = "X") then
                    GetSPCode = GetSPCode & "KS"
                elseif (char = "Z") then
                    GetSPCode = GetSPCode & "S"
                end if
            end if
        end if
        i = i + 1
    Loop
    if (Len(GetSPCode) = 0) then
        GetSPCode = ""
        Exit Function
    end if
end function

function Encode(str)
    Encode = str
    Encode = Replace(Encode, "&", "&#38;")    
    Encode = Replace(Encode, "<", "&#60;")
    Encode = Replace(Encode, ">", "&#62;")    
end function

function htmlspecialchars(str)
    htmlspecialchars = str
    htmlspecialchars = Replace(htmlspecialchars, "&", "&#38;")    
    htmlspecialchars = Replace(htmlspecialchars, "<", "&#60;")
    htmlspecialchars = Replace(htmlspecialchars, ">", "&#62;")
    htmlspecialchars = Replace(htmlspecialchars, """", "&#34;")
    htmlspecialchars = Replace(htmlspecialchars, "'", "&#39;")
end function

function Ceil(byVal a)
    if (a - Int(a)) = 0 then
        Ceil = a
    else
        Ceil = Int(1 + a)
    end if
end function

' Debug stop watches to time performance of sub-sections
Dim StopWatch(10)
Dim TimerCount, DebugTimerSum
TimerCount = 0
DebugTimerSum = 0
sub StartTimer()
    StopWatch(TimerCount) = timer
    TimerCount = TimerCount + 1
end sub
function StopTimer()
    EndTime = Timer
    TimerCount = TimerCount - 1
    StopTimer = EndTime - StopWatch(TimerCount)
end function

' ----------------------------------------------------------------------------
' Main starts here
' ----------------------------------------------------------------------------

' For timing of the search
if (Timing = 1 OR Logging = 1) then
    Dim StartTime, ElapsedTime
    StartTime = Timer
end if

'Open and print start of result page template
Dim fp_template, Template
set fp_template = zoomfso.OpenTextFile(MapPath(TemplateFilename), 1)
' find the "<!--ZOOMSEARCH-->" string in the template html file
dim line, templateFile
do while fp_template.AtEndOfStream <> True
    line = fp_template.ReadLine & VbCrLf
    templateFile = templateFile & line
loop
fp_template.Close
Template = split(templateFile, "<!--ZOOMSEARCH-->")
Response.Write(Template(0)) & VbCrLf

'' Check for category files
if (UseCats = 1) then
    if (zoomfso.FileExists(MapPath("zoom_cats.zdat")) = True) then
        ' Loads the entire categories page into an array
        catnames = split(ReadDatFile(zoomfso, "zoom_cats.zdat"), chr(10))        
        NumCats = UBound(catnames)        
    else
        Response.Write("Missing file zoom_cats.zdat required for category enabled search mode")
        Response.End
    end if
end if
Response.Write("<!--Zoom Search Engine " & Version & "-->") & VbCrLf


Dim ppo

' Replace the key text <!--ZOOMSEARCH--> with the following
if (FormFormat > 0) then
    ' Insert the form
    Response.Write("<form method=""get"" action=""" & selfURL & """ class=""zoom_searchform"">") & VbCrlf
    Response.Write(STR_FORM_SEARCHFOR & " <input type=""text"" name=""zoom_query"" size=""20"" value=""" & htmlspecialchars(query) & """ class=""zoom_searchbox"" />") & VbCrlf
    Response.Write("<input type=""submit"" value=""" & STR_FORM_SUBMIT_BUTTON & """ class=""zoom_button"" /> ") & VbCrlf
    if (FormFormat = 2) then
        Response.Write("<span class=""zoom_results_per_page"">" & STR_FORM_RESULTS_PER_PAGE) & VbCrlf
        Response.Write("<select name=""zoom_per_page"">") & VbCrlf
        For Each ppo In PerPageOptions
            Response.Write("<option")
            if (Int(ppo) = Int(per_page)) then
                Response.Write(" selected=""selected""")
            end if
            Response.Write(">" & ppo & "</option>") & VbCrLf
        next
        Response.Write("</select><br /><br /></span>") & VbCrlf

        if (UseCats = 1) then
        	Response.Write("<span class=""zoom_categories"">") & VbCrlf
            Response.Write(STR_FORM_CATEGORY & " ") & VbCrlf
            if (SearchMultiCats = 1) then
        		Response.Write("<ul>") & VbCrlf        		        		
        		Response.Write("<li><input type=""checkbox"" name=""zoom_cat[]"" value=""-1""")        		
        		if (zoomcat(0) = -1) then
	        		Response.Write(" checked=""checked""")
	        	end if
	        	Response.Write(">" & STR_FORM_CATEGORY_ALL & "</input></li>")	        	
	        	for zoomit = 0 to NumCats-1
        			Response.Write("<li><input type=""checkbox"" name=""zoom_cat[]"" value=""" & zoomit & """")
        			if (zoomcat(0) <> -1) then
        				for catit = 0 to num_zoom_cats-1
        					if (zoomit = zoomcat(catit)) then
        						Response.Write(" checked=""checked""")
        						exit for
        					end if
        				next
	        		end if
        			Response.Write(">" & catnames(zoomit) & "</input></li>") & VbCrlf
        		next
        		Response.Write("</ul><br /><br />") & VbCrlf            	
        	else
	            Response.Write("<select name=""zoom_cat[]"">") & VbCrlf
	            Response.Write("<option value=""-1"">" & STR_FORM_CATEGORY_ALL & "</option>")
	            for zoomit = 0 to NumCats-1
	                Response.Write("<option value=""" & zoomit & """")
	                if (zoomit = zoomcat(0)) then
	                    Response.Write(" selected=""selected""")
	                end if
	                Response.Write(">" & catnames(zoomit) & "</option>")
	            Next
	            Response.Write("</select>&nbsp;&nbsp;") & VbCrlf
	    	end if
	    	Response.Write("</span>") & VbCrlf
        end if
        Response.Write("<span class=""zoom_match"">" & STR_FORM_MATCH) & VbCrlf
        if (andq = 0) then
            Response.Write("<input type=""radio"" name=""zoom_and"" value=""0"" checked=""checked"" />" & STR_FORM_ANY_SEARCH_WORDS) & VbCrlf
            Response.Write("<input type=""radio"" name=""zoom_and"" value=""1"" />" & STR_FORM_ALL_SEARCH_WORDS) & VbCrlf
        else
            Response.Write("<input type=""radio"" name=""zoom_and"" value=""0"" />" & STR_FORM_ANY_SEARCH_WORDS) & VbCrlf
            Response.Write("<input type=""radio"" name=""zoom_and"" value=""1"" checked=""checked"" />" & STR_FORM_ALL_SEARCH_WORDS) & VbCrlf
        end if
        Response.Write("<input type=""hidden"" name=""zoom_sort"" value=""" & zoomsort & """ />") & VbCrLf
        Response.Write("<br /><br /></span>") & VbCrlf
    else
        Response.Write("<input type=""hidden"" name=""zoom_per_page"" value=""" & per_page & """ />") & VbCrLf
        Response.Write("<input type=""hidden"" name=""zoom_and"" value=""" & andq & """ />") & VbCrLf
        Response.Write("<input type=""hidden"" name=""zoom_sort"" value=""" & zoomsort & """ />") & VbCrLf
    end if

    Response.Write("</form>") & VbCrlf
end if

' Give up early if no search words provided
Dim NoSearch
NoSearch = 0
if (Len(query) = 0) then
    if (IsZoomQuery = 1) then
        Response.Write(STR_NO_QUERY & "<br />")
    end if
    'stop here, but finish off the html
    'call PrintEndOfTemplate
    'Response.End no longer used to allow for search.asp to follow through the original file
    'when it is used in in an #include
    NoSearch = 1
end if

if (NoSearch = 0) then

    ' Load index data files (*.zdat) ----------------------------------------------
    Dim datefile, dates_count
    Dim dictfile, dict_count, dictline
    
    ' load in recommended    
    if (Recommended = 1) then    	
	    recfile = split(ReadDatFile(zoomfso, "zoom_recommended.zdat"), chr(10))
	    rec_count = UBound(recfile)
	    dim rec()
	    redim rec(2, rec_count)
	    for zoomit = 0 to rec_count-1	        
	        sep = InstrRev(recfile(zoomit), " ")
	        if (sep > 0) then
	        	rec(0, zoomit) = Left(recfile(zoomit), sep)
	        	rec(1, zoomit) = Mid(recfile(zoomit), sep)
	    	end if	    		    	
	    next
	    ' re-value dict_count in case of errors in dict file
	    rec_count = UBound(rec, 2)
	end if
    
    'Load the pageinfo file    
    pageinfofile = split(ReadDatFile(zoomfso, "zoom_pageinfo.zdat"), chr(10))
    pageinfo_count = UBound(pageinfofile)
    dim pgdataoffset()
    dim datetime()
    dim filesize()	    
    redim pgdataoffset(pageinfo_count)
    if (UseDateTime = 1 OR DisplayDate = 1) then
     	redim datetime(pageinfo_count)
    end if
    if (DisplayFilesize = 1) then
      	redim filesize(pageinfo_count)
    end if
    if (UseCats = 1) then
      	redim catpages(pageinfo_count)
    end if                                
    for zoomit = 0 to pageinfo_count-1
    	if (len(pageinfofile(zoomit)) > 2) then
	      	pageinfoline = split(pageinfofile(zoomit), "|")        	
	      	pgdataoffset(zoomit) = pageinfoline(PAGEINFO_OFFSET)
	      	if (UseDateTime = 1 OR DisplayDate = 1) then
	      		if (IsNumeric(pageinfoline(PAGEINFO_DATETIME))) then   			
	      			datetime(zoomit) = CLng(pageinfoline(PAGEINFO_DATETIME))      	      	
	      		else
	      			datetime(zoomit) = 0
	      		end if      		
	        end if        
	        if (DisplayFilesize = 1) then
	          	filesize(zoomit) = CLng(pageinfoline(PAGEINFO_FILESIZE) / 1024)
	          	if (filesize(zoomit) < 1) then
	          		filesize(zoomit) = 1
	          	end if
	        end if        
	        if (UseCats = 1) then
	           	catpages(zoomit) = pageinfoline(PAGEINFO_CAT)
	        end if        
		end if
    next   
    
    ' open the pagedata file
    set fp_pagedata = CreateObject("ADODB.Stream")
    fp_pagedata.Type = 1   ' stream type = binary
    fp_pagedata.Open       ' open stream
    fp_pagedata.LoadFromFile MapPath("zoom_pagedata.zdat")  'load file to stream     	
       	
	' load in pagetext file
    if (DisplayContext = 1 OR AllowExactPhrase = 1) then
        Dim bin_pagetext, tmpstr
        set bin_pagetext = CreateObject("ADODB.Stream")
        bin_pagetext.Type = 1   ' stream type = binary
        bin_pagetext.Open       ' open stream
        bin_pagetext.LoadFromFile MapPath("zoom_pagetext.zdat")  'load file to stream

        'check for blank message
        tmpstr = CStr(bin_pagetext.Read(8))        
        if (tmpstr = "This") then
            Response.Write("<b>Zoom config error:</b> The zoom_pagetext.zdat file is not properly created for the search settings specified.<br />Please check that you have re-indexed your site with the search settings selected in the configuration window.<br />")
            Response.End
        end if    
    end if

    ' load in dictionary file
    dictfile = split(ReadDatFile(zoomfso, "zoom_dictionary.zdat"), chr(10))
    dict_count = UBound(dictfile)
    dim dict()
    redim dict(2, dict_count)
    for zoomit = 0 to dict_count
        dictline = Split(dictfile(zoomit), " ")
        if (UBound(dictline) = 1) then
            dict(0, zoomit) = dictline(0)
            dict(1, zoomit) = dictline(1)
        end if
    next
    ' re-value dict_count in case of errors in dict file
    dict_count = UBound(dict, 2)

    ' load in wordmap file
    Dim bfp_wordmap
    set bfp_wordmap = CreateObject("ADODB.Stream")
    bfp_wordmap.Type = 1    'Specify stream type - we want To get binary data.
    bfp_wordmap.Open        'Open the stream
    bfp_wordmap.LoadFromFile MapPath("zoom_wordmap.zdat")

    'Initialise regular expression object
    Dim regExp
    set regExp = New RegExp
    regExp.Global = True
    if (ToLowerSearchWords = 0) then
        regExp.IgnoreCase = False
    else
        regExp.IgnoreCase = True
    end if

    ' Prepare query for search -----------------------------------------------------

    'Split search phrase into words

    if (MapAccents = 1) then
        For zoomit = 0 to UBound(NormalChars)
            query = Replace(query, AccentChars(zoomit), NormalChars(zoomit))
        Next
    end if
       
    if (AllowExactPhrase = 0) then
        query = Replace(query, """", " ")
    end if
    if (InStr(WordJoinChars, ".") = False) then
        query = Replace(query, ".", " ")
    end if
    if (InStr(WordJoinChars, "-") = False) then
        regExp.Pattern = "(\S)-"
        query = regExp.Replace(query, "$1 ")        
    end if
    if (InStr(WordJoinChars, "#") = False) then
    	regExp.Pattern = "#(\S)"
        query = regExp.Replace(query, " $1")                
    end if
    if (InStr(WordJoinChars, "+") = False) then    		    	
    	regExp.Pattern = "[\+]+([^\+\s])"
        query = regExp.Replace(query, " $1")                
		regExp.Pattern = "([^\+\s])\+\s"
        query = regExp.Replace(query, "$1 ")                        
    end if
    
    if (InStr(WordJoinChars, "_") = False) then
        query = Replace(query, "_", " ")
    end if
    if (InStr(WordJoinChars, "'") = False) then
        query = Replace(query, "'", " ")
    end if    
    if (InStr(WordJoinChars, "$") = False) then
        query = Replace(query, "$", " ")
    end if
    if (InStr(WordJoinChars, ",") = False) then
        query = Replace(query, ",", " ")
    end if
    if (InStr(WordJoinChars, ":") = False) then
        query = Replace(query, ":", " ")
    end if
    if (InStr(WordJoinChars, "&") = False) then
        query = Replace(query, "&", " ")
    end if
    if (InStr(WordJoinChars, "/") = False) then
        query = Replace(query, "/", " ")
    end if
    if (InStr(WordJoinChars, "\") = False) then    	    	
        query = Replace(query, "\", " ")        
    end if
    
    ' Strip slashes, sloshes, parenthesis and other regexp elements
    ' also strip any of the wordjoinchars if followed immediately by a space
    regExp.Pattern = "[\s\(\)\^\[\]\|\{\}\%]+|[\.\-\_\'\,\:\&\/\\](\s|$)"
    query = regExp.Replace(query, " ")

    ' update the encoded/output query with our changes
	queryForHTML = htmlspecialchars(query)
	if (ToLowerSearchWords = 1) then
		queryForSearch = Lcase(query)
	else
    	queryForSearch = query
	end if    

    ' Split exact phrase terms if found
    dim SearchWords, quote_terms, term, exclude_terms, tmp_query
    quote_terms = Array()
    exclude_terms = Array()
    tmp_query = queryForSearch
    if (InStr(queryForSearch, """")) then
        regExp.Pattern = """.*?""|-"".*?"""
        set quote_terms = regExp.Execute(queryForSearch)
        tmp_query = regExp.Replace(tmp_query, "")
    end if
    if (InStr(queryForSearch, "-")) then
        regExp.Pattern = "(\s|^)-.*?(?=\s|$)"
        set exclude_terms = regExp.Execute(tmp_query)
        tmp_query = regExp.Replace(tmp_query, "")
    end if
    tmp_query = Trim(tmp_query)
    regExp.Pattern = "[\s]+"
    tmp_query = regExp.Replace(tmp_query, " ")
    SearchWords = Split(tmp_query, " ")
    'SearchWords = SplitMulti(tmp_query, Array(" ", "_", "[", "]", "+", ","))

    zoomit = UBound(SearchWords)
    for each term in quote_terms
        zoomit = zoomit + 1
        redim preserve SearchWords(zoomit)
        SearchWords(zoomit) = Replace(term, """", "")
    next

    ' add exclusion search terms (make sure we put them last)
    zoomit = UBound(SearchWords)
    for each term in exclude_terms
        zoomit = zoomit + 1
        redim preserve SearchWords(zoomit)
        SearchWords(zoomit) = Trim(term)
    next

	query_zoom_cats = ""
	
    'Print heading    
    Response.Write("<div class=""searchheading"">" & STR_RESULTS_FOR & " " & queryForHTML)    
    if (UseCats = 1) then
        if (zoomcat(0) = -1) then
            Response.Write(" " & STR_RESULTS_IN_ALL_CATEGORIES)
            query_zoom_cats = "&amp;zoom_cat=-1"
        else
            Response.Write(" " & STR_RESULTS_IN_CATEGORY & " ")
            for catit = 0 to num_zoom_cats-1
            	if (catit > 0) then
            		Response.Write(", ")
            	end if
            	Response.Write("""" & catnames(zoomcat(catit)) & """")            		
            	query_zoom_cats = query_zoom_cats & "&amp;zoom_cat%5B%5D=" & zoomcat(catit)
        	next                        
        end if
    end if
    Response.Write("<br /><br /></div>") & VbCrlf

    Response.Write("<div class=""results"">") & VbCrLf

    ' Begin main search loop ------------------------------------------------------
    Dim numwords, outputline, pagesCount, matches, relative_pos, current_pos
    Dim context_maxgoback
    Dim exclude_count, ExcludeTerm

    'Loop through all search words
    numwords = UBound(SearchWords)+1
    outputline = 0

    'default to use wildcards
    UseWildCards = 1

    ' Check for skipped words in search query
    SkippedWords = 0
    SkippedOutputStr = ""
    SkippedExactPhrase = 0

    pagesCount = NumPages
    Dim res_table()
    Redim preserve res_table(5, pagesCount)

    matches = 0

    relative_pos = 0
    current_pos = 0

    dim data

    dim phrase_data_count()
    dim phrase_terms_data()
    dim xdata()
    dim countbytes

    exclude_count = 0
    context_maxgoback = 1

    redim sw_results(numwords)
    redim UseWildCards(numwords)
    redim RegExpSearchWords(numwords)
    
    for sw = 0 to numwords-1
    	sw_results(sw) = 0
    	UseWildCards(sw) = 0
    	
    	if (InStr(SearchWords(sw), "*") <> 0 OR InStr(SearchWords(sw), "?") <> 0) then            
            RegExpSearchWords(sw) = pattern2regexp(SearchWords(sw))            
	        UseWildCards(sw) = 1
        end if

        if (Highlighting = 1 AND UseWildCards(sw) = 0) then
        	RegExpSearchWords(sw) = SearchWords(sw)
    	    if (InStr(RegExpSearchWords(sw), "\")) then    	    	
		        RegExpSearchWords(sw) = Replace(RegExpSearchWords(sw), "\", "\\") 		        		        
    		end if    		
    	end if            
	next 

    Dim sw, bSkipped, ExactPhrase, patternStr, WordNotFound, word, ptr, bMatched, bytes_buffer, bytes_count
    Dim j, k, data_count, score, ipage, txtptr, GotoNextPage, FoundPhrase, pageexists, xdictword

    for sw = 0 to numwords-1

        'initialize the sw_results here, since redim won't do it
        sw_results(sw) = 0

        bSkipped = False

        if (SearchWords(sw) = "") then
            bSkipped = True
        end if

        if (len(SearchWords(sw)) < MinWordLen) then
            SkipSearchWord(sw)
            bSkipped = True
        end if

        if (bSkipped = False) then

            ExactPhrase = 0            
            ExcludeTerm = 0

            ' Check exclusion searches
            if (Left(SearchWords(sw), 1) = "-") then
                SearchWords(sw) = Right(SearchWords(sw), len(SearchWords(sw))-1)
                SearchWords(sw) = Trim(SearchWords(sw))
                ExcludeTerm = 1
                exclude_count = exclude_count + 1
            end if

            if (AllowExactPhrase = 1 AND InStr(SearchWords(sw), " ") <> 0) then
                ' initialise exact phrase matching for this search 'term'
                Dim phrase_terms, num_phrase_terms, tmpid, wordmap_row, xbi

                ExactPhrase = 1
                phrase_terms = Split(SearchWords(sw), " ")
                num_phrase_terms = UBound(phrase_terms)+1
                if (num_phrase_terms > context_maxgoback) then
                    context_maxgoback = num_phrase_terms
                end if

                tmpid = 0
                WordNotFound = 0
                for j = 0 to num_phrase_terms-1
                    tmpid = GetDictID(phrase_terms(j))
                    if (tmpid = -1) then
                        WordNotFound = 1
                        exit for
                    end if
                    'Response.Write("dict: " & dict(1, tmpid))
                    wordmap_row =Int(dict(1, tmpid))
                    'Response.Write("wordmap_row:" & wordmap_row)
                    if (wordmap_row <> -1) then
                        bfp_wordmap.Position = wordmap_row
                        if (bfp_wordmap.EOS = True) then
                            exit for
                        end if
                        countbytes = GetBytes(bfp_wordmap, 2) - 1
                        redim preserve phrase_data_count(j)
                        phrase_data_count(j) = countbytes
                        redim xdata(2, countbytes)
                        for xbi = 0 to countbytes
                            xdata(0, xbi) = GetBytes(bfp_wordmap, 2)
                            xdata(1, xbi) = GetBytes(bfp_wordmap, 2)
                            xdata(2, xbi) = GetBytes(bfp_wordmap, 4)
                            redim preserve phrase_terms_data(j)
                            phrase_terms_data(j) = xdata
                        next
                    else
                        redim preserve phrase_data_count(j)
                        phrase_data_count(j) = 0
                    end if
                next
            ' check whether there are any wildcards used
        	elseif (UseWildCards(sw) = 1) then
        		
                patternStr = ""
                
                if (SearchAsSubstring = 0) then
                    patternStr = patternStr & "^"
                end if

                ' new keyword pattern to match for                
                patternStr = patternStr & RegExpSearchWords(sw)

                if (SearchAsSubstring = 0) then
                    patternStr = patternStr & "$"
                end if

                regExp.Pattern = patternStr                
            end if


            if (WordNotFound <> 1) then

                'Read in a line at a time from the keywords file
                for zoomit = 0 to dict_count

                    word = dict(0, zoomit)
                    ptr = dict(1, zoomit)
                    
		            if (ToLowerSearchWords = 1) then
                		word = Lcase(word)
            		end if                    

                    if (ExactPhrase = 1) then
                        bMatched = phrase_terms(0) = word
                    elseif (UseWildCards(sw) = 0) then
                        if (SearchAsSubstring = 0) then
                            bMatched = SearchWords(sw) = word
                        else
                            bMatched = InStr(word, SearchWords(sw))
                        end if
                    else
                        bMatched = regExp.Test(word)
                    end if

                    ' word found but indicated to be not indexed or skipped
                    if (bMatched AND Int(ptr) = -1) then
                        if (UseWildCards(sw) = 0 AND SearchAsSubstring = 0) then
                            SkippedExactPhrase = 1
                            SkipSearchWord(sw)
                            exit for
                        else
                            'continue
                            bMatched = False ' do nothing until next iteration
                        end if
                    end if

                    if (bMatched) then
                        Dim ContextSeeks, maxptr, maxptr_term, xi, tmpdata, FoundFirstWord, pos
                        Dim BufferLen, buffer_bytesread, xword_id, bytesread, dict_id, bytes

                        'keyword found in dictionary
                        if (ExactPhrase = 1) then
                            data_count = phrase_data_count(0)
                            redim data(2, data_count)
                            data = phrase_terms_data(0)
                            ContextSeeks = 0
                        else
                            bfp_wordmap.Position = ptr
                            if (bfp_wordmap.EOS = True) then
                                exit for
                            end if
                            'first 2 bytes is data count
                            data_count = GetBytes(bfp_wordmap, 2) - 1   ' index from 0
                            redim data(2, data_count)
                            for j = 0 to data_count
                                'redim preserve data(2, j)
                                data(0, j) = GetBytes(bfp_wordmap, 2)   'score
                                data(1, j) = GetBytes(bfp_wordmap, 2)   'pagenum
                                data(2, j) = GetBytes(bfp_wordmap, 4)   'ptr
                            next
                        end if

                        sw_results(sw) = sw_results(sw) + data_count

                        for j = 0 to data_count
                            score = Int(data(0, j))
                            ipage = data(1, j)  'pagenum
                            txtptr = data(2, j)
                            GotoNextPage = 0
                            FoundPhrase = 0
                            
                            if (score = 0) then
                            	GotoNextPage = 1
                        	end if

                            if (ExactPhrase = 1) then
                                maxptr = txtptr
                                maxptr_term = 0

                                ' check if all of the other words in the phrase appears on this page
                                for xi = 1 to num_phrase_terms-1
                                    ' see if this word appears at all on this page, if not, we stop scanning page
                                    ' do not check for skipped words (data count value of zero)
                                    if (phrase_data_count(xi) <> 0) then
                                        ' check wordmap for this search phrase to see if it appears on the current page
                                        tmpdata = phrase_terms_data(xi)
                                        for xbi = 0 to phrase_data_count(xi)
                                            if (tmpdata(1, xbi) = data(1, j)) then
                                                ' intersection, this term appears on both pages, goto next term
                                                ' remember biggest pointer
                                                if (tmpdata(2, xbi) > maxptr) then
                                                    maxptr = tmpdata(2, xbi)
                                                    maxptr_term = xi
                                                end if
                                                score = score + tmpdata(0, xbi)
                                                exit for
                                            end if
                                        next
                                        if (xbi > phrase_data_count(xi)) then ' if not found
                                            GotoNextPage = 1
                                            exit for
                                        end if
                                    end if
                                next

                                if (GotoNextPage <> 1) then

                                    ContextSeeks = ContextSeeks + 1
                                    if (ContextSeeks > MaxContextSeeks) then

                                        Response.Write("<small>" & STR_PHRASE_CONTAINS_COMMON_WORDS & " <b>""" & SearchWords(sw) & """</b></small><br /><br />")
                                        exit for
                                    end if

                                    ' ok so this page contains all the words in the phrase
                                    FoundPhrase = 0
                                    FoundFirstWord = 0

                                    ' we goto the first occurance of the first word in pagetext
                                    pos = maxptr - ((maxptr_term+3) * DictIDLen) ' assume 3 possible punct.
                                    ' do not seek further back than the occurance of the first word (avoid wrong page)
                                    if (pos < txtptr) then
                                        pos = txtptr
                                    end if
                                    bin_pagetext.Position = pos

                                    bytes_buffer = ""
                                    BufferLen = 120*DictIDLen ' we need a multiple of our DictIDLen (previous value: 256)
                                    buffer_bytesread = BufferLen

                                    ' now we look for the phrase within the context of this page
                                    Do
                                        for xi = 0 to num_phrase_terms-1
                                            do
                                                xword_id = 0
                                                bytesread = 0
                                                
                                                if (buffer_bytesread >= BufferLen) then
                                                    bytes_buffer = bin_pagetext.Read(BufferLen)
                                                    buffer_bytesread = 0
                                                end if
                                                dict_id = 0
                                                bytes = Midb(bytes_buffer, buffer_bytesread+1, DictIDLen)                                                                                                                                                            
                                                for k = 1 to DictIDLen                                                    	
                                                    dict_id = dict_id + Ascb(Midb(bytes, k, 1)) * (256^(k-1))
                                                next
                                                xword_id = xword_id + dict_id
                                                buffer_bytesread = buffer_bytesread + DictIDLen
                                                bytesread = bytesread + DictIDLen

                                                pos = pos + bytesread                                            
                                                if (xword_id = 0 OR xword_id > dict_count) then
                                                    exit for
                                                end if
                                                ' if punct. keep reading.                                            
                                            loop while (xword_id <= DictReservedLimit AND pos < bin_pagetext.Size)
                                            
                                            xdictword = dict(0, xword_id)
                                            if (MapAccents = 1) then
                                            	For xch = 0 to UBound(NormalChars)
										            xdictword = Replace(xdictword, AccentChars(xch), NormalChars(xch))
										        Next
										    end if

											' if the words are not the same, we break out
                                            if (Lcase(xdictword) <> phrase_terms(xi)) then
                                            	' also check against first word
                                            	if (xi <> 0 AND Lcase(xdictword) = phrase_terms(0)) then
                                            		xi = 0	' matched first word
                                            	else
                                            		exit for	
                                            	end if                                                
                                            end if

                                            if (xi = 0) then
                                                FoundFirstWord = FoundFirstWord + 1
                                                ' remember the position of the 'start' of this phrase
                                                txtptr = pos - bytesread
                                            end if
                                        next

                                        if (xi = num_phrase_terms) then
                                            ' exact phrase found
                                            FoundPhrase = 1
                                        end if
                                    Loop while xword_id <> 0 AND FoundPhrase = 0 AND FoundFirstWord <= score
                                end if

                                if (FoundPhrase <> 1) then
                                    GotoNextPage = 1
                                end if

                            end if

                            ' check whether we should skip to next page or not

                            if (GotoNextPage <> 1) then

                                'Check if page is already in output list
                                pageexists = 0

                                if ipage < 0 OR ipage > pagesCount then
                                    Response.Write("Error: Page number too big. Make sure ALL index files are updated.")
                                    exit for
                                end if

                                if (ExcludeTerm = 1) then
                                    ' we clear out the score entry so that it'll be excluded
                                    res_table(0, ipage) = Int(0)
                                elseif (Int(res_table(0, ipage)) = 0) then
                                    matches = matches + 1
                                    res_table(0, ipage) = Int(res_table(0, ipage)) + score
                                    if (res_table(0, ipage) <= 0) then
                                        Response.Write("Score should not be negative: " & score & "<br />")
                                    end if

                                    res_table(2, ipage) = txtptr
                                else
                                    if (Int(res_table(0, ipage)) > 10000) then
                                        ' take it easy if its too big (to prevent huge scores)
                                        res_table(0, ipage) = Int(res_table(0, ipage)) + 1
                                    else
                                        res_table(0, ipage) = Int(res_table(0, ipage)) + score
                                        res_table(0, ipage) = Int(res_table(0, ipage)) * 2
                                    end if

                                    'store the next two searchword matches
                                    if (Int(res_table(1, ipage)) > 0 AND Int(res_table(1, ipage)) < MaxContextKeywords) then
                                        if (Int(res_table(3, ipage)) = 0) then
                                            res_table(3, ipage) = txtptr
                                        elseif (Int(res_table(4, ipage)) = 0) then
                                            res_table(4, ipage) = txtptr
                                        end if
                                    end if
                                end if

                                ' store the 'total terms matched' value
                                res_table(1, ipage) = Int(res_table(1, ipage)) + 1

                                ' store the 'AND search terms matched' value
                                if (res_table(5, ipage) = sw OR res_table(5, ipage) = sw-SkippedWords-exclude_count) then
                                    res_table(5, ipage) = Int(res_table(5, ipage)) + 1
                                end if

                            end if
                        next

                        if (UseWildCards(sw) = 0 AND SearchAsSubstring = 0) then
                            exit for
                        end if
                    end if
                next
            end if
        end if

        if (sw <> numwords-1) then
            bfp_wordmap.Position = 1
        end if        
    next

    'Close the keywords file that was being used
    bfp_wordmap.Close

    if SkippedWords > 0 then
        Response.Write("<div class=""summary"">" & STR_SKIPPED_FOLLOWING_WORDS & " " & SkippedOutputStr & "<br />")
        if (SkippedExactPhrase = 1) then
            Response.Write(STR_SKIPPED_PHRASE & ".<br />")
        end if
        Response.Write("<br /></div>")
    end if


    Dim oline, fullmatches, full_numwords, SomeTermMatches
    Dim IsFiltered

    oline = 0
    fullmatches = 0

    dim output()
        
    full_numwords = numwords - SkippedWords - exclude_count
    for zoomit = 0 to pagesCount Step 1
        IsFiltered = False
        if (res_table(0, zoomit) > 0) then
            if (UseCats = 1 AND zoomcat(0) <> -1) then            	
            	if (SearchMultiCats = 1) then
            		Dim IsFoundCat
            		IsFoundCat = False            		
            		for cati = 0 to num_zoom_cats-1
            			if (Mid(catpages(zoomit), zoomcat(cati)+1, 1) = "1") then
	            			IsFoundCat = True
	            			exit for
	            		end if	            		
            		next                        	
            		if (IsFoundCat = False) then
            			IsFiltered = True
            		end if
            	else        		            	
            		if (Mid(catpages(zoomit), zoomcat(0)+1, 1) = "0") then            	
            			IsFiltered = True
            		end if
            	end if
            end if
            
            if (IsFiltered = False) then
                'if (res_table(1, zoomit) >= full_numwords) then
                if (res_table(5, zoomit) >= full_numwords) then
                    fullmatches = fullmatches + 1
                elseif (andq = 1) then
                    ' AND search, filter out non-matching results
                    IsFiltered = True
                end if
            end if

            if (IsFiltered = False) then
                ' copy if not filtered out
                redim preserve output(5, oline)
                output(0, oline) = zoomit
                output(1, oline) = res_table(0, zoomit)
                output(2, oline) = res_table(1, zoomit)
                output(3, oline) = res_table(2, zoomit)
                output(4, oline) = res_table(3, zoomit)
                output(5, oline) = res_table(4, zoomit)
                oline = oline + 1
            end if
        end if
    Next

    matches = oline

    ' Sort the results
    if (matches > 1) then
        if (zoomsort = 1 AND UseDateTime = 1) then
            call ShellSortByDate(output, datetime)
        else
            call ShellSort(output)
        end if
    end if

    ' queryForURL is the query prepared to be passed in a URL.
    queryForURL = Server.URLEncode(query)

    'Display search results
    Response.Write("<div class=""summary"">")
    if matches = 0 Then
        Response.Write(STR_SUMMARY_NO_RESULTS_FOUND)
    elseif numwords > 1 AND andq = 0 then
        SomeTermMatches = matches - fullmatches
        Response.Write(PrintNumResults(fullmatches) & " " & STR_SUMMARY_FOUND_CONTAINING_ALL_TERMS & " ")
        if (SomeTermMatches > 0) then
            Response.Write(PrintNumResults(SomeTermMatches) & " " & STR_SUMMARY_FOUND_CONTAINING_SOME_TERMS)
        end if
    elseif numwords > 1 AND andq = 1 then
        Response.Write(PrintNumResults(fullmatches) & " " & STR_SUMMARY_FOUND_CONTAINING_ALL_TERMS)
    else
        Response.Write(PrintNumResults(matches) & " " & STR_SUMMARY_FOUND)
    end if
    Response.Write("<br /></div>") & VbCrlf

    if (matches < 3) then
        if (andq = 1 AND numwords > 1) then
            Response.Write("<div class=""suggestion""><br />" & STR_POSSIBLY_GET_MORE_RESULTS & " <a href=""" & SelfURL & "?zoom_query=" & queryForURL & "&amp;zoom_page=" & zoompage & "&amp;zoom_per_page=" & per_page & query_zoom_cats & "&amp;zoom_and=0" & "&amp;zoom_sort=" & zoomsort & """>" & STR_ANY_OF_TERMS & "</a>.</div>")
        elseif (UseCats = 1 AND zoomcat(0) <> -1) then
            Response.Write("<div class=""suggestion""><br />" & STR_POSSIBLY_GET_MORE_RESULTS & " <a href=""" & SelfURL & "?zoom_query=" & queryForURL & "&amp;zoom_page=" & zoompage & "&amp;zoom_per_page=" & per_page & "&amp;zoom_cat=-1" & "&amp;zoom_and=" & andq & "&amp;zoom_sort=" & zoomsort & """>" & STR_ALL_CATS & "</a>.</div>")
        end if
    end if    

    if (Spelling = 1) then
        Dim spellfile, spell_count, sp_line, sp_linenum, sw_spcode, spcode
        Dim SuggestionsCount, SuggestionFound, SuggestStr, word1, word2, word3

        ' load in spellings file
        spellfile = split(ReadDatFile(zoomfso, "zoom_spelling.zdat"), chr(10))
        spell_count = UBound(spellfile)-1
        dim spell()
        redim spell(4, spell_count)
        for zoomit = 0 to spell_count
            sp_line = Split(spellfile(zoomit), " ", 4)
            sp_linenum = UBound(sp_line)
            if (sp_linenum > 0) then
                spell(0, zoomit) = sp_line(0)
                spell(1, zoomit) = sp_line(1)
                spell(2, zoomit) = 0
                spell(3, zoomit) = 0
                if (sp_linenum > 1) then
                    spell(2, zoomit) = sp_line(2)
                    if (sp_linenum > 2) then
                        spell(3, zoomit) = sp_line(3)
                    end if
                end if
            end if
        next
        ' re-value spell_count in case of errors in dict file
        spell_count = UBound(spell, 2)

        Dim dictid, nextsuggest

        SuggestionsCount = 0
        SuggestStr = ""
        word1 = ""
        word2 = ""
        word3 = ""

        for sw = 0 to numwords-1

            if (sw_results(sw) >= SpellingWhenLessThan) then
                ' this word has enough results
                if (sw > 0) then
                    SuggestStr = SuggestStr & " "
                end if
                SuggestStr = SuggestStr & SearchWords(sw)
            else
                ' this word returned less results than threshold, and requires spelling suggestions
                sw_spcode = GetSPCode(SearchWords(sw))

                if (Len(sw_spcode) > 0) then
                    SuggestionFound = 0
                    for zoomit = 0 to spell_count

                        spcode = spell(0, zoomit)

                        if (spcode = sw_spcode) then
                            j = 0
                            do while (SuggestionFound = 0 AND j < 3)
                            	if (spell(1+j, zoomit) = 0) then
                            		exit do
                            	end if
                                dictid = CLng(spell(1+j, zoomit))
                                word1 = dict(0, dictid)
                                if (ToLowerSearchWords = 1) then
					                word1 = Lcase(word1)
            					end if
                                if (word1 = SearchWords(sw)) then
                                    ' Check that it is not the same word
                                    SuggestionFound = 0
                                else
                                    SuggestionFound = 1
                                    SuggestionsCount = SuggestionsCount + 1
                                    if (numwords = 1) then  ' single word search
                                        nextsuggest = j+1
                                        if (j < 1) then
                                        	if (spell(1+nextsuggest, zoomit) <> 0) then
	                                            dictid = spell(1+nextsuggest, zoomit)
	                                            word2 = dict(0, dictid)
	                                            if (ToLowerSearchWords = 1) then
						                			word2 = Lcase(word2)
	            								end if
	                                            if (word2 = SearchWords(sw)) then
	                                                word2 = ""
	                                            end if
	                                        end if
                                        end if
                                        nextsuggest = nextsuggest+1
                                        if (j < 2) then
                                        	if (spell(1+nextsuggest, zoomit) <> 0) then
	                                            dictid = spell(1+nextsuggest, zoomit)
	                                            word3 = dict(0, dictid)
	                                            if (ToLowerSearchWords = 1) then
						                			word3 = Lcase(word3)
	            								end if
	                                            if (word3 = SearchWords(sw)) then
	                                                word3 = ""
	                                            end if
	                                        end if
                                        end if
                                    end if
                                end if
                                j = j + 1
                            loop
                        elseif (spcode > sw_spcode) then
                            exit for
                        end if
                        if (SuggestionFound = 1) then
                            exit for
                        end if
                    next

                    if (SuggestionFound = 1) then
                        if (sw > 0) then
                            SuggestStr = SuggestStr & " "
                        end if
                        SuggestStr = SuggestStr & word1  ' add string AFTER so we can preserve order of words
                    end if
                end if
            end if

        next

        if (SuggestionsCount > 0) then
            Response.Write("<div class=""suggestion""><br />" & STR_DIDYOUMEAN & " <a href=""" & SelfURL & "?zoom_query=" & Server.URLEncode(SuggestStr) & "&amp;zoom_per_page=" & per_page & query_zoom_cats & "&amp;zoom_and=0&amp;zoom_sort=" & zoomsort & """>" & SuggestStr & "</a>")
            if (Len(word2) > 0) then
                Response.Write(" " & STR_OR & " <a href=""" & SelfURL & "?zoom_query=" & Server.URLEncode(word2) & "&amp;zoom_per_page=" & per_page & query_zoom_cats & "&amp;zoom_and=" & andq & "&amp;zoom_sort=" & zoomsort & """>" & word2 & "</a>")
            end if
            if (Len(word3) > 0) then
                Response.Write(" " & STR_OR & " <a href=""" & SelfURL & "?zoom_query=" & Server.URLEncode(word3) & "&amp;zoom_per_page=" & per_page & query_zoom_cats & "&amp;zoom_and=" & andq & "&amp;zoom_sort=" & zoomsort & """>" & word3 & "</a>")
            end if
            Response.Write("?</div>")
        end if
    end if

    ' Number of pages of results
    Dim num_pages
    ' Round up numbers with CLng note that it rounds to nearest whole number, ie: 0.5 -> 0, 1.5 -> 2
    if (matches MOD per_page = 0) then
        'whole number
        num_pages = CLng(matches / per_page)
    else
        'unwholey number
        num_pages = CLng((matches / per_page) + 0.5)
    end if    
    if (num_pages > 1) then
        Response.Write("<div class=""result_pagescount""><br />" & num_pages & " " & STR_PAGES_OF_RESULTS & "</div>") & VbCrlf
    end if
    
    Dim pgdata, url, title, description
    
    ' Show recommended links if any
    Dim num_recs_found
    num_recs_found = 0
    if (Recommended = 1) then    	
    	for rl = 0 to rec_count-1
    		rec_word = Trim(rec(0, rl))
            if (ToLowerSearchWords = 1) then
                rec_word = Lcase(rec_word)
            end if    		
    		rec_idx = rec(1, rl)
    		sw = 0
    		IsFound = 0
    		do while (sw <= numwords AND IsFound = 0)    			    		
    			if (sw = numwords) then
    				bMatched = queryForSearch = rec_word
    			else
	        		if (UseWildCards(sw) = 1) then        		
		                patternStr = ""
		                
		                if (SearchAsSubstring = 0) then
		                    patternStr = patternStr & "^"
		                end if
		
		                ' new keyword pattern to match for                
		                patternStr = patternStr & RegExpSearchWords(sw)
		
		                if (SearchAsSubstring = 0) then
		                    patternStr = patternStr & "$"
		                end if
		
		                regExp.Pattern = patternStr
		                bMatched = regExp.Test(rec_word)
		            elseif (SearchAsSubstring = 0) then
                        bMatched = SearchWords(sw) = rec_word
                    else
                        bMatched = InStr(rec_word, SearchWords(sw))                    
		            end if	    				
    			end if
    			if (bMatched) then    				
    				if (num_recs_found = 0) then
    					Response.Write("<div class=""recommended"">")
    					Response.Write("<div class=""recommended_heading"">" & STR_RECOMMENDED & "</div>")    					
    				end if
    				pgdata = GetPageData(rec_idx)
    				url = pgdata(PAGEDATA_URL)
    				title = pgdata(PAGEDATA_TITLE)
    				description = pgdata(PAGEDATA_DESC)    				
					urlLink = url
					if (GotoHighlight = 1) then
			            if (SearchAsSubstring = 1) then
			                urlLink = AddParamToURL(urlLink, "zoom_highlightsub=" & queryForURL)
			            else
			                urlLink = AddParamToURL(urlLink, "zoom_highlight=" & queryForURL)
			            end if
			        end if
	                if (PdfHighlight = 1) then
    			    	if (InStr(urlLink, ".pdf") <> False) then
			        		urlLink = urlLink & "#search=&quot;"&Replace(query, """", "")&"&quot;"
			        	end if        	
        			end if       
			        Response.Write("<div class=""recommend_block"">")			        
			       	Response.Write("<div class=""recommend_title"">")
    				Response.Write("<a href=""" & urlLink & """"  & zoomtarget & ">")
    				if (Len(title) > 1) then
    					PrintHighlightDescription(title)
    				else
    					PrintHighlightDescription(url)
    				end if
    				Response.Write("</a></div>")
    				Response.Write("<div class=""recommend_description"">")
    				PrintHighlightDescription(description)
    				Response.Write("</div>")
    				Response.Write("<div class=""recommend_infoline"">" & url & "</div>")
    				Response.Write("</div>")
    				num_recs_found = num_recs_found + 1   
    				IsFound = 1   			  				
    			end if
    			sw = sw + 1
    		loop
    		if (num_recs_found >= RecommendedMax) then
    			exit for
    		end if    		
    	next
    	if (num_recs_found > 0) then
    		Response.Write("</div>")
    	end if
	end if    

    ' Show sorting options
    if (matches > 1 AND UseDateTime = 1) then
        Response.Write("<div class=""sorting"">")
        if (zoomsort = 1) then
            Response.Write("<a href=""" & SelfURL & "?zoom_query=" & queryForURL & "&amp;zoom_page=" & zoompage & "&amp;zoom_per_page=" & per_page & query_zoom_cats & "&amp;zoom_and=" & andq & "&amp;zoom_sort=0"">" & STR_SORTBY_RELEVANCE & "</a> / <b>" & STR_SORTEDBY_DATE & "</b>")
        else
            Response.Write("<b>" & STR_SORTEDBY_RELEVANCE & "</b> / <a href=""" & SelfURL & "?zoom_query=" & queryForURL & "&amp;zoom_page=" & zoompage & "&amp;zoom_per_page=" & per_page & query_zoom_cats & "&amp;zoom_and=" & andq & "&amp;zoom_sort=1"">" & STR_SORTBY_DATE & "</a>")
        end if
        Response.Write("</div>")
    end if

    Dim arrayline, result_limit, urlLink

    ' Determine current line of result from the $output array
    if (zoompage = 1) then
        arrayline = 0
    else
        arrayline = (zoompage - 1) * per_page
    end if

    ' The last result to show on this page
    result_limit = arrayline + per_page

    ' Display the results
    do while (arrayline < matches AND arrayline < result_limit)
        ipage = output(0, arrayline)
        score = output(1, arrayline)

		pgdata = GetPageData(ipage)
    	url = pgdata(PAGEDATA_URL)
    	title = pgdata(PAGEDATA_TITLE)
    	description = pgdata(PAGEDATA_DESC)     	    	
    	   				
		urlLink = url        		
		if (GotoHighlight = 1) then
            if (SearchAsSubstring = 1) then
                urlLink = AddParamToURL(urlLink, "zoom_highlightsub=" & queryForURL)
            else
                urlLink = AddParamToURL(urlLink, "zoom_highlight=" & queryForURL)
            end if
        end if
        if (PdfHighlight = 1) then
        	if (InStr(urlLink, ".pdf") <> False) then
        		urlLink = urlLink & "#search=&quot;"&Replace(query, """", "")&"&quot;"
        	end if        	
        end if       
        
        if (arrayline Mod 2 = 0) then
        	Response.Write("<div class=""result_block"">")
    	else
    		Response.Write("<div class=""result_altblock"">")
		end if        
        
        if (UseZoomImage = 1) then
        	image = pgdata(PAGEDATA_IMG)        	
        	if (Len(image) > 0) then
        		Response.Write("<div class=""result_image"">")
        		Response.Write("<a href=""" & urlLink & """"  & zoomtarget & "><img src="""&image&""" alt="""" class=""result_image""></a>")
        		Response.Write("</div>")
        	end if
    	end if

        Response.Write("<div class=""result_title"">")
        if (DisplayNumber = 1) then
            Response.Write("<b>" & (arrayline+1) & ".</b>&nbsp;")
        end if
				
        if (DisplayTitle = 1) then
            Response.Write("<a href=""" & urlLink & """"  & zoomtarget & ">")
            PrintHighlightDescription(title)
            Response.Write("</a>")
        else
            Response.Write("<a href=""" & urlLink & """"  & zoomtarget & ">" & url & "</a>")
        end if

        if (UseCats = 1) then
        	Response.Write(" <span class=""category"">")
        	for catindex = 0 to NumCats-1
        		if (Mid(catpages(ipage), catindex+1, 1) = "1") then
        			Response.Write(" [" & catnames(catindex) & "]")
        		end if
        	next         	        	
            Response.Write("</span>")
        end if
        Response.Write("</div>") & VbCrlf

        if (DisplayMetaDesc = 1) then
            ' print meta description
            if (Len(description) > 2) then
                Response.Write("<div class=""description"">")
                PrintHighlightDescription(description)
                Response.Write("</div>") & VbCrlf
            end if
        end if

        if (DisplayContext = 1) then
            Dim context_keywords, context_word_count, goback, gobackbytes, context_str
            Dim last_startpos, last_endpos, FoundContext, origpos, startpos, word_id, prev_word_id
            Dim noSpaceForNextChar, noGoBack

            ' extract contextual page description
            context_keywords = output(2, arrayline)
            if (context_keywords > MaxContextKeywords) then
                context_keywords = MaxContextKeywords
            end if

            context_word_count = Ceil(ContextSize / context_keywords)

            goback = Int(context_word_count / 2)
            gobackbytes = goback * DictIDLen

            last_startpos = 0
            last_endpos = 0
            FoundContext = 0

            Response.Write("<div class=""context"">") & VbCrLf
            for j = 0 to (context_keywords - 1) Step 1

                origpos = output(3+j, arrayline)
                startpos = origpos

                if (gobackbytes < startpos) then
                    startpos = startpos - gobackbytes
                    noGoBack = 0
                else
                    noGoBack = 1
                end if

                ' do not overlap with previous extract
                if (startpos > last_startpos AND startpos < last_endpos) then
                    startpos = last_endpos
                end if

                bin_pagetext.Position = startpos
                if (bin_pagetext.EOS = True) then
                    exit for
                end if

                'remember last start position
                last_startpos = startpos

                word_id = GetNextDictWord(bin_pagetext)
                prev_word_id = 0

                context_str = ""
                noSpaceForNextChar = False

                for zoomit = 0 to context_word_count

                    if (noSpaceForNextChar = False) then                        
                        'No space for reserved words (punctuation, etc)
                        if (word_id > DictReservedNoSpaces) then
                        	if (prev_word_id <= DictReservedPrefixes OR prev_word_id > DictReservedNoSpaces) then                        		
                            	context_str = context_str + " "
                            end if
                        elseif (word_id > DictReservedSuffixes AND word_id <= DictReservedPrefixes) then
                            context_str = context_str + " "
                            noSpaceForNextChar = True
                        elseif (word_id > DictReservedPrefixes) then
                            noSpaceForNextChar = True
                        end if
                    else
                        noSpaceForNextChar = False
                    end if

                    if (word_id = 0 OR word_id = 1 OR word_id > dict_count) then
                        'if (zoomit > goback OR noGoBack = 1) then
                        if (noGoBack = 1 OR bin_pagetext.Position > origpos) then
                            exit for
                        else
                            context_str = ""
                            zoomit = 0
                        end if
                    else
                    	if (word_id <= DictReservedLimit) then
                    		context_str = context_str + dict(0, word_id)
                    	else
                    		context_str = context_str + htmlspecialchars(dict(0, word_id))
                    	end if
                    end if

					prev_word_id = word_id
                    word_id = GetNextDictWord(bin_pagetext)
                next

                ' rememeber the last end position
                last_endpos = bin_pagetext.Position

                if (Trim(title) = Trim(context_str)) then
                    context_str = ""
                end if

                if (context_str <> "") then
                    Response.Write(" <b>...</b> ")
                    FoundContext = 1
                    PrintHighlightDescription(context_str)
                end if
            next
            if (FoundContext = 1) then
                Response.Write(" <b>...</b>")
            end if
            Response.Write("</div>") & VbCrLf
        end if

        Dim info_str
        info_str = ""
        if (DisplayTerms = 1) then
            info_str = info_str & STR_RESULT_TERMS_MATCHED & " " & output(2, arrayline)
        end if

        if (DisplayScore = 1) then
            if (len(info_str) > 0) then
                info_str = info_str & "&nbsp; - &nbsp;"
            end if
            info_str = info_str & STR_RESULT_SCORE & " " & score
        end if

        if (DisplayDate = 1) then
        	if (datetime(ipage) > 0) then
	            if (len(info_str) > 0) then
	                info_str = info_str & "&nbsp; - &nbsp;"
	            end if            
	            tmpdate = unUDate(datetime(ipage))
	            info_str = info_str & DatePart("d", tmpdate) & " " & MonthName(DatePart("m", tmpdate), true) & " " & DatePart("yyyy", tmpdate)
	        end if
        end if
        
        if (DisplayFilesize = 1) then
            if (len(info_str) > 0) then
                info_str = info_str & "&nbsp; - &nbsp;"
            end if
            info_str = info_str & filesize(ipage) & "k"
        end if
        
        if (DisplayURL = 1) then
            if (len(info_str) > 0) then
                info_str = info_str & "&nbsp; - &nbsp;"
            end if
            info_str = info_str & STR_RESULT_URL & " " & url
        end if

        Response.Write("<div class=""infoline"">")
        Response.Write(info_str)
        Response.Write("</div>") & VbCrlf
        Response.Write("</div>") & VbCrlf
        arrayline = arrayline + 1
    loop

    if (DisplayContext = 1 OR AllowExactPhrase = 1) then
        bin_pagetext.Close
    end if
    
    fp_pagedata.Close

    'Show links to other result pages
    if (num_pages > 1) then
        Dim start_range, end_range
        ' 10 results to the left of the current page
        start_range = zoompage - 10
        if (start_range < 1) then
            start_range = 1
        end if

        ' 10 to the right
        end_range = zoompage + 10
        if (end_range > num_pages) then
            end_range = num_pages
        end if

        Response.Write("<div class=""result_pages"">" & STR_RESULT_PAGES & " ")
        if (zoompage > 1) then
            Response.Write("<a href=""" & selfURL & "?zoom_query=" & queryForURL & "&amp;zoom_page=" & (zoompage-1) & "&amp;zoom_per_page=" & per_page & query_zoom_cats & "&amp;zoom_and=" & andq & "&amp;zoom_sort=" & zoomsort & """>&lt;&lt; " & STR_RESULT_PAGES_PREVIOUS & "</a> ")
        end if
        'for zoomit = 1 to num_pages
        for zoomit = start_range to end_range
            if (Int(zoomit) = Int(zoompage)) then
                Response.Write(zoompage & " ")
            else
                Response.Write("<a href=""" & selfURL & "?zoom_query=" & queryForURL & "&amp;zoom_page=" & zoomit & "&amp;zoom_per_page=" & per_page & query_zoom_cats & "&amp;zoom_and=" & andq & "&amp;zoom_sort=" & zoomsort & """>" & zoomit & "</a> ")
            end if
        next
        if (Int(zoompage) <> Int(num_pages)) then
            Response.Write("<a href=""" & selfURL & "?zoom_query=" & queryForURL & "&amp;zoom_page=" & (zoompage+1) & "&amp;zoom_per_page=" & per_page & query_zoom_cats & "&amp;zoom_and=" & andq & "&amp;zoom_sort=" & zoomsort & """>" & STR_RESULT_PAGES_NEXT & " &gt;&gt;</a> ")
        end if
        Response.Write("</div>")
    end if

    Response.Write("</div>") & VbCrLf   ' end results style tag

    ' Time the searching
    if (Timing = 1 OR Logging = 1) then
        ElapsedTime = Timer - StartTime
        ElapsedTime = Round(ElapsedTime, 3)
        if (Timing = 1) then
            Response.Write("<div class=""searchtime""><br /><br />" &  STR_SEARCH_TOOK & " " & ElapsedTime & " " & STR_SECONDS & "</div>")
        end if
    end if

    'Log the search words, if required
    if (Logging = 1) then
        LogQuery = Replace(query, """", """""")
        DateString = Year(Now) & "-" & Right("0" & Month(Now), 2) & "-" & Right("0" & Day(Now), 2)  & ", " & Right("0" & Hour(Now), 2) & ":" & Right("0" & Minute(Now), 2) & ":" & Right("0" & Second(Now), 2)
        LogString = DateString & ", " & Request.ServerVariables("REMOTE_ADDR") & ", """ & LogQuery & """, Matches = " & matches

        if (andq = 1) then
            LogString = LogString & ", AND"
        else
            LogString = LogString & ", OR"
        end if

        if (NewSearch = 1) then
            zoompage = 0
        end if

        LogString = LogString & ", PerPage = " & per_page & ", PageNum = " & zoompage

        if (UseCats = 0) then
            LogString = LogString & ", No cats"
        else
            if (zoomcat(0) = -1) then
                LogString = LogString & ", ""Cat = All"""
            else
            	LogString = LogString & ", ""Cat = "
            	for cati = 0 to num_zoom_cats-1
            		if (cati > 0) then
            			LogString = LogString & ", "
            		end if
                	logCatStr = catnames(zoomcat(cati))
                	logCatStr = Replace(logCatStr, """", """""")    ' replace " with ""
                	LogString = LogString & logCatStr
                next
                LogString = LogString & """"
            end if
        end if

        ' avoid problems with languages with "," as decimal pt breaking log file format.
        ElapsedTime = Replace(ElapsedTime, ",", ".")
        LogString = LogString & ", Time = " & ElapsedTime
        
        LogString = LogString & ", Rec = " & num_recs_found

        ' end of record
        LogString = LogString & VbCrLf

        on error resume next
        set logfile = zoomfso.OpenTextFile(MapPath(LogFileName), 8, True, 0)
        if (Err.Number <> 0) then
            Response.Write("Unable to write to log file (" & MapPath(LogFileName) & "). Check that you have specified the correct log filename in your Indexer settings and that you have the required file permissions set.<br />")
        else
            logfile.Write(LogString)
            logfile.Close
        end if
        on error goto 0
    end if  ' Logging

end if  ' NoSearch

'Print out the end of the template
call PrintEndOfTemplate
%>
