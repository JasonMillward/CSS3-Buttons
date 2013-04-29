<?php

if (isset( $_GET['url'] )) {

    stream_context_set_default( array( 'http' => array( 'method' => 'HEAD' ) ) );

    $headers = get_headers( $_GET['url'] , 1);


    preg_match ( "/[0-9]{3}/", $headers[0], $matches);

    $httpCode       = $matches[0];
    $tmp            = explode($httpCode, $headers[0]);
    $httpResponse   = $tmp[1];

    if (!isset($headers['Content-Length'])) {
        $headers['Content-Length'] = 0;
    }

    $headers['httpCode'] = $httpCode;
    $headers['httpResp'] = $httpResponse;

    print json_encode( $headers );
}