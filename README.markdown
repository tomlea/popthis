# Can't POP(3) This.

<img src="http://cwninja.github.com/popthis/hammertime.gif" alt="Hammer Time"/>

So you downloaded [inaction_mailer](http://github.com/cwninja/inaction_mailer), and you had a folder full of e-mails generated while writing your app?

Now you want to preview your e-mails?!? You people are never happy!

Well, I'm a little tipsy, so I'm going to be nice, and I'm going to let you get at your mails with POP3!

I hope you like it. I do!

## Instalation:

    gem install popthis -s http://gemcutter.org

## Usage:

Start the server:

    popthis tmp/mails/

Now, configure your mail client as follows:

* Server: **localhost**
* Protocol: **POP3**
* Port: **2220**
* Username: anything
* Password: anything

You should now be able to see the contents of your tmp/mails folder in your mail client!

## Origins:

I stole most of the code from [here](http://snippets.dzone.com/posts/show/5906)... so credit where credit's due.
