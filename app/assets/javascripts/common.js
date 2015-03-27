function isDefined(variable) {
  return (typeof(variable) != 'undefined');
}
function isDefinedAndNonNull(variable) {
  return ((typeof(variable) != 'undefined') && (variable != null));
}
function isNullOrEmpty(value) {
  return ((value == null) || (value == ''));
}
function resolveElement(element) {
  if (typeof(element) == 'object')
    return element;
  else if (typeof(element) == 'string')
    return document.getElementById(element);
  else
    throw "element must be a string or object type";
}
function roundNumber(number, places) {
  return Math.round(number * Math.pow(10,places)) / Math.pow(10, places);
}
function parseWKTPoint(wktPoint) {
  var currentLocationCoordinates = /POINT\s*\((-?\d+(?:\.\d*)?)\s+(-?\d+(?:\.\d*)?)\)/g.exec(wktPoint);
  if (currentLocationCoordinates == null)
    return null;
  else
    return { lat: parseFloat(currentLocationCoordinates[2]), lng: parseFloat(currentLocationCoordinates[1]) };
}
function formatWKTPoint(point, precision) {
  if (!isDefinedAndNonNull(precision)) precision = 4;
  return "POINT (" + roundNumber(point.lng, precision) + " " + roundNumber(point.lat, precision) + ")";
}
function parseWKTPolygon(wktPolygon) {
  var parsedVertices = new Array();
  var polygonVerticesMatches = /POLYGON\s*\(\s*\(\s*([\-\d\. ,]*?)\s*\)\s*\)/g.exec(wktPolygon);
  if (polygonVerticesMatches != null) {
    var vertices = polygonVerticesMatches[1].split(',');
    for (var i = 0; i < vertices.length; i++) {
      var verticeParts = vertices[i].trim().split(' ');
      parsedVertices.push( { lng: parseFloat(verticeParts[0]), lat: parseFloat(verticeParts[1]) } );
    }
  }
  return parsedVertices;
}
function formatWKTPolygon(vertices, precision) {
  if (!isDefinedAndNonNull(precision)) precision = 4;
  var polygonWKT = "POLYGON ((";
  for (var i = 0; i < vertices.length; i++) {
    if (i > 0) polygonWKT += ", ";
    polygonWKT += (roundNumber(vertices[i].lng, precision) + " " + roundNumber(vertices[i].lat, precision));
  }
  polygonWKT += "))";
  return polygonWKT;
}
function escapeHtml(str) {
  var div = document.createElement('div');
  div.appendChild(document.createTextNode(str));
  return div.innerHTML;
}
function escapeRegex(regex) {
  return String(regex).replace(/([-()\[\]{}+?*.$\^|,:#<!\\])/g, '\\$1').replace(/\x08/g, '\\x08');
}
// this function will parse the supplied date string as a date in the local time zone
function parseDateLocal(dateString) {
  var utcDate = new Date(dateString);
  if (utcDate.getHours() == 0) {
    return utcDate;
  }
  else {
    return new Date(utcDate.getTime() + utcDate.getTimezoneOffset() * 60 * 1000);
  }
}
function initializeStyledCheckboxes(parentElement) {
  if (!isDefinedAndNonNull(parentElement)) {
    parentElement = $(document);
  }
  parentElement.find('label.styled-checkbox input[type="checkbox"]').click(
    function(e) {
      var isChecked = $(this).is(':checked');
      var glyphiconSpan = $(this).parent().find('span.glyphicon');
      if (isChecked) {
        glyphiconSpan.removeClass('glyphicon-unchecked');
        glyphiconSpan.addClass('glyphicon-check');
      }
      else {
        glyphiconSpan.removeClass('glyphicon-check');
        glyphiconSpan.addClass('glyphicon-unchecked');
      }
    }
  );
}

function fitModalHeight(modal) {
  var body, bodypaddings, header, headerheight, height, modalheight, dialog, dialogVerticalPadding;
  header = $(".modal-header", modal);
  footer = $(".modal-footer", modal);
  body = $(".modal-body", modal);
  dialog = $(".modal-dialog", modal);
  modalheight = parseInt(modal.css("height"));
  headerheight = parseInt(header.css("height")) + parseInt(header.css("padding-top")) + parseInt(header.css("padding-bottom"));
  footerheight = parseInt(footer.css("height")) + parseInt(footer.css("padding-top")) + parseInt(footer.css("padding-bottom"));
  bodypaddings = parseInt(body.css("padding-top")) + parseInt(body.css("padding-bottom"));
  dialogVerticalPadding = parseInt(dialog.css("margin-top")) + parseInt(dialog.css("margin-bottom"));
  height = $(window).height() - headerheight - footerheight - bodypaddings - dialogVerticalPadding;
  return body.css({"max-height": "" + height + "px", 'height':'auto'});
};

function fitContentHeight(element) {
  var height = $(window).height() - $(element).offset().top;
  $(element).css( {"height": "" + height + "px" } );
};

function enableField(field) {
  var jqField = $(field);
  if (!isDefined(jqField.attr('disabled'))) return;
  var restoreValue = jqField.data('restore-value');
  if (isDefined(restoreValue)) {
    jqField.val(restoreValue);
  }
  jqField.removeAttr('disabled');
}

function disableField(field) {
  var jqField = $(field);
  jqField.data('restore-value', jqField.val());
  jqField.val(null);
  jqField.attr('disabled','disabled');
}

function getIsoDate(dateVal) {
  return dateVal.toISOString().substr(0,10);
}

// from https://developer.mozilla.org/en-US/docs/Browser_detection_using_the_user_agent
function isMobileBrowser() {
  return (navigator.userAgent.match(/Mobi/));
}
