var nMapWidth:Number = mcMapBase._width;  // mcMapBase is the blue background behind the map
var nMapHeight:Number = mcMapBase._height;
var nMapTop:Number = mcMapBase._y - (nMapHeight/2) ;
var nMapBottom:Number = nMapTop + nMapHeight;
var nMapLeft:Number = mcMapBase._x - (nMapWidth/2);
var nMapRight:Number = nMapLeft + nMapWidth;

var nMapMoveSpeed:Number = 2;  // factor for the speed of programmed moves; lower # = faster move
var nMapMoveInterval:Number;
var bXthere:Boolean = false;
var bYthere:Boolean = false;
var bZthere:Boolean = false;

var nMapMoveInterval:Number;
	
var nInitX:Number = 35;
var nInitY:Number = 85;

var nSliderLeft:Number = 176;
var nSliderRight:Number = 676;
var nSliderSpan:Number = nSliderRight - nSliderLeft;
var nZoomInScale:Number = 1000;
var nZoomOutScale:Number = 70;
var nScaleSpan:Number = nZoomInScale - nZoomOutScale;
var nSliderInterval:Number;



var sZoneMapFolder:String = "zonemaps/"; // 2-16-07

var ttAlert:Tooltip = new Tooltip(this, 0xFFFFFF, 0x000000);

var aCorOrigDests:Array = new Array( "New York - Minneapolis", "Boston - Birmingham", "Chicago  - Miami", "Boston - Miami", "San Antonio - Jacksonville", "Kansas City - New York", "Detroit - Miami", "Laredo - Raleigh", "San Diego - Seattle", "Salt Lake City - Chicago", "Los Angeles - El Paso", "Chicago - Mobile", "Dallas - Raleigh", "Knoxville - Harrisburg", "New Orleans - Baltimore" );
var aCorFreeways:Array = new Array( "I80-I90-I94", "I95-I85-I20", "I65-I24-I75-Florida Turnpike", "I95", "I10", "I70-I78", "I75", "I35-I30-I40", "I5", "I80-I55", "I10", "I65", "I20-I85", "I81", "I10-I65-I85-I95" );
var aCorPathDescripts:Array = new Array( "New York - Cleveland - Toledo - Chicago - Minneapolis", "Boston - New York - Philadelphia - Baltimore - Richmond - Atlanta - Birmingham", "Chicago - Nashville - Atlanta - Miami", "Boston - New York - Baltimore - Jacksonville - Miami", "San Antonio - Houston - New Orleans - Jacksonville", "Kansas City - St. Louis - Indianapolis - Dayton - Harrisburg - New York", "Detroit - Dayton - Knoxville - Atlanta - Miami", "Laredo - Dallas - Memphis - Nashville - Knoxville - Raleigh", "San Diego - Los Angeles - Seattle", "Salt Lake City-Des Moines-Chicago", "Los Angeles-El Paso", "Chicago-Indianapolis-Nashville-Birmingham-Mobile", "Dallas - Jackson - Birmingham - Atlanta - Raleigh", "Knoxville - Harrisburg", "New Orleans - Mobile - Atlanta - Richmond - Baltimore" );
//var aCorURLS:Array = new Array();
var oZoneXYs:Object = new Object();

ccbCorridors.addItem( {data: "Choose", label: "Choose a Corridor"} );
var oCorridorListener:Object = new Object();

ccbStates.addItem( {data: "Choose", label: "Choose a State"} );
var oStateListener:Object = new Object();


var aCorridors:Array = new Array();  // 'A', 'B', 'C', ...
var aZoneObjects:Array = new Array(); // list of unnamed objects containing each zone's data
var oCorridorZoneAssocs:Object = new Object();  // for each corridor, a list of its associated zones
var oZoneCorridorAssocs:Object = new Object();  // for each zone, a list of its associated corridors
var sHilitedCor:String = "US"; 
var bZoneHighlighted:Boolean = false;


///////// ZONE XML LOADING   ////////////////////////////////////
var bZoneXMLLoaded:Boolean = false;
var xmlZones:XML = new XML();
var xnCorridors:XMLNode = new XMLNode();
xmlZones.ignoreWhite = true;
xmlZones.load("priority_zones_rev3.xml");
xmlZones.onLoad = function(bSuccess:Boolean):Void {
	bZoneXMLLoaded = true;
	xnCorridors = this.firstChild;
	var nNumZonesThisCor:Number;
	var sCurrentCorLetter:String = "";
	var sCurrentZoneName:String = "";
	
	var sPriority:String;
	var sHiway:String;
	var sLength:String;
	var sFrom:String;
	var sTo:String;
	
	// following 4 added 2-15-07
	var sBeginLat:String;
	var sBeginLong:String;
	var sEndLat:String;
	var sEndLong:String;
	
	var sBeginLatLong:String;
	var sEndLatLong:String;
	
	var nThisZoneIndexNum:Number = 0;
	
	var xnThisCor:XMLNode = new XMLNode();
	var xnThisZone:XMLNode = new XMLNode();
	
	for (var i:Number = 0; i < xnCorridors.childNodes.length; i++) {
		xnThisCor = xnCorridors.childNodes[i];
		aCorridors.push(xnThisCor.attributes.name);  // creates list of corridors: A,B,C,...
		sCurrentCorLetter = aCorridors[i];
		ccbCorridors.addItem( { data: sCurrentCorLetter, label: aCorOrigDests[i] } ); // load the combobox
		nNumZonesThisCor = xnThisCor.childNodes.length;
		
		oCorridorZoneAssocs[sCurrentCorLetter] = new Array();
		
		for (var j:Number = 0; j < nNumZonesThisCor; j++) {
			
			nThisZoneIndexNum ++ ;
			
			xnThisZone = xnThisCor.childNodes[j];
			sCurrentZoneName = sCurrentCorLetter + (j + 1);
			sPriority = xnThisZone.attributes.priority;
			sHiway = xnThisZone.childNodes[0].childNodes[0].nodeValue;
			sLength = xnThisZone.childNodes[1].childNodes[0].nodeValue;
			sFrom = xnThisZone.childNodes[2].attributes.city + ", " + xnThisZone.childNodes[2].attributes.state;
			sTo = xnThisZone.childNodes[3].attributes.city + ", " + xnThisZone.childNodes[3].attributes.state;
			
			// added 2-15-07
			sBeginLat = xnThisZone.childNodes[4].attributes.lat;
			sBeginLong = xnThisZone.childNodes[4].attributes.long;
			sEndLat = xnThisZone.childNodes[5].attributes.lat;
			sEndLong = xnThisZone.childNodes[5].attributes.long;
			
			sBeginLatLong = sBeginLat + ", " + sBeginLong; //xnThisZone.childNodes[4].attributes.lat + ", " + xnThisZone.childNodes[4].attributes.long;
			sEndLatLong = sEndLat + ", " + sEndLong; //xnThisZone.childNodes[5].attributes.lat + ", " + xnThisZone.childNodes[5].attributes.long;
			
			oCorridorZoneAssocs[sCurrentCorLetter].push(sCurrentZoneName);
			oZoneCorridorAssocs[sCurrentZoneName] = new Array(sCurrentCorLetter);
			
			// to the array, add a new generic obj containing each of the properties req'd for each zone
			aZoneObjects[nThisZoneIndexNum - 1] = { zonename: sCurrentZoneName, priority: sPriority, hiway: sHiway, zonelength: sLength, from: sFrom, to: sTo, beginlatlong: sBeginLatLong, endlatlong: sEndLatLong, beginLat: sBeginLat, beginLong: sBeginLong, endLat: sEndLat, endLong: sEndLong };
		
			applyEventHandlerToZoneMC(mcMap.mcZones["mc" + sCurrentZoneName], nThisZoneIndexNum - 1);			
		}
		
		assignCorridorEvents(i); 
	}
	
	// exceptions to corridors having only zones with their own letters
	oCorridorZoneAssocs["C"].push("A5");
	oCorridorZoneAssocs["D"].push("B1", "B2", "B3", "B4", "B5", "B9");
	oCorridorZoneAssocs["G"].push("C4", "C5", "C6", "C7", "C9", "C10");
	oCorridorZoneAssocs["L"].push("A5", "C2", "C6");
	oCorridorZoneAssocs["M"].push("B2", "B7", "B8", "B10");
	oCorridorZoneAssocs["N"].push("H2");
	oCorridorZoneAssocs["O"].push("B4", "B4", "B6", "B7", "L5", "B9", "E8");  // replace dynamically generated array altogether, since *all* of Cor O's zones exist already on previous cor's 
	
	ccbCorridors.addEventListener("change", oCorridorListener);
	
	// zones that are associated w/more than one corridor
	oZoneCorridorAssocs["A5"].push("C", "L");
	oZoneCorridorAssocs["B1"].push("D");
	oZoneCorridorAssocs["B2"].push("D");
	oZoneCorridorAssocs["B3"].push("D");
	oZoneCorridorAssocs["B4"].push("D");
	oZoneCorridorAssocs["B5"].push("D", "O");
	oZoneCorridorAssocs["B6"].push("M", "O");
	oZoneCorridorAssocs["B7"].push("M", "O");
	oZoneCorridorAssocs["B8"].push("M");
	oZoneCorridorAssocs["B9"].push("D", "O");
	oZoneCorridorAssocs["B10"].push("M");
	oZoneCorridorAssocs["C2"].push("L");
	oZoneCorridorAssocs["C4"].push("G");
	oZoneCorridorAssocs["C5"].push("G");
	oZoneCorridorAssocs["C6"].push("G");
	oZoneCorridorAssocs["C7"].push("G");
	oZoneCorridorAssocs["C8"].push("L");
	oZoneCorridorAssocs["C9"].push("G");
	oZoneCorridorAssocs["C10"].push("G");
	oZoneCorridorAssocs["E3"].push("L", "O");
	oZoneCorridorAssocs["E8"].push("O");
	oZoneCorridorAssocs["H2"].push("N");
	oZoneCorridorAssocs["L5"].push("O");
};




///////// ZONE X-Y XML LOADING   ////////////////////////////////////
var bXYXMLLoaded:Boolean = false;
var oZoneXYs:Object = new Object();
var xmlZoneXYs:XML = new XML();
xmlZoneXYs.ignoreWhite = true;
xmlZoneXYs.load("zonexys.xml");
xmlZoneXYs.onLoad = function(bSuccess:Boolean):Void {
	bXYXMLLoaded = true;
	var xnZoneXYs:XMLNode = new XMLNode();
	xnZoneXYs = this.firstChild;
	for (var i:Number = 0; i < xmlZoneXYs.firstChild.childNodes.length; i++) {
		
		// commented 2-15-07 to change the way googlemap urls are done. Instead of bringing them in form the xml, we'll be generating them dynamically from the zones' lat/longs
		//oZoneXYs[xnZoneXYs.childNodes[i].attributes.name] = { x: xnZoneXYs.childNodes[i].attributes.x, y: xnZoneXYs.childNodes[i].attributes.y, gmapurl: xnZoneXYs.childNodes[i].attributes.gmapurl };  // each 
		
		oZoneXYs[xnZoneXYs.childNodes[i].attributes.name] = { x: xnZoneXYs.childNodes[i].attributes.x, y: xnZoneXYs.childNodes[i].attributes.y }; 
		
	}
	ccbStates.addEventListener("change", oStateListener);
};





///////// TRUCKSTOP XML LOADING   ////////////////////////////////////
var bTruckstopXMLLoaded:Boolean = false;
var oZoneTruckStops:Object = new Object();
var xmlTruckStops:XML = new XML();
var xnTruckStops:XMLNode = new XMLNode();
var xnZoneTruckStops:XMLNode = new XMLNode();
xmlTruckStops.ignoreWhite = true;
xmlTruckStops.load("truckstops4.xml");
xmlTruckStops.onLoad = function(bSuccess:Boolean):Void {
	bTruckstopXMLLoaded = true;
	xnTruckStops = this.firstChild;
	var sTSname:String = "";
	var sTSspaces:String = "";
	var sTSaddress:String = "";
	var sTSdirections:String = "";
	
	for (var i:Number = 0; i < xnTruckStops.childNodes.length; i++) {
		var sCurrentZoneName:String = xnTruckStops.childNodes[i].attributes.name;
		oZoneTruckStops[sCurrentZoneName] = new Array();
		xnZoneTruckStops = xnTruckStops.childNodes[i];
		for (var j:Number = 0; j < xnZoneTruckStops.childNodes.length; j++) {
			sTSname = xnZoneTruckStops.childNodes[j].attributes.name;
			sTSspaces = xnZoneTruckStops.childNodes[j].attributes.spaces;
			sTSaddress = xnZoneTruckStops.childNodes[j].attributes.address;
			sTSdirections = xnZoneTruckStops.childNodes[j].attributes.directions;
			
			oZoneTruckStops[sCurrentZoneName][j] = { name: sTSname, spaces: sTSspaces, address: sTSaddress, directions: sTSdirections }; 
			
			//trace(oZoneTruckStops[sCurrentZoneName][j].spaces);
		}
	}
};


///////// EXISTING ELECTRIFIED TRUCKSTOP XML LOADING / 5-4-07  ////////////////////////////////////
var bTSEXMLLoaded:Boolean = false;
var oZoneTSEs:Object = new Object();
var xmlTSEs:XML = new XML();
var xnTSEs:XMLNode = new XMLNode();
var xnZoneTSEs:XMLNode = new XMLNode();
xmlTSEs.ignoreWhite = true;
xmlTSEs.load("tse.xml");
xmlTSEs.onLoad = function(bSuccess:Boolean):Void {
	bTSEXMLLoaded = true;
	xnTSEs = this.firstChild;
		
	for (var i:Number = 0; i < xnTSEs.childNodes.length; i++) {
		var sCurrentTSECorridor:String = xnTSEs.childNodes[i].attributes.name;
		oZoneTSEs[sCurrentTSECorridor] = new Array();
		xnZoneTSEs = xnTSEs.childNodes[i];
		
		for (var k:Number = 0; k < xnZoneTSEs.childNodes.length; k++) { 
			oZoneTSEs[sCurrentTSECorridor][k] = { 
				installer: xnZoneTSEs.childNodes[k].attributes.installer, 
				location: xnZoneTSEs.childNodes[k].attributes.location, 
				units: xnZoneTSEs.childNodes[k].attributes.units,
				city: xnZoneTSEs.childNodes[k].attributes.city,
				state: xnZoneTSEs.childNodes[k].attributes.state,
				zip: xnZoneTSEs.childNodes[k].attributes.zip,
				lat: xnZoneTSEs.childNodes[k].attributes.lat,
				lng: xnZoneTSEs.childNodes[k].attributes.lng,
				zone: xnZoneTSEs.childNodes[k].attributes.zone,
				highway: xnZoneTSEs.childNodes[k].attributes.highway,
				address: xnZoneTSEs.childNodes[k].attributes.address
				}; 
			//trace(oZoneTSEs[sCurrentTSECorridor][k].location);
		}
	}
};


///////// STATES X-Y XML LOADING   ////////////////////////////////////
var bStatesXMLLoaded:Boolean = false;
var oStateXYs:Object = new Object();
var xmlStateXYs:XML = new XML();
xmlStateXYs.ignoreWhite = true;
xmlStateXYs.load("statesxys.xml");
xmlStateXYs.onLoad = function(bSuccess:Boolean):Void {
	bStatesXMLLoaded = true;
	var xnStateXYs:XMLNode = new XMLNode();
	xnStateXYs = this.firstChild;
	for (var i:Number = 0; i < xnStateXYs.childNodes.length; i++) {
		oStateXYs[xnStateXYs.childNodes[i].attributes.name] = { x: xnStateXYs.childNodes[i].attributes.x, y: xnStateXYs.childNodes[i].attributes.y, scale: xnStateXYs.childNodes[i].attributes.scale };
		ccbStates.addItem( xnStateXYs.childNodes[i].attributes.name );
	}
};

var sGoogleMapURL:String = "";
var sThisZoneName:String = "";

///////// INITIAL STATE  /////////////////////////////////////////////

// main map
positionScaleMap(nInitX, nInitY, nZoomOutScale);  // initial map settings; also for "reset" btn
mcMap.mcAllButStates.mcCorridorRegRect._visible = false;
mcMap.mcZones.mcZonesRegRect._visible = false;
mcGoogleMapLink._visible = false;
mcKeyMask._visible = false; // this, on its own layer, covers the map key at the top when a google map screenshot is up
mcMap.setMask(mcMapMask);




///////// EVENT HANDLERS / FUNCTIONS  ////////////////////////////////////

mcMap.mcStates.onPress = function():Void {
	ccbStates.selectedIndex = 0;
	nMapMoveInterval = setInterval(dragMapItems, 50);
	this.startDrag();
		
	restoreDimmed();
	//mcMap.mcAllButStates._visible = false;
	//mcMap.mcZones._visible = false;
	bZoneHighlighted = false;
	
	//mcZoneMapHolder.mcZoneMap.removeMovieClip(); // commented 2-16-07
	//mcZoneMapHolder.unloadMovie();  // added 2-16-07
	
	mcGoogleMapLink._visible = false;
	mcKeyMask._visible = false;
};
mcMap.mcStates.onRelease = function():Void {
	releaseMap(this);
};
mcMap.mcStates.onReleaseOutside = function():Void {
	releaseMap(this);
};

function releaseMap(mcThis:MovieClip):Void {
	mcThis.stopDrag();
	blankCorText();
	blankZoneText();
	clearInterval(nMapMoveInterval);
	reportXYZ();  // for authoring only
}
function dragMapItems():Void {
	var nX:Number = mcMap.mcStates._x;
	var nY:Number = mcMap.mcStates._y;
	
	mcMap.mcAllButStates._x = nX
	mcMap.mcAllButStates._y = nY;
	mcMap.mcZones._x = nX;
	mcMap.mcZones._y = nY;
	mcMap.mcSigns._x = nX;
	mcMap.mcSigns._y = nY;
}

btnResetMap.onRelease = function():Void {
	restoreDimmed();
	blankZoneText();
	blankCorText();
	positionScaleMap(nInitX, nInitY, nZoomOutScale);
	bZoneHighlighted = false;
	
	//mcZoneMapHolder.mcZoneMap.removeMovieClip(); // commented 2-16-07
	//mcZoneMapHolder.unloadMovie();  // added 2-16-07
	
	mcGoogleMapLink._visible = false;
	mcKeyMask._visible = false;
	
	ccbCorridors.selectedIndex = 0;
};

btnPrintCorInfo.onRelease = function():Void {
	//trace(sHilitedCor);
	if (sHilitedCor == "" || sHilitedCor == undefined || sHilitedCor == "US") {
		getURL("corridors/" + "US.htm", sHilitedCor);
	} else {
		getURL("corridors/" + sHilitedCor.toLowerCase() + ".htm", sHilitedCor);
	}
};

mcGoogleMapLink.onRelease = function():Void {
	trace(sGoogleMapURL.toLowerCase());
	if (sGoogleMapURL != "") {
		getURL(sGoogleMapURL.toLowerCase(), "_blank");
	} 
}

mcSliderKnob.onPress = function():Void {
	//restoreDimmed();
	ccbStates.selectedIndex = 0;
	nSliderInterval = setInterval(slide, 100);
	bZoneHighlighted = false;
	
	//mcZoneMapHolder.mcZoneMap.removeMovieClip(); // commented 2-16-07
	//mcZoneMapHolder.unloadMovie();  // added 2-16-07
	
	mcGoogleMapLink._visible = false;
	mcKeyMask._visible = false;
	
};
mcSliderKnob.onRelease = function():Void {
	clearInterval(nSliderInterval);
	// reportXYZ();  // authoring
};
mcSliderKnob.onReleaseOutside = function():Void {
	clearInterval(nSliderInterval);
	// reportXYZ();  // authoring
};

function assignCorridorEvents(nCorIndex:Number):Void {
		
		mcMap.mcAllButStates["mcCorridor" + aCorridors[nCorIndex]].onRollOver = function():Void {
			
			if (bZoneHighlighted) {
				return;
			}
			
			var sThisName:String = this._name.toString();
			var sThisLetter:String = sThisName.charAt(sThisName.length - 1);  // gets cor letter 'A', 'B', etc.  
			displayCorInfo(nCorIndex);
			hiliteCorridor(sThisLetter); 
		};
	
		mcMap.mcAllButStates["mcCorridor" + aCorridors[nCorIndex]].onRollOut = function():Void {

		};
}

function applyEventHandlerToZoneMC(mcZone:MovieClip, nIndexInZoneObjArray:Number):Void {
	mcZone.onRollOver = function():Void {
		
		if (bZoneHighlighted) {
			return;
		}

		taPriority.text = aZoneObjects[nIndexInZoneObjArray].priority;
		taHighways.text = aZoneObjects[nIndexInZoneObjArray].hiway;
		taLength.text = aZoneObjects[nIndexInZoneObjArray].zonelength + " miles";
		taFrom.text = aZoneObjects[nIndexInZoneObjArray].from;
		taTo.text = aZoneObjects[nIndexInZoneObjArray].to;
		taBeginLatLong.text = aZoneObjects[nIndexInZoneObjArray].beginlatlong;
		taEndLatLong.text = aZoneObjects[nIndexInZoneObjArray].endlatlong;
		
		sThisZoneName = this._name.substring(2);  // strips off 'mc'; returns, e.g., 'J1'
		var aCorList:Array = oZoneCorridorAssocs[sThisZoneName];
		var sCorList:String = aCorList.toString();
		if (aCorList.length > 1) {
			// check if one of the associated corridors for this zone is already hilited
			var bOneHilited:Boolean = false;
			for (var i:Number = 0; i < aCorList.length; i++) {
				if (aCorList[i] == sHilitedCor) {
					bOneHilited = true;
					break;
				}
			}
			if (!bOneHilited) {
				hiliteCorridor(aCorList[0]);
				displayCorInfo(returnCorIndexFromLetter(aCorList[0]), "NOTE: there are multiple corridors associated with this zone.\n\n");
			}			
		} else {
			hiliteCorridor(sCorList);
			displayCorInfo(returnCorIndexFromLetter(sCorList));
		}
		
		// display zone truck stop info
		var sTSname:String = "";
		var sTSspaces:String = "";
		var sTSaddress:String = "";
		var sTSdirections:String = "";
		var nTruckStops:Number = oZoneTruckStops[sThisZoneName].length;
		
		
		// Existing electrified truckstops rev. 4-19-07
		// check each TSE within the current corridor to see if it's in the current zone
		var sThisTSECor:String = sThisZoneName.slice(0,1);  // pulls out the corridor letter from the zone name. e.g., gets 'A' from 'A10'
		var nTSEsInZone:Number = 0; // keep track of the TSEs in this zone. It will usually be 0, occasionally more than one
		var nTotalTSEsInCor:Number = oZoneTSEs[sThisTSECor].length; //
		var aIndivTSEtext:Array = new Array();  // will contain the details on each existing TSE
		
		for (var k:Number = 0; k < nTotalTSEsInCor; k++) {
			if (oZoneTSEs[sThisTSECor][k].zone == sThisZoneName) {  
				nTSEsInZone++;
				
				var oTemp:Object = oZoneTSEs[sThisTSECor][k];
				var sTempText:String = nTSEsInZone + ") " + oTemp.location + "\nADDRESS: " + oTemp.address + ", " + oTemp.city + ", " + oTemp.state + " " + oTemp.zip + "\nDIRECTIONS: " + oTemp.highway;
				aIndivTSEtext.push(sTempText);
			}
		}

		
	
		if (nTruckStops > 1) {
			taTruckStops.text = "In this zone, there are " + nTruckStops + " truck stops of 75 or more spaces. ";
		} else if (nTruckStops == 1) {
			taTruckStops.text = "In this zone, there is one truck stop with 75 or more spaces. ";
		} else { // no eligible truckstops in this zone; added this contingency 4-10-07
			taTruckStops.text = "There are no truck stops in this zone of 75 or more spaces. ";
		}
		
		if (nTSEsInZone == 1) {
			taTruckStops.text += "There is one existing electrified truckstop.\n\n";
		} else if (nTSEsInZone > 1) {
			taTruckStops.text += "There are " + nTSEsInZone + " existing electrified truckstops.\n\n";
		} else {  // most be none
			taTruckStops.text += "There are no existing electrified truckstops.\n\n";
		}
		
		
		if (nTruckStops > 0) {
			taTruckStops.text += "CANDIDATE TRUCKSTOPS: \n\n";
		}
		
		for (var j:Number = 0; j < nTruckStops; j++) {
			sTSname = oZoneTruckStops[sThisZoneName][j].name;
			sTSspaces = oZoneTruckStops[sThisZoneName][j].spaces;
			sTSaddress = oZoneTruckStops[sThisZoneName][j].address;
			sTSdirections = oZoneTruckStops[sThisZoneName][j].directions;
			taTruckStops.text += (j + 1).toString() + ") NAME: " + sTSname + "\nSPACES: " + sTSspaces + "\nADDRESS: \n" + sTSaddress + "\nDIRECTIONS: \n" + sTSdirections;
			//if (j != nTruckStops - 1) {  
			taTruckStops.text += "\n\n"; // for every truck stop, insert two line breaks AFTER		
			//}
		}			
		
		
		
		// -- write EXISTING TSE data here -- rev. 4-19-07 //
		taTruckStops.text += "ELECTRIFIED TRUCKSTOP(S): \n";
		
		for (var m:Number = 0; m < nTSEsInZone; m++) {
			taTruckStops.text += "\n" + aIndivTSEtext[m] + "\n";
		}		
		
		
		
		

		
		ttAlert.showTip("CLICK NOW to focus on this zone");
	};
	
	
	
	
	
	mcZone.onRollOut = function():Void {
		if (!bZoneHighlighted) {
			blankZoneText();
			//dtZoneAlert.text = "";
			ttAlert.removeTip();
		}

	};
	
	mcZone.onRelease = function():Void {
		if (!bZoneHighlighted) {
			
			
			//mcZoneMapHolder.loadMovie(sZoneMapFolder + sThisZoneName + ".jpg");  // 2-16-07, commented 6-10-07			
			var nX:Number = oZoneXYs[this._name.substring(2)].x;
			var nY:Number = oZoneXYs[this._name.substring(2)].y;
			
			// changed 2-15-07 to generate gmap urls on the fly from the lats/longs, using the function 'createGmapURL' (from 'gmapurls.as')
			//sGoogleMapURL = oZoneXYs[this._name.substring(2)].gmapurl;
			//sGoogleMapURL = createGmapURL(aZoneObjects[nIndexInZoneObjArray].beginLat, aZoneObjects[nIndexInZoneObjArray].beginLong, aZoneObjects[nIndexInZoneObjArray].endLat, aZoneObjects[nIndexInZoneObjArray].endLong );
			
			sGoogleMapURL = "zones/" + sThisZoneName + ".htm";  // above commented and this added 6-4-07

			
			trace("ZONE: " + sThisZoneName);
			
			//positionScaleMap(nX, nY, 1000);  // temp comment 6-11-07
			bZoneHighlighted = true;
			dimZones();
			this._alpha = 100;
			ttAlert.removeTip();
			
			mcGoogleMapLink._visible = true;
			mcKeyMask._visible = true;
			
			// following line commented 2-16-07 to change to loading zone maps on the fly; see new way above
			//var mcZoneMap:MovieClip = mcZoneMapHolder.attachMovie(sThisZoneName + "map", "mcZoneMap", mcZoneMapHolder.getNextHighestDepth());
			
			
			
		}
	};
}

function blankZoneText():Void {
	taPriority.text = "";
	taHighways.text = ""; 
	taLength.text = "";
	taFrom.text = "";
	taTo.text = "";
	taBeginLatLong.text = "";
	taEndLatLong.text = "";
	taTruckStops.text = "";
}
function createOverZoneAlertBox():Void {
	mcMap.createTextField("txtOverZoneAlert", this.getNextHighestDepth(), 20, 20, 100, 50);
	mcMap.txtOverZoneAlert.text = "Click this zone to see it info.";
	mcMap.txtOverZoneAlert.background = true;
	mcMap.txtOverZoneAlert.border = true;
	mcMap.txtOverZoneAlert.setNewTextFormat(new TextFormat("Arial, _sans", 20, 0x000000, false, false, false, null, null, "right"));
	mcMap.txtOverZoneAlert.autoSize = "left";
}





function blankCorText():Void {
	taCorridors.text = "";
	ccbCorridors.selectedIndex = 0;
}
function displayCorInfo(nCorIndex:Number, sMultCorText:String):Void {
	//blankZoneText();
	
	if (arguments.length < 2) { // only corridor index supplied
		sMultCorText = "";
	}
	var sCorOrigDest:String = aCorOrigDests[nCorIndex];
	var sCorFreeways:String = aCorFreeways[nCorIndex];
	var sCorPath:String = aCorPathDescripts[nCorIndex];
	var sCorText:String = sMultCorText + "CORRIDOR: " + sCorOrigDest + "\nFREEWAYS: " + sCorFreeways + "\nCITIES: " + sCorPath;
	taCorridors.text = sCorText;
 }

oCorridorListener.change = function(oEvent:Object):Void {
	//mcZoneMapHolder.mcZoneMap.removeMovieClip(); // commented 2-16-07
	//mcZoneMapHolder.unloadMovie();  // added 2-16-07; commented 6-10-06
	
	blankZoneText();
	bZoneHighlighted = false;
	mcGoogleMapLink._visible = false;
	mcKeyMask._visible = false;
	//trace("map gone?");
	ccbStates.selectedIndex = 0;
	
	clearInterval(nMapMoveInterval);
	var sCorLetter:String = oEvent.target.value;
	
	if (sCorLetter == "Choose") {  //  they've chosen "Choose a Corridor" from the combobox
		bZoneHighlighted = false;
		positionScaleMap(nInitX, nInitY, nZoomOutScale);
		restoreDimmed();
		return;
	}
		
	hiliteCorridor(sCorLetter);
	displayCorInfo(ccbCorridors.selectedIndex - 1);
	
	switch (sCorLetter) {
		case "A" : nMapMoveInterval = setInterval(motionToXYZ, 50, -208, 115, 182 );
			break;
		case "B" : nMapMoveInterval = setInterval(motionToXYZ, 50, -234,  41, 167 );
			break;
		case "C" : nMapMoveInterval = setInterval(motionToXYZ, 50, -171, -47, 126 );
			break;
		case "D" : nMapMoveInterval = setInterval(motionToXYZ, 50, -260, -14, 111 );
			break;
		case "E" : nMapMoveInterval = setInterval(motionToXYZ, 50, -119,-143, 198 );
			break;
		case "F" : nMapMoveInterval = setInterval(motionToXYZ, 50, -200,  44, 172 );
			break;
		case "G" : nMapMoveInterval = setInterval(motionToXYZ, 50, -226, -41, 124 );
			break;
		case "H" : nMapMoveInterval = setInterval(motionToXYZ, 50, -108, -84, 157 );
			break;
		case "I" : nMapMoveInterval = setInterval(motionToXYZ, 50,  358, 127, 124 );
			break;
		case "J" : nMapMoveInterval = setInterval(motionToXYZ, 50,   57,  75, 152 );
			break;
		case "K" : nMapMoveInterval = setInterval(motionToXYZ, 50,  293, -71, 280 );
			break;
		case "L" : nMapMoveInterval = setInterval(motionToXYZ, 50, -136, -24, 167 );
			break;
		case "M" : nMapMoveInterval = setInterval(motionToXYZ, 50, -145, -99, 182 );
			break;
		case "N" : nMapMoveInterval = setInterval(motionToXYZ, 50, -272,  24, 314 );
			break;
		case "O" : nMapMoveInterval = setInterval(motionToXYZ, 50, -165, -42, 159 );	
			break;
		default: positionScaleMap(nInitX, nInitY, nZoomOutScale);
	}
};

oStateListener.change = function(oEvent:Object):Void {
	clearInterval(nMapMoveInterval);
	ccbCorridors.selectedIndex = 0;
	
	var sStateName:String = oEvent.target.value;
	//trace("selected state: " + sStateName);
	
	//mcZoneMapHolder.mcZoneMap.removeMovieClip(); // commented 2-16-07
	//mcZoneMapHolder.unloadMovie();  // added 2-16-07; commented 6-10-06
	
	blankZoneText();
	bZoneHighlighted = false;
	mcGoogleMapLink._visible = false;
	mcKeyMask._visible = false;
	restoreDimmed();
	
	if (sStateName == "Choose") {
		positionScaleMap(nInitX, nInitY, nZoomOutScale);
		restoreDimmed();
		return;
	}
	
	nMapMoveInterval = setInterval(motionToXYZ, 50, oStateXYs[sStateName].x, oStateXYs[sStateName].y, oStateXYs[sStateName].scale);
};


///////// FUNCTIONS  ////////////////////////////////////

function positionScaleMap(nX:Number, nY:Number, nScale:Number):Void {
	
	ccbStates.selectedIndex = 0;
	
	if (arguments.length == 1) {  // only a scaling number supplied
		nScale = arguments[0];
		setMapScale();
		return;
	}	
	if (arguments.length == 2) { // only x and y coords supplied
		nX = arguments[0];
		nY = arguments[1];
		setMapXY();
		return;
	}
	// if all three parameters supplied:
	setMapXY();
	setMapScale();
		
	function setMapXY():Void {
		mcMap.mcStates._x = nX;  
		mcMap.mcStates._y = nY;
		mcMap.mcAllButStates._x = nX;
		mcMap.mcAllButStates._y = nY;
		mcMap.mcZones._x = nX;
		mcMap.mcZones._y = nY;
		mcMap.mcSigns._x = nX;
		mcMap.mcSigns._y = nY;
		//setNavMapXY(nX, nY);
	}
	
	// to keep the "registration point" visually consistent, scaling is done by scaling the *enclosing* movie clip, not each individual layer mc within it
	function setMapScale():Void {
		mcMap._xscale = nScale;
		mcMap._yscale = nScale;
		setSlider(nScale);
		//setNavMapOverlayScale(nScale);
	}
}
//------------------------------------------------------------------------------------------------
function slide():Void {
	mcSliderKnob._x = _xmouse;
	
	if (mcSliderKnob._x < nSliderLeft) {
		mcSliderKnob._x = nSliderLeft;
	}
	if (mcSliderKnob._x > nSliderRight) {
		mcSliderKnob._x = nSliderRight;
	}
	
	var nSliderPortion:Number = (mcSliderKnob._x - nSliderLeft) / nSliderSpan;
	positionScaleMap( (nSliderPortion * nScaleSpan) + nZoomOutScale );
}
//------------------------------------------------------------------------------------------------
function setSlider(nMapScale:Number):Void {
	var nScalePortion:Number = ( nMapScale - nZoomOutScale ) / nScaleSpan;
	mcSliderKnob._x = nSliderLeft + ( nSliderSpan * nScalePortion );
}
//------------------------------------------------------------------------------------------------
// programmed move function
function motionToXYZ(nTargetX:Number, nTargetY:Number, nTargetZ:Number):Void {
	//mcMap.mcAllButStates._visible = false;
	//mcMap.mcZones._visible = false;
	
	var nNextXdistance:Number = (nTargetX - mcMap.mcStates._x) / nMapMoveSpeed;
	var nNextYdistance:Number = (nTargetY - mcMap.mcStates._y) / nMapMoveSpeed;
	var nNextZdistance:Number = (nTargetZ - mcMap._xscale) / nMapMoveSpeed;

	if (Math.abs(nNextXdistance) < .25) {
		mcMap.mcStates._x = nTargetX;
		mcMap.mcAllButStates._x = nTargetX; // 9-27-06
		mcMap.mcZones._x = nTargetX;
		mcMap.mcSigns._x = nTargetX;
		bXthere = true;
	} else {
		mcMap.mcStates._x += nNextXdistance;
		mcMap.mcAllButStates._x += nNextXdistance;
		mcMap.mcZones._x += nNextXdistance;
		mcMap.mcSigns._x += nNextXdistance;
	}
	
	if (Math.abs(nNextYdistance) < .25) {
		mcMap.mcStates._y = nTargetY;
		mcMap.mcAllButStates._y = ntargetY;
		mcMap.mcZones._y = nTargetY;
		mcMap.mcSigns._y = nTargetY;
		bYthere = true;
	} else {
		mcMap.mcStates._y += nNextYdistance;
		mcMap.mcAllButStates._y += nNextYdistance;
		mcMap.mcZones._y += nNextYdistance;
		mcMap.mcSigns._y += nNextYdistance;
	}
	
	if (Math.abs(nNextZdistance) < .25) {
		bZthere = true;
	} else {
		mcMap._xscale += nNextZdistance;
		mcMap._yscale += nNextZdistance;
		setSlider(mcMap._xscale);
		//setNavMapOverlayScale(mcMap._xscale)
	}
	
	if (bXthere == true && bYthere == true && bZthere == true) {
		mcMap.mcAllButStates._x = mcMap.mcStates._x;
		mcMap.mcAllButStates._y = mcMap.mcStates._y;
		//mcMap.mcAllButStates._visible = true;
		mcMap.mcZones._x = mcMap.mcStates._x;
		mcMap.mcZones._y = mcMap.mcStates._y;
		//mcMap.mcZones._visible = true;
		
		clearInterval(nMapMoveInterval);
		
		bXthere = false;
		bYthere = false;
		bZthere = false;
	}	
}

//------------------------------------------------------------------------------------------------
// corridor highlighting
function hiliteCorridor(sCorLetterToHilite:String):Void {
	sHilitedCor = sCorLetterToHilite;
	
	dimCorridors();
	dimZones();

	mcMap.mcAllButStates["mcCorridor" + sCorLetterToHilite]._alpha = 100;
		
	for (var i:Number = 0; i <= oCorridorZoneAssocs[sCorLetterToHilite].length; i++) {
		mcMap.mcZones["mc" + oCorridorZoneAssocs[sCorLetterToHilite][i]]._alpha = 100;
	}
	
	ccbCorridors.selectedIndex = returnCorIndexFromLetter(sCorLetterToHilite) + 1;  // 09-27-06
	
}
function dimCorridors(nDimmedAlpha:Number):Void {
	aHighlitedCors.splice(0); // deletes all items in list
	if (arguments.length == 0) {
		nDimmedAlpha = 15;
	}
	for (var i:Number = 0; i < aCorridors.length; i++) {
		mcMap.mcAllButStates["mcCorridor" + aCorridors[i]]._alpha = nDimmedAlpha;
	}
}
function dimZones(nDimmedAlpha:Number):Void {
	if (arguments.length == 0) {
		nDimmedAlpha = 15;
	}
	for (sProp:String in oCorridorZoneAssocs) {
		for (var i:Number = 0; i <= oCorridorZoneAssocs[sProp].length; i++) {
			mcMap.mcZones["mc" + oCorridorZoneAssocs[sProp][i]]._alpha = nDimmedAlpha;
		}
	}
}
function restoreDimmed():Void {
	for (var i:Number = 0; i < aCorridors.length; i++) {
		mcMap.mcAllButStates["mcCorridor" + aCorridors[i]]._alpha = 100;
	}
	sHilitedCor = "";
	for (sProp:String in oCorridorZoneAssocs) {
		for (var i:Number = 0; i <= oCorridorZoneAssocs[sProp].length; i++) {
			mcMap.mcZones["mc" + oCorridorZoneAssocs[sProp][i]]._alpha = 100;
		}
	}
}
//------------------------------------------------------------------------------------------------
// utility
function returnCorIndexFromLetter(sCorLetter:String):Number {
	for (var i:Number = 0; i < aCorridors.length; i++) {
		if (sCorLetter == aCorridors[i]) {
			return i;
		}
	}
}

//------------------------------------------------------------------------------------------------
// for authoring
function reportXYZ():Void {
	trace("x=\"" + Math.round(mcMap.mcStates._x) + "\"" + " y=\"" + Math.round(mcMap.mcStates._y) + "\"" + " scale=\"" + Math.round(mcMap._xscale) + "\"\n");
}