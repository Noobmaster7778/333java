//	HYPE.documents["cardiac-ap"]

(function HYPE_DocumentLoader() {
	var resourcesFolderName = "cardiac-ap_Resources";
	var documentName = "cardiac-ap";
	var documentLoaderFilename = "cardiacap_hype_generated_script.js";

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

var scenes = [{timelines:{kTimelineDefaultIdentifier:{framesPerSecond:30,animations:[{f:"1",t:0,d:3.0333333,i:"a",e:193,r:1,s:61,o:"9"},{f:"1",t:0,d:3.0333333,i:"b",e:245,r:1,s:280,o:"9"},{f:"1",t:0,d:3,i:"e",e:"0.000000",r:1,s:"1.000000",o:"14"},{f:"1",t:3,d:0.4666667,i:"e",e:"1.000000",r:1,s:"0.000000",o:"15"},{f:"1",t:3.0333333,d:0.9666667,i:"a",e:195,s:193,o:"9"},{f:"1",t:3.0333333,d:0.9666667,i:"b",e:23,s:245,o:"9"},{f:"1",t:3.4666667,d:0.5666666,i:"e",e:"0.000000",s:"1.000000",o:"15"},{f:"1",t:4,d:1.0333333,i:"e",e:"1.000000",r:1,s:"0.000000",o:"16"},{f:"1",t:4,d:0.9666667,i:"b",e:54,s:23,o:"9"},{f:"1",t:4,d:0.9666667,i:"a",e:219,s:195,o:"9"},{f:"1",t:4.9666667,d:1.0333333,i:"a",e:249,s:219,o:"9"},{f:"1",t:4.9666667,d:1.0333333,i:"b",e:55,s:54,o:"9"},{f:"1",t:5.0333333,d:0.9666667,i:"e",e:"0.000000",s:"1.000000",o:"16"},{f:"1",t:5.9666667,d:1.5333333,i:"e",e:"1.000000",r:1,s:"0.000000",o:"17"},{f:"1",t:6,d:1.0333333,i:"b",e:81,s:55,o:"9"},{f:"1",t:6,d:1.0333333,i:"a",e:330,s:249,o:"9"},{f:"1",t:7.0333333,d:2.0000005,i:"a",e:386,s:330,o:"9"},{f:"1",t:7.0333333,d:2.0000005,i:"b",e:114,s:81,o:"9"},{f:"1",t:7.5,d:1.4666662,i:"e",e:"0.000000",s:"1.000000",o:"17"},{f:"1",t:8.9666662,d:1.4333334,i:"e",e:"1.000000",r:1,s:"0.000000",o:"19"},{f:"1",t:9.0333338,d:2,i:"a",e:414,s:386,o:"9"},{f:"1",t:9.0333338,d:2,i:"b",e:261,s:114,o:"9"},{f:"1",t:10.4,d:1.2333336,i:"e",e:"0.000000",s:"1.000000",o:"19"},{f:"1",t:11.033334,d:1,i:"a",e:439,s:414,o:"9"},{f:"1",t:11.033334,d:1,i:"b",e:283,s:261,o:"9"},{f:"1",t:11.633333,d:1.833333,i:"e",e:"1.000000",r:1,s:"0.000000",o:"21"},{f:"1",t:12.033334,d:2.9666662,i:"b",e:247,s:283,o:"9"},{f:"1",t:12.033334,d:2.9666662,i:"a",e:576,s:439,o:"9"},{f:"1",t:13.466666,d:1.5333338,i:"e",e:"0.000000",s:"1.000000",o:"21"}],identifier:"kTimelineDefaultIdentifier",name:"Main Timeline",duration:15}},sceneIndex:0,perspective:"600px",oid:"1",initialValues:{"21":{aV:8,w:"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">\n<html>\n<head>\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n<meta http-equiv=\"Content-Style-Type\" content=\"text/css\">\n<title></title>\n<meta name=\"Generator\" content=\"Cocoa HTML Writer\">\n<meta name=\"CocoaVersion\" content=\"1138.32\">\n<style type=\"text/css\">\np.p1 {margin: 0.0px 0.0px 0.0px 0.0px; font: 16.0px Helvetica}\n</style>\n</head>\n<body>\n<p class=\"p1\">4 - K+ leakage</p>\n</body>\n</html>\n",x:"visible",a:426,Z:"break-word",y:"preserve",aS:8,r:"inline",z:"8",k:"div",j:"absolute",aT:8,d:18,t:16,c:104,b:193,G:"#000000",aU:8,e:"0.000000"},"16":{aV:8,w:"1 - outward&nbsp;<div>K+ current</div>",x:"visible",a:211,Z:"break-word",y:"preserve",aS:8,r:"inline",z:"5",k:"div",j:"absolute",aT:8,b:88,t:16,e:"0.000000",G:"#000000",aU:8},"8":{o:"content-box",h:"cardiac-ap-3.gif",x:"visible",a:0,q:"100% 100%",b:23,j:"absolute",r:"inline",c:600,k:"div",z:"1",d:353},"19":{aV:8,w:"3 - outward Na+&nbsp;<div>pump current</div>",x:"visible",a:400,Z:"break-word",y:"preserve",aS:8,r:"inline",z:"7",k:"div",j:"absolute",aT:8,b:96,t:16,e:"0.000000",G:"#000000",aU:8},"14":{aV:8,w:"4 - K+ leakage",x:"visible",a:74,Z:"break-word",y:"preserve",aS:8,r:"inline",z:"3",k:"div",j:"absolute",aT:8,b:200,t:16,e:"1.000000",G:"#000000",aU:8},"9":{o:"content-box",h:"smiley.png",x:"visible",a:61,q:"100% 100%",b:280,j:"absolute",r:"inline",c:16,k:"div",z:"2",d:16},"17":{aV:8,w:"2 - delayed rectifier<div>current</div>",x:"visible",a:300,Z:"break-word",y:"preserve",aS:8,r:"inline",z:"6",k:"div",j:"absolute",aT:8,d:37,t:16,c:137,b:25,G:"#000000",aU:8,e:"0.000000"},"15":{aV:8,w:"0 - fast inward&nbsp;<div>Na+&nbsp;current</div>",x:"visible",a:67,Z:"break-word",y:"preserve",aS:8,r:"inline",z:"4",k:"div",j:"absolute",aT:8,b:78,t:16,e:"0.000000",G:"#000000",aU:8}},backgroundColor:"#FFFFFF",name:"Untitled Scene"}];


	
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
	hypeDoc.setMainContentContainerID("cardiacap_hype_container");
	hypeDoc.setResourcesFolderName(resourcesFolderName);
	hypeDoc.setShowHypeBuiltWatermark(1);
	hypeDoc.setShowLoadingPage(false);
	hypeDoc.setDrawSceneBackgrounds(true);
	hypeDoc.setDocumentName(documentName);

	HYPE.documents[documentName] = hypeDoc.API;

	hypeDoc.documentLoad(this.body);
}());

