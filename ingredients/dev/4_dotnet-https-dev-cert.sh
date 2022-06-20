#!/bin/bash
#|#./ingredients/dev/4_dotnet-https-dev-cert.sh #ASP.NET Dev HTTPS Cert [Requires /dev/dotnet ingredient]

# Trust ASP.NET localhost https certificate
# See: https://docs.microsoft.com/en-us/aspnet/core/security/enforcing-ssl?view=aspnetcore-6.0&tabs=visual-studio#ssl-linux
# See: https://github.com/dotnet/aspnetcore/issues/32842

# Create cert
dotnet dev-certs https

# Export cert to current directory, we will copy this into various directories to properly setup the cert
dotnet dev-certs https -ep localhost.crt --format PEM

# Create directory for storing the cert (as a .crt file) for browsers, and copy cert
sudo mkdir -p /usr/share/ca-certificates/aspnet
sudo cp localhost.crt /usr/share/ca-certificates/aspnet/aspnetcore-https-localhost.crt

# Trust Firefox
# Still WIP
if [[ -e /usr/bin/firefox ]]; then
    echo "Setting up ASP.NET HTTPS dev certificate for Firefox..."
fi

# Trust Chromium based browsers
if [[ -e /usr/bin/google-chrome-stable ]]; then
    echo "Setting up ASP.NET HTTPS dev certificate for Google Chrome..."
    certutil -d sql:$HOME/.pki/nssdb -A -t "P,," -n localhost -i /usr/share/ca-certificates/aspnet/aspnetcore-https-localhost.crt
    certutil -d sql:$HOME/.pki/nssdb -A -t "C,," -n localhost -i /usr/share/ca-certificates/aspnet/aspnetcore-https-localhost.crt
fi

# Trust at OS level, command line utils, etc.
sudo cp localhost.crt /usr/share/ca-certificates/trust-source/anchors/aspnetcore-https-localhost.pem
sudo update-ca-trust extract

# Trust dotnet-to-dotnet
sudo cp localhost.crt /etc/ssl/certs/aspnetcore-https-localhost.pem

# Remove cert from current directory
rm localhost.crt