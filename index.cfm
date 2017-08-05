<cfscript>
sg = new sgCFJava();

// result = sg.mailSend(
//   from = 'EMAIL',
//   to = 'EMAIL',
//   subject = 'Hey, this is starting to work',
//   text = 'I am the body of the email.'
// );

  result = sg.stats( start_date = '2017-08-04' );

writeDump( var='#result#', format='html', abort='true' );

</cfscript>