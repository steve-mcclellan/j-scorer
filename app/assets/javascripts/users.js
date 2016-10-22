$( ".users-show, .users-sample" ).ready( function() {
  $( "#stats-area" ).tabs({
    // Commented out as no Ajax requests are being made yet.
    // beforeLoad: function( event, ui ) {
    //   ui.jqXHR.fail( function() {
    //     ui.panel.html(
    //       "Couldn't load this tab. Please try again later." );
    //   });
    // }
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
