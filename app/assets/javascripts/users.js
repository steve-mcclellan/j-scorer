$( ".users-show, .users-sample" ).ready( function() {
  function getCheckedBoxes() {
    return $( "#typeTable :checked" ).map( function() {
      return this.id.slice(0, -4);
    }).get();
  }

  $( "#stats-area" ).tabs({
    // Ajax request stuff, mostly pulled from jQuery UI's docs.
    beforeLoad: function( event, ui ) {

      // There's no need to do a fresh Ajax request each time the tab
      // is clicked. If the tab has been loaded already (or is currently
      // loading), skip the request and display the pre-existing data
      // (or continue with the current request).
      if ( ui.tab.data( "loaded" ) || ui.tab.data( "loading" ) ) {
        event.preventDefault();
        return;
      }

      ui.tab.data( "loading", true );
      ui.panel.html( "Retrieving data - one moment please..." );

      ui.jqXHR.success( function() {
        ui.tab.data( "loading", false );
        ui.tab.data( "loaded", true );
      });

      ui.jqXHR.fail( function() {
        ui.tab.data( "loading", false );
        ui.panel.html( "Couldn't load this tab. Please try again later." );
      });
    }
  });

  // Make "Games" table sortable. Initialize default sort to
  // [ leftmost column, descending ]. Prevent meaningless attempts
  // to sort by "Actions" column (currently in position 6).
  $( "#gameTable" ).tablesorter({
    sortList: [[0,1]],
    headers: {
      6: { sorter: false }
    }
  });

  $( "#gameTable" ).stickyTableHeaders({
    scrollableArea: $( '#stats-area' )
  });

  // Similar for "Play types" table. Initialize default sort to
  // [ Games played, descending ]. Prevent meaningless attempts
  // to sort by checkbox column (currently in position 0).
  $( "#typeTable" ).tablesorter({
    sortList: [[2,1]],
    headers: {
      0: { sorter: false }
    }
  });

  $( "#typeTable" ).stickyTableHeaders({
    scrollableArea: $( '#stats-area' )
  });

  $( "#update-displayed-types" ).on( "click", function() {
    console.log( getCheckedBoxes() );
    // window.location.reload( true );
  });

  $( "#update-sample-types" ).on( "click", function() {
    window.location.replace( "/sample" );
  });

  // Set the topics tab (currently in position 2) to load in the background
  // as soon as everything else is done.
  $( "#stats-area" ).tabs( "load", 2 );
});
