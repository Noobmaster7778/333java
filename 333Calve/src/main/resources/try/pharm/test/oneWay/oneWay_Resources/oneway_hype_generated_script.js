//	HYPE.documents["oneWay"]

(function HYPE_DocumentLoader() {
	var resourcesFolderName = "oneWay_Resources";
	var documentName = "oneWay";
	var documentLoaderFilename = "oneway_hype_generated_script.js";

	// find the URL for this script's absolute path and set as the resourceFolderName
	try {
		var scripts = document.getElementsByTagName('script');
		for(var i = 0; i < scripts.length; i++) {
			var scriptSrc = scripts[i].src;
			if(scriptSrc != null && scriptSrc.indexOf(documentLoaderFilename) != -1) {
				resourcesFolderName = scriptSrc.substr(0, scriptSrc.lastIndexOf("/"));
				break;
			}
		}
	} catch(err) {	}

	// Legacy support
	if (typeof window.HYPE_DocumentsToLoad == "undefined") {
		window.HYPE_DocumentsToLoad = new Array();
	}
 
	// load HYPE.js if it hasn't been loaded yet
	if(typeof HYPE_100 == "undefined") {
		if(typeof window.HYPE_100_DocumentsToLoad == "undefined") {
			window.HYPE_100_DocumentsToLoad = new Array();
			window.HYPE_100_DocumentsToLoad.push(HYPE_DocumentLoader);

			var headElement = document.getElementsByTagName('head')[0];
			var scriptElement = document.createElement('script');
			scriptElement.type= 'text/javascript';
			scriptElement.src = resourcesFolderName + '/' + 'HYPE.js?hype_version=100';
			headElement.appendChild(scriptElement);
		} else {
			window.HYPE_100_DocumentsToLoad.push(HYPE_DocumentLoader);
		}
		return;
	}
	
	var hypeDoc = new HYPE_100();
	
	var attributeTransformerMapping = {b:"i",c:"i",bC:"i",aS:"i",d:"i",M:"i",e:"f",N:"i",f:"d",aT:"i",O:"i",g:"c",aU:"i",P:"i",Q:"i",aV:"i",R:"c",aW:"f",aI:"i",S:"i",T:"i",l:"d",aX:"i",aJ:"i",m:"c",n:"c",aK:"i",X:"i",aZ:"i",A:"c",Y:"i",aL:"i",B:"c",C:"c",D:"c",t:"i",E:"i",G:"c",bA:"c",a:"i",bB:"i"};

var scenes = [{onSceneLoadAction:{type:0},timelines:{"10_hover":{framesPerSecond:30,animations:[{f:"2",t:0,d:1,i:"m",e:"#D7D02A",r:1,s:"#D8D8D8",o:"10"}],identifier:"10_hover",name:"10_hover",duration:1},"8":{framesPerSecond:30,animations:[{f:"2",t:0,d:5,i:"e",e:"1.000000",r:1,s:"0.000000",o:"9"},{f:"2",t:0,d:4.9333334,i:"e",e:"0.000000",r:1,s:"2.000000",o:"10"},{f:"2",t:0,d:4.9666667,i:"f",e:"180deg",r:1,s:"0deg",o:"12"},{f:"2",t:0,d:3.9333334,i:"e",e:"0.000000",r:1,s:"2.000000",o:"13"},{f:"2",t:0,d:3.9666667,i:"e",e:"1.000000",r:1,s:"0.000000",o:"14"}],identifier:"8",name:"showTrans",duration:5},"9_hover":{framesPerSecond:30,animations:[{f:"2",t:0,d:1,i:"m",e:"#D3D929",r:1,s:"#D8D8D8",o:"9"}],identifier:"9_hover",name:"9_hover",duration:1},"9_pressed":{framesPerSecond:30,animations:[{f:"2",t:0,d:1,i:"m",e:"#D009D6",r:1,s:"#D8D8D8",o:"9"}],identifier:"9_pressed",name:"9_pressed",duration:1},"3_pressed":{framesPerSecond:30,animations:[],identifier:"3_pressed",name:"3_pressed",duration:0},kTimelineDefaultIdentifier:{framesPerSecond:30,animations:[],identifier:"kTimelineDefaultIdentifier",name:"Main Timeline",duration:0},"2_pressed":{framesPerSecond:30,animations:[],identifier:"2_pressed",name:"2_pressed",duration:0},"10_pressed":{framesPerSecond:30,animations:[{f:"2",t:0,d:1,i:"m",e:"#CE3AD6",r:1,s:"#D8D8D8",o:"10"}],identifier:"10_pressed",name:"10_pressed",duration:1}},sceneIndex:0,perspective:"600px",oid:"1",initialValues:{"10":{b:314,z:"8",K:"Solid",c:90,L:"Solid",aS:6,d:15,M:1,bD:"none",e:"2.000000",N:1,aT:6,O:1,g:"#F0F0F0",aU:6,P:1,Q:3,aV:6,R:"#808080",j:"absolute",S:0,aI:6,k:"div",T:0,l:"0deg",aJ:6,m:"#D8D8D8",n:"#FFFFFF",aK:6,aL:6,A:"#A0A0A0",B:"#A0A0A0",aM:"10_hover",Z:"break-word",C:"#A0A0A0",r:"inline",aN:"10_pressed",D:"#A0A0A0",t:13,aA:{type:3,timelineIdentifier:"8"},F:"center",G:"#000000",aP:"pointer",w:"show trans",x:"visible",I:"Solid",a:462,y:"preserve",J:"Solid"},"13":{G:"#000000",bB:3,aU:8,aV:8,r:"inline",bC:3,e:"2.000000",t:24,Z:"break-word",v:"bold",w:"cis",j:"absolute",x:"visible",aZ:3,k:"div",y:"preserve",z:"11",aS:8,aT:8,bA:"#939393",a:54,b:284},"12":{o:"content-box",h:"moleculeR.svg",x:"visible",a:176,q:"100% 100%",b:43,j:"absolute",r:"inline",z:"10",k:"div",c:302,d:300,aY:"2",f:"0deg"},"9":{b:49,z:"7",K:"Solid",c:90,L:"Solid",aS:6,d:15,M:1,bD:"none",e:"0.000000",N:1,aT:6,O:1,g:"#F0F0F0",aU:6,P:1,Q:3,aV:6,R:"#808080",j:"absolute",S:0,aI:6,k:"div",T:0,l:"0deg",aJ:6,m:"#D8D8D8",n:"#FFFFFF",aK:6,aL:6,A:"#A0A0A0",B:"#A0A0A0",aM:"9_hover",Z:"break-word",C:"#A0A0A0",r:"inline",aN:"9_pressed",D:"#A0A0A0",t:13,aA:{type:1,transition:1,sceneOid:"25"},F:"center",G:"#000000",aP:"pointer",w:"show cis",x:"visible",I:"Solid",a:462,y:"preserve",J:"Solid"},"11":{o:"content-box",h:"molecule.svg",x:"visible",a:54,q:"100% 100%",b:43,j:"absolute",r:"inline",c:300,k:"div",z:"9",d:300},"14":{G:"#000000",bB:3,aU:8,aV:8,r:"inline",bC:3,e:"0.000000",t:24,Z:"break-word",v:"bold",w:"trans",j:"absolute",x:"visible",aZ:2,k:"div",y:"preserve",z:"12",aS:8,aT:8,bA:"#949494",a:54,b:43}},backgroundColor:"#FFFFFF",name:"Untitled Scene"}];


	
	var javascripts = [];


	
	var Custom = {};
	var javascriptMapping = {};
	for(var i = 0; i < javascripts.length; i++) {
		try {
			javascriptMapping[javascripts[i].identifier] = javascripts[i].name;
			eval("Custom." + javascripts[i].name + " = " + javascripts[i].source);
		} catch (e) {
			hypeDoc.log(e);
			Custom[javascripts[i].name] = (function () {});
		}
	}
	
	hypeDoc.setAttributeTransformerMapping(attributeTransformerMapping);
	hypeDoc.setScenes(scenes);
	hypeDoc.setJavascriptMapping(javascriptMapping);
	hypeDoc.Custom = Custom;
	hypeDoc.setCurrentSceneIndex(0);
	hypeDoc.setMainContentContainerID("oneway_hype_container");
	hypeDoc.setResourcesFolderName(resourcesFolderName);
	hypeDoc.setShowHypeBuiltWatermark(1);
	hypeDoc.setShowLoadingPage(false);
	hypeDoc.setDrawSceneBackgrounds(true);
	hypeDoc.setDocumentName(documentName);

	HYPE.documents[documentName] = hypeDoc.API;

	hypeDoc.documentLoad(this.body);
}());

