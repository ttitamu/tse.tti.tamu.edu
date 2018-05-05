///////// ELECTRIFIED TRUCKSTOP XML LOADING / 4-11-07  ////////////////////////////////////
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
		//trace("sCurrentTSECorridor: " + sCurrentTSECorridor);
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
			
			//
			trace(oZoneTSEs[sCurrentTSECorridor][k].location);
		}
	}
};