function handler(event) {

    var host = event.request.headers.host.value;
    var uri = event.request.uri;

    if (host === 'www.leveducacao.teste.sambatech.dev') {
            return {
        statusCode: 301,
            statusDescription: 'Moved Permanently',
        headers: {
               "location": {
               "value": 'https://leveducacao.teste.sambatech.dev' + uri
               }
        }
        };
    }
    return event.request;
}