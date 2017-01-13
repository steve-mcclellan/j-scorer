// NOTE: The shared function that produces a disabled-cookies warning on
//       the signup and login pages is located in the sessions.js file.

$( ".users-show, .users-sample" ).ready( function() {

  // Returns an array of play type abbreviations corresponding
  // to the checked boxes on the play types tab, or ['none']
  // if no boxes are checked.
  function getCheckedBoxes() {
    var types = $( "#typeTable :checked" ).map( function() {
      return this.id.slice(0, -4);
    }).get();

    if (types.length === 0) { return ['none']; }
    return types;
  }

  $( "#stats-area" ).tabs();

  var $gameTable = $( "#gameTable" );
  var $typeTable = $( "#typeTable" );

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
  $( "#topicTable" ).tablesorter({
    sortList: [[0,0]],
    sortInitialOrder: "desc",
    headers: {
      0: { sortInitialOrder: "asc" }
    }
  });

  $( "#topicTable" ).stickyTableHeaders({
    scrollableArea: $( '#stats-area' )
  });

  // And similar for "Play types" table. Initialize default sort to
  // [ Games played, descending ]. Prevent meaningless attempts
  // to sort by checkbox column (currently in position 0).
  // To prevent a JS error, skip this if the table is empty.
  if ( !$typeTable.hasClass( 'empty' ) ) {
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

  $( "#update-displayed-types" ).on( "click", function() {
    if ( !$( this ).hasClass( "disabled" ) ) {
      $( this ).addClass( "disabled" ).html( 'Updating...' );
      $.ajax({
        url: '/types',
        method: 'PATCH',
        data: { play_types: getCheckedBoxes() },
        dataType: 'json',
        success: function() { window.location.replace( '/stats' ); },
        error: function() {
          alert('Oops. Something went wrong.');
          $( "#update-displayed-types" ).removeClass( "disabled" )
                                        .html( 'Update stats' );
        }
      });
    }
  });

  $( "#update-sample-types" ).on( "click", function() {
    if ( !$( this ).hasClass( "disabled" ) ) {
      $( this ).addClass( "disabled" ).html( 'Updating...' );
      var url = "/sample?types=" + getCheckedBoxes().join();
      window.location.replace( url );
    }
  });
});
