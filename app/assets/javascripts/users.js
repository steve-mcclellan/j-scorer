// NOTE: The shared function that produces a disabled-cookies warning on
//       the signup and login pages is located in the sessions.js file.

$( ".users-show, .users-sample" ).ready( function() {

  // Returns an array of play type abbreviations corresponding
  // to the checked boxes on the play types tab, or ['none']
  // if no boxes are checked.
  function getCheckedPlayTypeBoxes() {
    var types = $( "#typeTable :checked" ).map( function() {
      return this.id.slice(0, -4);
    }).get();

    if (types.length === 0) { return ['none']; }
    return types;
  }

  function getObjectFromSentences( dateType ) {
    var result = {};
    result.reverse = ( $( "#" + dateType + "-verb" ).val() === "hide" );
    result.preposition = $( "#" + dateType + "-preposition" ).val();
    switch (result.preposition) {
      case "sinceBeg":
        var beginDate = $( "#" + dateType + "-beginning-dropdown" ).val();
        result.beginning = ( beginDate || null );
        break;
      case "inLast":
        result.last_number = $( "#" + dateType + "-last-number" ).val();
        result.last_unit = $( "#" + dateType + "-last-unit" ).val();
        break;
      case "since":
        result.from = $( "#" + dateType + "-from input" ).val();
        break;
      case "from":
        result.from = $( "#" + dateType + "-from input" ).val();
        result.to = $( "#" + dateType + "-to input" ).val();
        break;
    }
    return result;
  }

  function makeDateFilterObject() {
    var result = {};
    var showDateObject = getObjectFromSentences( "show-date" ),
        datePlayedObject = getObjectFromSentences( "date-played" );
    for ( var key in showDateObject ) {
      result["show_date_" + key] = showDateObject[key];
    }
    for ( key in datePlayedObject ) {
      result["date_played_" + key] = datePlayedObject[key];
    }
    return result
  }

  function makeFilterObject() {
    return $.extend( makeDateFilterObject(),
                     { rerun_status: $( "#rerun-status" ).val(),
                       play_types: getCheckedPlayTypeBoxes() } );
  }

  function makeFilterQueryString() {
    return $.param( makeDateFilterObject() ) +
           "&rerun_status=" + $( "#rerun-status" ).val() +
           "&play_types=" + getCheckedPlayTypeBoxes().join( ',' );
  }

  function laterDate( date1, date2 ) {
    return date1 > date2 ? date1 : date2;
  }

  function updateFilterSentence( dateType ) {
    var preposition = $( "#" + dateType + "-preposition" ).val();
    $( "." + dateType + "-filter-object" ).hide();
    switch (preposition) {
      case "sinceBeg":
        $( "#" + dateType + "-beginning-span" ).show();
        break;
      case "inLast":
        var $options = $( "#" + dateType + "-last-unit option" ),
            num = parseFloat( $( "#" + dateType + "-last-number" ).val() );
        if ( num === 1 && $options.text().slice(-1) === "s" ) {
          $options.text( function( _, prevText ) {
            return prevText.slice(0, -1);
          });
        } else if ( num !== 1 && $options.text().slice(-1) !== "s" ) {
          $options.text( function( _, prevText ) {
            return prevText + "s";
          });
        }
        $( "#" + dateType + "-last-span" ).show();
        break;
      case "since":
        if (!storedToDates[dateType]) {
          var $toDatePicker = $( "#" + dateType + "-to-picker" );
          storedToDates[dateType] = $toDatePicker.find( "input" ).val();
          $toDatePicker.data( "DateTimePicker" ).date("9999-12-31");
        }
        $( "#" + dateType + "-from" ).show();
        break;
      case "from":
        if (storedToDates[dateType]) {
          var $toDatePicker = $( "#" + dateType + "-to-picker" ),
              fromDate = $( "#" + dateType + "-from-picker input" ).val(),
              newToDate = laterDate( fromDate, storedToDates[dateType] );
          $toDatePicker.data( "DateTimePicker" ).date( newToDate );
          storedToDates[dateType] = undefined;
        }
        $( "#" + dateType + "-from" ).show();
        $( "#" + dateType + "-to" ).show();
        break;
    }
  }

  $( "#stats-area" ).tabs();

  var $gameTable = $( "#gameTable" ),
      $topicTable = $( "#topicTable" ),
      $typeTable = $( "#typeTable" ),
      $showDateFromPicker = $( "#show-date-from-picker" ),
      $showDateToPicker = $( "#show-date-to-picker" ),
      $datePlayedFromPicker = $( "#date-played-from-picker" ),
      $datePlayedToPicker = $( "#date-played-to-picker" ),
      storedToDates = { "show-date": undefined, "date-played": undefined };

  // Remove these before Tablesorter can get its grubby mitts on them.
  var $untracked = $( "tr.untracked" ).detach();

  // Make "Games" table sortable. Initialize default sort to
  // [ leftmost column, descending ]. Prevent meaningless attempts
  // to sort by "Actions" column (currently in position 9).
  // To prevent a JS error, skip this if the table is empty.
  if ( !$gameTable.hasClass( 'empty' ) ) {
    $gameTable.tablesorter({
      sortList: [[0,1]],
      sortInitialOrder: "desc",
      headers: {
        1: { sortInitialOrder: "asc" },  // Rerun status (check or -)
        3: { sortInitialOrder: "asc" },  // Play type (text)
        9: { sortInitialOrder: "asc" },  // Final (check or X)
        10: { sorter: false }            // Actions
      }
    });
  }

  $gameTable.stickyTableHeaders({
    scrollableArea: $( '#stats-area' )
  });

  // Similar for the "Topics" table.
  // Default sort: [ topic name, ascending ].
  // Make everything else sort descending on first click.
  $topicTable.tablesorter({
    sortList: [[0,0]],
    sortInitialOrder: "desc",
    headers: {
      0: { sortInitialOrder: "asc" }
    }
  });

  $topicTable.stickyTableHeaders({
    scrollableArea: $( '#stats-area' )
  });

  // And similar for "Play types" table. Initialize default sort to
  // [ Games played, descending ]. Prevent meaningless attempts
  // to sort by checkbox column (currently in position 0).
  // To prevent a JS error, skip this if the table is empty.
  if ( !$typeTable.hasClass( "empty" ) ) {
    $typeTable.tablesorter({
      sortList: [[2,1]],
      sortInitialOrder: "desc",
      headers: {
        0: { sorter: false },
        1: { sortInitialOrder: "asc" }  // Play type (text)
      }
    });
  }

  $typeTable.stickyTableHeaders({
    scrollableArea: $( '#stats-area' )
  });

  $( "#show-all-games" ).on( "click", function() {
    $untracked.appendTo( "#gameTable tbody" );
    $untracked = null;
    $( "#some-hidden" ).hide();
    $( "#all-shown" ).show();
    $gameTable.trigger( "update", true );
  });

  $( "#hide-untracked-games" ).on( "click", function() {
    $untracked = $( "tr.untracked" ).detach();
    $( "#all-shown" ).hide();
    $( "#some-hidden" ).show();
    $gameTable.trigger( "update", true );
  });

  $( ".update-user-filters" ).on( "click", function() {
    if ( !$( this ).hasClass( "disabled" ) ) {
      $( ".update-user-filters" ).addClass( "disabled" )
                                 .html( "Updating..." );
      $.ajax({
        url: "/filters",
        method: "PATCH",
        data: makeFilterObject(),
        dataType: "json",
        success: function() { window.location.replace( "/stats" ); },
        error: function( data ) {
          console.log( "Error details:" );
          console.log( data.responseJSON );
          alert( "Oops. Something went wrong. If this persists, please " +
                 "email <%= ENV['SUPPORT_ADDRESS'] %>." );
          $( ".update-user-filters" ).removeClass( "disabled" )
                                     .html( "Update stats" );
        }
      });
    }
  });

  $( ".update-sample-filters" ).on( "click", function() {
    if ( !$( this ).hasClass( "disabled" ) ) {
      $( ".update-sample-filters" ).addClass( "disabled" )
                                   .html( "Updating..." );
      var url = "/sample?" + makeFilterQueryString();
      window.location.replace( url );
    }
  });

  $( "#show-date-preposition, #show-date-last-number" ).change( function() {
    updateFilterSentence( "show-date" );
  });

  $showDateFromPicker.datetimepicker({
    format: "YYYY-MM-DD",
    minDate: "0001-01-01",
    focusOnShow: false
  });
  $showDateFromPicker.data( "DateTimePicker" ).timeZone( undefined );

  $showDateToPicker.datetimepicker({
    format: "YYYY-MM-DD",
    maxDate: "9999-12-31",
    focusOnShow: false
  });
  $showDateToPicker.data( "DateTimePicker" ).timeZone( undefined );

  $showDateFromPicker.on( "dp.change", function( e ) {
    $showDateToPicker.data( "DateTimePicker" ).minDate( e.date );
  });

  $showDateToPicker.on( "dp.change", function( e ) {
    $showDateFromPicker.data( "DateTimePicker" ).maxDate( e.date );
  });

  $( "#date-played-preposition, #date-played-last-number" ).change( function() {
    updateFilterSentence( "date-played" );
  });

  $datePlayedFromPicker.datetimepicker({
    format: "YYYY-MM-DD",
    minDate: "0001-01-01",
    focusOnShow: false
  });
  $datePlayedFromPicker.data( "DateTimePicker" ).timeZone( undefined );

  $datePlayedToPicker.datetimepicker({
    format: "YYYY-MM-DD",
    maxDate: "9999-12-31",
    focusOnShow: false
  });
  $datePlayedToPicker.data( "DateTimePicker" ).timeZone( undefined );

  $datePlayedFromPicker.on( "dp.change", function( e ) {
    $datePlayedToPicker.data( "DateTimePicker" ).minDate( e.date );
  });

  $datePlayedToPicker.on( "dp.change", function( e ) {
    $datePlayedFromPicker.data( "DateTimePicker" ).maxDate( e.date );
  });

  updateFilterSentence( "show-date" );
  updateFilterSentence( "date-played" );

  $( "#stats-loading-message" ).remove();
  $( "#stats-area" ).show();
});
