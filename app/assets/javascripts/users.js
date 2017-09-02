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

  function makeFilterObject() {
    return { play_types: getCheckedPlayTypeBoxes() };
  }

  function makeFilterQueryString() {
    return "play_types=" + getCheckedPlayTypeBoxes().join(',');
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
  $untracked = $( "tr.untracked" ).detach();

  // Make "Games" table sortable. Initialize default sort to
  // [ leftmost column, descending ]. Prevent meaningless attempts
  // to sort by "Actions" column (currently in position 9).
  // To prevent a JS error, skip this if the table is empty.
  if ( !$gameTable.hasClass( 'empty' ) ) {
    $gameTable.tablesorter({
      sortList: [[0,1]],
      sortInitialOrder: "desc",
      headers: {
        2: { sortInitialOrder: "asc" },  // Play type (text)
        8: { sortInitialOrder: "asc" },  // Final (check or X)
        9: { sorter: false }
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
      if ( illegalValue() ) { return; }
      $( ".update-user-filters" ).addClass( "disabled" )
                                 .html( "Updating..." );
      $.ajax({
        url: "/filters",
        method: "PATCH",
        data: makeFilterObject(),
        dataType: "json",
        success: function() { window.location.replace( "/stats" ); },
        error: function() {
          alert( "Oops. Something went wrong." );
          $( "#update-user-filters" ).removeClass( "disabled" )
                                     .html( "Update stats" );
        }
      });
    }
  });

  $( ".update-sample-filters" ).on( "click", function() {
    if ( !$( this ).hasClass( "disabled" ) ) {
      if ( illegalValue() ) { return; }
      $( ".update-sample-filters" ).addClass( "disabled" )
                                   .html( "Updating..." );
      var url = "/sample?" + makeFilterQueryString();
      window.location.replace( url );
    }
  });

  function illegalValue() {
    if ( $( "#show-date-adverb" ).val() === "half-life" &&
          parseFloat( $( "#show-date-half-life-days" ).val() ) === 0 ) {
      alert( "Half-life cannot be zero." );
      return true;
    }
    if ( $( "#date-played-adverb" ).val() === "half-life" &&
        parseFloat( $( "#date-played-half-life-days" ).val() ) === 0 ) {
      alert( "Half-life cannot be zero." );
      return true;
    }
    return false;
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
      case "last":
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

  function updateWeightSentence( dateType ) {
    var adverb = $( "#" + dateType + "-adverb" ).val();
    $( "." + dateType + "-weight-object" ).hide();
    switch (adverb) {
      case "half-life":
        var num = parseFloat( $( "#" + dateType + "-half-life-days" ).val() ),
            pluralizedDay = ( num === 1 ? "day" : "days" );
        $( "#" + dateType + "-half-life-unit" ).text( pluralizedDay );
        $( "#" + dateType + "-half-life-span" ).show();
        break;
    }
  }

  updateFilterSentence( "show-date" );
  $( "#show-date-preposition, #show-date-last-number" ).change( function() {
    updateFilterSentence( "show-date" );
  });

  updateWeightSentence( "show-date" );
  $( "#show-date-adverb, #show-date-half-life-days" ).change( function() {
    updateWeightSentence( "show-date" );
  })

  $showDateFromPicker.datetimepicker({
    format: "YYYY-MM-DD",
    focusOnShow: false
  });
  $showDateFromPicker.data( "DateTimePicker" ).timeZone( undefined );

  $showDateToPicker.datetimepicker({
    format: "YYYY-MM-DD",
    focusOnShow: false
  });
  $showDateToPicker.data( "DateTimePicker" ).timeZone( undefined );

  $showDateFromPicker.on( "dp.change", function( e ) {
    $showDateToPicker.data( "DateTimePicker" ).minDate( e.date );
  });

  $showDateToPicker.on( "dp.change", function( e ) {
    $showDateFromPicker.data( "DateTimePicker" ).maxDate( e.date );
  });

  updateFilterSentence( "date-played" );
  $( "#date-played-preposition, #date-played-last-number" ).change( function() {
    updateFilterSentence( "date-played" );
  });

  updateWeightSentence( "date-played" );
  $( "#date-played-adverb, #date-played-half-life-days" ).change( function() {
    updateWeightSentence( "date-played" );
  });

  $datePlayedFromPicker.datetimepicker({
    format: "YYYY-MM-DD",
    focusOnShow: false
  });
  $datePlayedFromPicker.data( "DateTimePicker" ).timeZone( undefined );

  $datePlayedToPicker.datetimepicker({
    format: "YYYY-MM-DD",
    focusOnShow: false
  });
  $datePlayedToPicker.data( "DateTimePicker" ).timeZone( undefined );

  $datePlayedFromPicker.on( "dp.change", function( e ) {
    $datePlayedToPicker.data( "DateTimePicker" ).minDate( e.date );
  });

  $datePlayedToPicker.on( "dp.change", function( e ) {
    $datePlayedFromPicker.data( "DateTimePicker" ).maxDate( e.date );
  });

  $( "#stats-loading-message" ).remove();
  $( "#stats-area" ).show();
});
