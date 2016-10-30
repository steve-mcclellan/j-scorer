$( ".users-show, .users-sample" ).ready( function() {
  $( "#stats-area" ).tabs({
    // Ajax request stuff, mostly pulled from jQuery UI's docs.
    beforeLoad: function( event, ui ) {

      // There's no need to do a fresh Ajax request each time the tab
      // is clicked. If the tab has been loaded already, skip the request
      // and display the pre-existing data.
      if ( ui.tab.data( "loaded" ) ) {
        event.preventDefault();
        return;
      }

      ui.panel.html( "Retrieving data - one moment please..." );

      ui.jqXHR.success( function() {
        ui.tab.data( "loaded", true );
      });

      ui.jqXHR.fail( function() {
        ui.panel.html(
          "Couldn't load this tab. Please try again later." );
      });
    }
  });

  // Make "Games" table sortable. Initialize default sort to
  // [ leftmost column, descending ]. Prevent meaningless attempts
  // to sort by "Actions" column (currently in position 3).
  $( "#gameTable" ).tablesorter({
    sortList: [[0,1]],
    headers: {
      3: { sorter: false }
    }
  });

  $( "#gameTable" ).stickyTableHeaders({
    scrollableArea: $( '#stats-area' )
  });

  // Similarly, make "Topics" table sortable.
  // Default sort: [ leftmost column, ascending ].
  $( "#topicTable" ).tablesorter({
    sortList: [[0,0]]
  });

  $( "#topicTable" ).stickyTableHeaders({
    scrollableArea: $( '#stats-area' )
  });
});
