/***********************************************************************************
*	(c) Ger Versluis 2000 version 5.411 24 December 2001 (updated Jan 31st, 2003 by Dynamic Drive for Opera7)
*	For info write to menus@burmees.nl		          *
*	You may remove all comments for faster loading	          *		
***********************************************************************************/

	var NoOffFirstLineMenus=6;			// Number of first level items
	var LowBgColor='white';			    // Background color when mouse is not over
	var LowSubBgColor='white';			// Background color when mouse is not over on subs
	var HighBgColor='#FFFF00';			// Background color when mouse is over
	var HighSubBgColor='#FFFF00';		// Background color when mouse is over on subs
	var FontLowColor='blue';			// Font color when mouse is not over
	var FontSubLowColor='blue';			// Font color subs when mouse is not over
	var FontHighColor='red';			// Font color when mouse is over
	var FontSubHighColor='red';			// Font color subs when mouse is over
	var BorderColor='#9999FF';			// Border color
	var BorderSubColor='#9999FF';		// Border color for subs
	var BorderWidth=1;				    // Border width
	var BorderBtwnElmnts=1;			    // Border between elements 1 or 0
	var FontFamily="arial,helvetica, sans"	// Font family menu items
	var FontSize=10;				    // Font size menu items
	var FontBold=0;				        // Bold menu items 1 or 0
	var FontItalic=0;				    // Italic menu items 1 or 0
	var MenuTextCentered='left';		// Item text position 'left', 'center' or 'right'
	var MenuCentered='left';			// Menu horizontal position 'left', 'center' or 'right'
	var MenuVerticalCentered='top';		// Menu vertical position 'top', 'middle','bottom' or static
	var ChildOverlap=.2;				// horizontal overlap child/ parent
	var ChildVerticalOverlap=.2;		// vertical overlap child/ parent
	var StartTop=80;				    // Menu offset x coordinate
	var StartLeft=10;				    // Menu offset y coordinate
	var VerCorrect=0;				    // Multiple frames y correction
	var HorCorrect=0;				    // Multiple frames x correction
	var LeftPaddng=5;			    	// Left padding
	var TopPaddng=0;				    // Top padding
	var FirstLineHorizontal=0;			// SET TO 1 FOR HORIZONTAL MENU, 0 FOR VERTICAL
	var MenuFramesVertical=1;			// Frames in cols or rows 1 or 0
	var DissapearDelay=250;			    // delay before menu folds in ms
	var TakeOverBgColor=1;			    // Menu frame takes over background color subitem frame
	var FirstLineFrame='navig';			// Frame where first level appears
	var SecLineFrame='space';			// Frame where sub levels appear
	var DocTargetFrame='space';			// Frame where target documents appear
	var TargetLoc='';				    // span id for relative positioning
	var HideTop=0;				        // Hide first level when loading new document 1 or 0
	var MenuWrap=1;				        // enables/ disables menu wrap 1 or 0
	var RightToLeft=0;				    // enables/ disables right to left unfold 1 or 0
	var UnfoldsOnClick=0;			    // Level 1 unfolds onclick/ onmouseover
	var WebMasterCheck=0;			    // menu tree checking on or off 1 or 0
	var ShowArrow=1;				    // Uses arrow gifs when 1
	var KeepHilite=1;				    // Keep selected path highligthed
	var Arrws=['tri.gif',4,8,'tridown.gif',8,4,'trileft.gif',4,8];	// Arrow source, width and height

function BeforeStart(){return}
function AfterBuild(){return}
function BeforeFirstOpen(){return}
function AfterCloseAll(){return}


// Menu tree
//	MenuX=new Array(Text to show, Link, background image (optional), number of sub elements, height, width);
//	For rollover images set "Text to show" to:  "rollover:Image1.jpg:Image2.jpg"



Menu1=new Array("Home","indexAnaes.html","",0,22,100);

Menu2=new Array("Machine","","",2,"",110);
	Menu2_1=new Array("routine check","machChk.html","",0,20,160);
	Menu2_2=new Array("circuits","circle.html","",0,20,"");

Menu3=new Array("Equipment","","",2,"",100);
	Menu3_1=new Array("drugs","drugs.html","",0,20,160);
	Menu3_2=new Array("bits & pieces","eqip.html","",0,20,"");

Menu4=new Array("Animals","","",6,"",100);
	Menu4_1=new Array("check","preAnCk.html","",0,20,160);
	Menu4_2=new Array("premed","premed.html","",0,20,"");
	Menu4_3=new Array("dog induction","dogIV.html","",0,20,"");
	Menu4_4=new Array("dog intubation","dogIntub.html","",0,20,"");
	Menu4_5=new Array("sheep induction","sheepIV.html","",0,20,"");
	Menu4_6=new Array("sheep intubation","sheepIntub.html","",0,20,"");
				
Menu5=new Array("Maintenance","MandM.html","",0,"",100);	

Menu6=new Array("Recovery","recov.html","",0,"",100);

