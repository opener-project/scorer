## Reference

### Command Line Interface

#### Examples:

##### Provide subexamples

This aplication reads a text from standard input in order to rate the given text.

    cat some_kind_of_kaf_file.kaf | scorer

This will output (JSON Format):

    {"overall":-0.06666666666666667,"Restaurant":0.3333333333333333,"Staff":-1.0,"Rooms":1.0,"Facilities":-1.0}

### Webservice

You can launch a webservice by executing:

    scorer-server

After launching the server, you can reach the webservice at
<http://localhost:9292>.

The webservice takes several options that get passed along to
[Puma](http://puma.io), the webserver used by the component. The options are:

    -h, --help                Shows this help message
        --puma-help           Shows the options of Puma
    -b, --bucket              The S3 bucket to store output in
        --authentication      An authentication endpoint to use
        --secret              Parameter name for the authentication secret
        --token               Parameter name for the authentication token
        --disable-syslog      Disables Syslog logging (enabled by default)

### Daemon

The daemon has the default OpeNER daemon options. Being:

    -h, --help                Shows this help message
    -i, --input               The name of the input queue (default: opener-scorer)
    -b, --bucket              The S3 bucket to store output in (default: opener-scorer)
    -P, --pidfile             Path to the PID file (default: /var/run/opener/opener-scorer-daemon.pid)
    -t, --threads             The amount of threads to use (default: 10)
    -w, --wait                The amount of seconds to wait for the daemon to start (default: 3)
        --disable-syslog      Disables Syslog logging (enabled by default)

When calling ner without "start", "stop" or "restart" the daemon will start as a
foreground process.

### Environment Variables

These daemons make use of Amazon SQS queues and other Amazon services. For these
services to work correctly you'll need to have various environment variables
set. These are as following:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_REGION`

For example:

    AWS_REGION='eu-west-1' language-identifier start [other options]
