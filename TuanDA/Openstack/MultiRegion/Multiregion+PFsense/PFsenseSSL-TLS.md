Site-to-Site Example Configuration (SSL/TLS)



../_images/diagrams-openvpn-site-to-site-ssl_tls.png
OpenVPN Example Site-to-Site SSL/TLS Network

The process of configuring a site-to-site connection using SSL/TLS is more complicated than Shared Key. However, this method is typically much more convenient for managing a large number of remote sites connecting back to a central site in a hub-and-spoke fashion. It can be used for a site-to-site between two nodes, but given the increased configuration complexity, most people prefer to use shared key rather than SSL/TLS for that scenario.

When configuring a site-to-site OpenVPN connection using SSL/TLS one firewall will be the server and the others will be clients. Usually the main location will be the server side and the remote offices will act as clients, though if one location has a static IP address and more bandwidth than the main office that may be a more desirable location for the server. In addition to the subnets on both ends there will be a dedicated subnet in use for the OpenVPN interconnection between networks. This example configuration is depicted in Figure OpenVPN Example Site-to-Site SSL/TLS Network.

10.3.101.0/24 is used as the IPv4 VPN Tunnel Network. The way OpenVPN allocates IP addresses is the same as for remote access clients. When using a Topology style of subnet, each client will obtain one IP address in a common subnet. When using a Topology style of net30, each connecting client gets a /30 subnet to interconnect itself with the server. See Topology for more details. The following sections describe how to configure the server and client sides of the connection. Any subnet can be used for this so long as it does not overlap any other subnet currently in use on the network.

In order for the server to reach the client networks behind each connection, two items are required:

A route to tell the operating system that OpenVPN knows about a remote network

An iroute in a Client-Specific Override that tells OpenVPN how to map that subnet to a specific certificate

More detail on this will follow in the example.

Configuring SSL/TLS Server Side
Before the VPN can be configured, a certificate structure for this VPN is required. Create a CA unique to this VPN and from that CA create a server certificate, and then a user certificate for each remote site. For the client sites, use a CN that identifies them uniquely in some way, such as their fully qualified domain name or a shortened site or hostname. For the specifics of creating a CA and Certificates, see Certificate Management. For this example, the CA will be called S2SCA, the Server CN will be serverA, the clients will be clientB and clientC.

Navigate to VPN > OpenVPN, Servers tab

Click fa-plus Add to create a new server

Fill in the fields as described below, with everything else left at defaults. These options are discussed in detail earlier in the chapter. Use values appropriate for this network, or the defaults if unsure.

Server Mode
Select Peer to Peer (SSL/TLS)

Protocol
Select UDP

Device Mode
Select tun

Interface
Select WAN

Local Port
Enter 1194 unless there is another active OpenVPN server, in which case use a different port

Description
Enter text here to describe the connection

TLS Authentication
Check this box to also do TLS authentication as well as SSL

Peer Certificate Authority
Select the CA created at the beginning of this process

Peer Certificate Revocation List
If a CRL was created, select it here

Server Certificate
Select the server certificate created at the beginning of this process

IPv4 Tunnel Network
Enter the chosen tunnel network, 10.3.101.0/24

IPv4 Local Network
Enter the LAN networks for all sites including the server: 10.3.0.0/24, 10.5.0.0/24, 10.7.0.0/24

Note

If there are more networks on the server side that need to be reached by the clients, such as networks reachable via static routes, other VPNs, and so on, add them as additional entries in the IPv4 Local Network box.

IPv4 Remote Network
Enter only the client LAN networks: 10.5.0.0/24, 10.7.0.0/24

Click Save.

Click fa-pencil to edit the new server instance

Find the TLS Authentication box

Select all of the text inside

Copy the text to the clipboard

Save this to a file or paste it into a text editor such as Notepad temporarily

Next, add a firewall rule on WAN allowing access to the OpenVPN server.

Navigate to Firewall > Rules, WAN tab

Click fa-level-up Add to create a new rule at the top of the list

Set Protocol to UDP

Leave the Source set to any since multiple sites will need to connect. Alternately, an alias can be made which contains the IP addresses of each remote site if they have static addresses.

Set the Destination to WAN Address

Set the Destination port to 1194 in this instance

Enter a Description, such as OpenVPN Multi-Site VPN

Click Save

Click Apply Changes

A rule must also be added to the OpenVPN interface to pass traffic over the VPN from the Client-side LAN to the Server-side LAN. An “Allow all” style rule may be used, or a set of stricter rules. In this example allowing all traffic is OK so the following rule is made:

Navigate to Firewall > Rules, OpenVPN tab

Click fa-level-up Add to create a new rule at the top of the list

Set Protocol to any

Enter a Description such as Allow all on OpenVPN

Click Save

Click Apply Changes

The last piece of the puzzle is to add Client Specific Overrides for each client site. These are needed to tie a client subnet to a particular certificate for a site so that it may be properly routed.

Navigate to VPN > OpenVPN, Client Specific Overrides tab

Click fa-plus to add a new override

Fill in the fields on this screen as follows:

Common Name
Enter the CN of the first client site. In this example, that is clientB.

IPv4 Remote Network
This field sets up the required iroute so enter the clientB LAN subnet, 10.5.0.0/24

Click Save

Add an override for the second site, adjusting the Common Name and IPv4 Remote Network as needed. In the example for site C, these values would be clientC and 10.7.0.0/24 respectively.

The next task is to export the certificates and keys needed for clients.

Navigate to System > Cert Manager

Click the links to export the following items:

CA Certificate

Client site certificate (.crt) for each client location.

Client site key (.key) for each client location.

Warning

Do not export the CA key, server certificate, or server key. They are not needed on the clients, and copying them unnecessarily significantly weakens the security of the VPN.

That completes the server setup, next, now move on to configure the clients.

Configuring SSL/TLS Client Side
On the client, import the CA certificate along with the client certificate and key for that site. This is the same CA and client certificate made on the server and exported from there. This can be done under System > Cert Manager. For specifics on importing the CA and certificates, see Certificate Management.

After importing the certificates, create the OpenVPN client:

Navigate to VPN > OpenVPN, Client tab

Click fa-plus Add to create a new client

Fill in the fields as follows, with everything else left at defaults

Server Mode
Select Peer to Peer (SSL/TLS)

Protocol
Select UDP

Device Mode
Select tun

Interface
Select WAN

Server host or address
Enter the public IP address or hostname of the OpenVPN server here (e.g. 198.51.100.3)

Server Port
Enter 1194 or whichever port was configured on the server

Description
Enter text here to describe the connection

TLS Authentication
Check Enable authentication of TLS packets, Uncheck Automatically generate a shared TLS authentication key, then paste in the TLS key for the connection here using the key copied from the server instance created previously

Peer Certificate Authority
Select the CA imported at the beginning of this process

Client Certificate
Select the client certificate imported at the beginning of this process

Click Save

A rule must also be added to the OpenVPN interface to pass traffic over the VPN from the Client-side LAN to the Server-side LAN. An “Allow all” style rule may be used, or a set of stricter rules. In this example allowing all traffic is OK so the following rule is made:

Navigate to Firewall > Rules, OpenVPN tab

Click fa-level-up Add to create a new rule at the top of the list

Set Protocol to any

Enter a Description such as Allow all on OpenVPN

Click Save

Click Apply Changes

The configuration of the client is complete. No firewall rules are required on the client WAN because the client only initiates outbound connections.

Note

With remote access PKI configurations, routes and other configuration options are not usually defined in the client configuration but rather they are pushed from the server to the client. If there are more networks to reach on the server side, configure them on the server to be pushed.

Testing the connection
The configuration is now complete and the connection will immediately be active upon saving on the client side. Try to ping across to the remote end to verify connectivity. If problems arise, refer to Troubleshooting OpenVPN.