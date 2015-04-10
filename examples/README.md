# bashconf examples

## A fragment of httpd.conf

### `httpd-conf-frag_pre.sh`

This is more complicated than strictly necessary as we are using it to 
display some preamble text as well as to override parameters.

We set `WRITE_ON_QUIT` to 0 as in this case we are not using the 'install'
phase in its normal way, but merely using its side effect of evaluating
the required parameters and not continuing until they are all there.

(When `WRITE_ON_QUIT` is 1 then we write the output file even in the 'quit'
phase.)

We change `INSTALL_LETTER` to `W` (for 'write') and `QUIT_LETTER` to `C`
(for 'cancel').

We also override the `BANNER` variable

### `httpd-conf-frag_params.sh`

Two parameters are defined. Both are required. 
* status_uri 
* monitor_ip

### `httpd-conf-frag_output.sh`

This output stage uses a clever trick which should probably not be 
used in production, but is handy for a demo

```
# http://pempek.net/articles/2013/07/08/bash-sh-as-template-engine/
function render_template {
  eval "echo \"$(cat $1)\""
}

```
Beware that using `eval` on a file can be dangerous, you really have to 
trust in your template file!

The script also demonstrates that you can use the `get_param` method in
your output script as well as the ANSI colour escapes

### `httpd-conf-frag_template.txt`

Not a standard one of our `${CONF}_*` files but it is referred to by the
output script. Holds the template for our config

### `httpd-conf-frag_install.sh`

It is empty in this case; we are only using the install phase for its side
effect of evaluating the required parameters.
