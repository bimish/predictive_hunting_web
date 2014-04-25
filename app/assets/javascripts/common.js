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
function setPageInitFunction(init) {
	$(document).ready(init);
	$(document).on('page:load', init);
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
