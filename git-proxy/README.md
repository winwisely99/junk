# git-proxy

This acts as a git proxy server, providing a way to proxy a git repo when it is given access to a git repo.

It can act in two ways:

1. Doing Pr's to a Git repo as if it was another git user that had a fork

2.  Having full access and so haing the ability to present the master ( or a brach, tag) to the world as a File System.

## Use Cases

1. Storing your keys inside git.

	- In this case you should encrypt your keys locally against what cryptographic cypher scheme you prefer.

2. Allowing changes to a git repo to be done by a third party. 

	- For example for localisation.
