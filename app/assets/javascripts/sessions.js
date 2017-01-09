$( ".sessions-new, .users-new, .password_resets-new, .password_resets-edit" )
  .ready( function() {

  const cookieWarning = "<div class='no-cookie-box'>" +
    "This action requires cookies, which appear to be disabled " +
    "in your browser. You can either continue to use the " +
    "<span class='nowrap'>J! Scorer</span> as a guest, or " +
    "<a href='http://www.howtoenablecookies.net' target='_blank'>" +
    "enable cookies</a> to proceed."
    "</div>";

  if ( !Modernizr.cookies ) {
    $( "#browser-warnings" ).append( cookieWarning );
    $( ".form-control" ).prop( "disabled", true );
    $( ".submit-button" ).prop( "disabled", true )
                         .prop( "value", "Enable cookies to proceed" );
  }
});
