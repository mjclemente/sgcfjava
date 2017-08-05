component {

  public any function init() {

    var javaloaderfactoryUtility = new JavaLoaderFactory.JavaLoaderFactory();

    var jars = [
      expandPath('/lib/sendgrid-java-latest.jar')
    ];

    variables.javaloader = javaloaderfactoryUtility.getJavaLoader( jars );

    variables.SendGrid = variables.javaLoader.create( 'com.sendgrid.SendGrid' ).init( 'YOUR API KEY' );
    variables.Method = variables.javaLoader.create( 'com.sendgrid.Method' );
    return this;
  }

  public any function mailSend(
    required string from,
    required string to,
    required string subject,
    required string text ) {
    var jfrom = variables.javaLoader.create( 'com.sendgrid.Email' ).init( from );
    var jto = variables.javaLoader.create( 'com.sendgrid.Email' ).init( to );
    var jcontent = variables.javaLoader.create( 'com.sendgrid.Content' ).init( 'text/plain', 'and easy to do anywhere, even with ColdFusion' );
    var MailHelper = variables.javaLoader.create( 'com.sendgrid.Mail' ).init( jfrom, subject, jto, jcontent );

    return apiCall( 'mail/send', 'POST', MailHelper.build() );
  }

  public any function stats(
    numeric limit,
    numeric offset,
    string aggregated_by,
    required string start_date,
    string end_date ) {

    return apiCall( 'stats', 'GET', '', setupParams( arguments ) );
  }

  private any function apiCall( required string endpoint, string method = 'GET', any body = '', struct params = {} ) {
    var result = {};

    var requestStart = getTickCount();
    var req = variables.javaLoader.create( 'com.sendgrid.Request' ).init();
    req.setMethod( variables.Method[method] );
    req.setEndpoint( endpoint );

    for ( var param in params ) {
      req.addQueryParam( param, params[ param ] );
    }

    if ( body.len() ) req.setBody( body );

    try {
      var response = variables.SendGrid.api( req );

      result[ "statusCode" ] = response.getStatusCode();
      var body = response.getBody();
      result[ "fileContent" ] = isJSON( body ) ? deserializeJSON( body ) : body;
      result[ "responseHeader" ] = response.getHeaders();
      result[ "api_request_time" ] = getTickCount() - requestStart;

      return result;
    } catch( any e ) {
      writeDump( var='#e#', format='html', abort='true' );
      return e;
    }
  }

  private struct function setupParams( required struct params ) {
    var filteredParams = { };
    var paramKeys = structKeyArray( params );
    for ( var paramKey in paramKeys ) {
      if ( structKeyExists( params, paramKey ) && !isNull( params[ paramKey ] ) ) {
        filteredParams[ paramKey ] = params[ paramKey ];
      }
    }

    return filteredParams;
  }



}