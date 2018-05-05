﻿class Tooltip {		private var mcTooltip:MovieClip;	private var tfFormat:TextFormat;	private var mcTarget:MovieClip;		function Tooltip(mc:MovieClip, hex:Number, hex2:Number) {		mcTarget = mc;		this.mcTooltip = mcTarget.createEmptyMovieClip("tooltip", mcTarget.getNextHighestDepth());		this.mcTooltip.createTextField("theText", this.mcTooltip.getNextHighestDepth(), 3, 1, 175, 20);		this.mcTooltip.beginFill(hex);		this.mcTooltip.lineStyle(1, hex2, 100);		this.mcTooltip.moveTo(0, 0);		this.mcTooltip.lineTo(180, 0);		this.mcTooltip.lineTo(180, 20);		this.mcTooltip.lineTo(20, 20);		this.mcTooltip.lineTo(15, 30);		this.mcTooltip.lineTo(10, 20);		this.mcTooltip.lineTo(0, 20);		this.mcTooltip.lineTo(0, 0);		this.mcTooltip.endFill();		this.mcTooltip._visible = false;		this.mcTooltip.theText.selectable = false;		this.tfFormat = new TextFormat();		this.tfFormat.font = "Arial";		this.tfFormat.size = 11;		this.tfFormat.align = "center";		this.mcTooltip.theText.setNewTextFormat(this.tfFormat);			}		public function showTip(theText:String):Void {				this.mcTooltip.theText.text = theText;		this.mcTooltip._x = mcTarget._xmouse - 15;		this.mcTooltip._y = mcTarget._ymouse - 35;		this.mcTooltip._visible = true;		this.mcTooltip.onMouseMove = function() {			//trace("yes");			this._x = mcTarget._xmouse-15 ;			this._y = mcTarget._ymouse-35;			updateAfterEvent();		}			}		public function removeTip():Void {				this.mcTooltip._visible = false;		delete this.mcTooltip.onEnterFrame;		this.mcTooltip.removeMovieClip();			}}