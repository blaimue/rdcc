// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function addPersonToSir(textfield, person_table) {
	
	// we need to wait until the autocomplete has populated the field before we submit the form
	var autocomplete = document.getElementById("sir_" + person_table + "_name_auto_complete");
	if (autocomplete.style.display != "none") {
		return;
	}
	
	var nameField = document.getElementById("add_" + person_table + "_name");
	nameField.value = textfield.value;
	textfield.value = "";
	nameField.parentNode.onsubmit();
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




