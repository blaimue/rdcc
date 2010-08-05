// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

SlidingDatePicker = function(node, histogram_sirs) {
	var color = "#999";
	var hilightColor = "#666";
	var r = Raphael(node, 400, 60);
	
	var values = [];
	var dateKeys = [];
	var now = new Date();
	for (var i = 30; i >= 0; i--) {
		var date = new Date(now.getTime() - i*1000*60*60*24);
		
		var month = date.getMonth()+1;
		if (month < 10) {
			month = "0" + month;
		}
		
		var day = date.getDate();
	  if (day < 10) {
		  day = "0" + day;
	  }
		var dateKey = [date.getFullYear(), month, day].join("-");
		dateKeys.push(dateKey);
	}
	
	// fill out missing hash keys
	for (var i = 0; i < dateKeys.length; i++) {
		var key = dateKeys[i];
		if (!histogram_sirs[key]) {
			histogram_sirs[key] = [];
		}
		if (histogram_sirs[key].length == 0) {
			values.push(0.1);
		} else {
			values.push(histogram_sirs[key].length);
		}
	}
	
	c = r.g.barchart(0,0,14*values.length,60,[values],{'vgutter':0, 'colors':[color]});
	
	c.hover(function(){
		
		var dateKey = dateKeys[this.bar.id];
		var sirs = histogram_sirs[dateKey];
		
		var html = "";
		if (sirs.length == 0) {
			html = ["<i>No SIRs on ", dateKey, "</i>"].join("");
		}
		else {
			if (sirs.length == 1) {
				html = ["1 SIR on ", dateKey, "<br />", ""];
			}
			else {
				html = [sirs.length, " SIRs on ", dateKey, "<br />", ""];
			}
			for (var i = 0; i < sirs.length; i++) {
				var sir = sirs[i].sir;	// they're wrapped in a generic object for some reason
				html.push(sir.involved);
				html.push(".  ");
			}
			html = html.join("");
  	}
		document.getElementById("slidingDatePickerData").innerHTML = html;
		
		this.bar.attr({fill: hilightColor});
	}, function(){
		document.getElementById("slidingDatePickerData").innerHTML = "";
		this.bar.attr({fill: color});
	});
	c.click(function(){
		var dateKey = dateKeys[this.bar.id];
		window.location = "/sirs?date=" + dateKey;
	});
}


function setAutoExpandTextareas(defaultHeight, defaultWidth) {
	var textareas = document.getElementsByTagName("textarea");
	for (var i = 0; i < textareas.length; i++) {
		textarea = textareas[i];
		if (!textarea.style) {
			textarea.style = {};
		}
		if (!textarea.value) {
			textarea.setAttribute("value", "");
		}
		textarea.setAttribute("cols", defaultWidth);
		textarea.setAttribute("rows", defaultHeight);
		textarea.onkeyup = function() {
		    var str = this.value;
		    var cols = this.cols;

		    var linecount = 0;
			var linefeeds = 0;
		    $A(str.split("\n")).each( function(l) {
		      linecount += Math.ceil( l.length / cols ); // take into account long lines
				linefeeds++;
		    } );
			if (linecount < defaultHeight) linecount = defaultHeight;
		    this.rows = linecount + 2;
		}
		textarea.onkeyup();
	}
}


function setReminders() {
	var tagNames = ["textarea", "input"];
	for (var k = 0; k < tagNames.length; k++) {
		var tagName = tagNames[k];
		var fields = document.getElementsByTagName(tagName);
		for (var i = 0; i < fields.length; i++) {
			var field = fields[i];
			field.onchange = function() {
				var labels = document.getElementsByTagName("label");
				for (var j=0; j < labels.length; j++) {
					var label = labels[j];
				
					if (label.getAttribute("for") == this.id) {
						label.setAttribute("class", "changed");
						break;
					}
				}
			}
		}
	}
	
	// buttons are ok - we want to be able to save stuff!
	var buttons = document.getElementsByTagName("button");
	for (var i = 0; i < buttons.length; i++) {
		var button = buttons[i];
		button.onclick = function() {
			skipReminderCheck = true;
		}
	}
	skipReminderCheck = false;
	window.onbeforeunload = checkReminders;
}

function checkReminders() {
	if (skipReminderCheck) return;
	var labels = document.getElementsByTagName("label");
	for (var j=0; j < labels.length; j++) {
		var label = labels[j];
		if (label.getAttribute("class") == "changed") {
			return "You have unsaved changes!";
		}
	}
}




