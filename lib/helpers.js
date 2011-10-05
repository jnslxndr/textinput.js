// ====================
// = Basic CSV Parser =
// ====================
function parseCSV (csvString) {
    var delimiter = ';';
    var fieldEndMarker  = new RegExp('(['+delimiter+'\\n\\r] *)','g'); /* Comma is assumed as field separator */
    var qFieldEndMarker = new RegExp('(("")|([^"]))"(['+delimiter+'\n\r] *)','g');        /* Double quotes are assumed as the quote character */
    
    // var qFieldEndMarker = new RegExp('("")*"(['+delimiter+'\\n\\r] *)','g'); /* Double quotes are assumed as the quote character */
    // var fieldEndMarker  = new RegExp('([^"])"(['+delimiter+'\n\r] *)','g');  /* Comma is assumed as field separator */
    var startIndex = 0;
    var records = [], currentRecord = [];
    do {
        // If the to-be-matched substring starts with a double-quote, use the qFieldMarker regex, otherwise use fieldMarker.
        var endMarkerRE = (csvString.charAt (startIndex) == '"')  ? qFieldEndMarker : fieldEndMarker;
        endMarkerRE.lastIndex = startIndex;
        var matchArray = endMarkerRE.exec (csvString);
        if (!matchArray || !matchArray.length) {
            break;
        }
        var endIndex = endMarkerRE.lastIndex - matchArray[matchArray.length-1].length;
        var match = csvString.substring (startIndex, endIndex);
        if (match.charAt(0) == '"') { // The matching field starts with a quoting character, so remove the quotes
            match = match.substring (1, match.length-1).replace (/""/g, '"');
        }
        currentRecord.push (match);
        var marker = matchArray[0];
        if (marker.indexOf (delimiter) < 0) { // Field ends with newline, not comma
            
            records.push (currentRecord);
            currentRecord = [];
        }
        startIndex = endMarkerRE.lastIndex;
    } while (true);
    if (startIndex < csvString.length) { // Maybe something left over?
        var remaining = csvString.substring (startIndex).trim();
        if (remaining) currentRecord.push (remaining);
    }
    if (currentRecord.length > 0) { // Account for the last record
        records.push (currentRecord);
    }
    return records;
};



