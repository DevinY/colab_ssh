# colab_ssh concept
This bash install openssh-server on colab.

fill connection info to colab, and than colab create ssh tunnel to your server,

therefor you can connect into colab via ssh tunnel from your server.

Example:
Fill your server's connection info, and past following comment in colab.
<pre>

!wget -qO- https://raw.githubusercontent.com/DevinY/colab_ssh/master/colab_sshserver.sh| bash -s user ip port public_key

</pre>

command:
<pre>
!wget -qO- https://raw.githubusercontent.com/DevinY/colab_ssh/master/colab_sshserver.sh| bash -s
</pre>

paramter:
<pre>
user ip port public_key
</pre>
