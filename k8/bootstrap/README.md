# boostrap


bs is our bootsrap binary that we use to encapsulate everything so it can be used from dev and CI
````
	bs tools:iGofish
````


But, for now we just install gofish the old way (https://gofi.sh/index.html)

darwin and linux:
````
curl -fsSL https://raw.githubusercontent.com/fishworks/gofish/master/scripts/install.sh | bash
````


windows:

```` 
Set-ExecutionPolicy Bypass -Scope Process -Force
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/fishworks/gofish/master/scripts/install.ps1'))
````


