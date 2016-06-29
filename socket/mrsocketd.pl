#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: mrsocketd.pl
#
#        USAGE: ./mrsocketd.pl  
#
#  DESCRIPTION: A supersimple socket server.
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Tor Stefan Lura (), torstefan@gmail.com
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 29/06/16 17:30:39
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use IO::Socket;
use Thread;

use constant PORT => 1234;

my $listen_socket = IO::Socket::INET->new(	LocalPort => PORT,
											Listen => 20,
											Proto => 'tcp',
											Reuse => 1

);

die $@ unless $listen_socket;

warn "Listing for connections...\n";


while ( my $connection = $listen_socket->accept ) {
	Thread->new(\&interact, $connection);
}

sub interact{
	my $session = shift;
	Thread->self->detach;
	my $peer = gethostbyaddr($session->peeraddr,AF_INET) || $session->peerhost;
	my $port = $session->peerport;
	warn "Connection from [$peer,$port]\n";

	print $session "> ";

	while ( <$session> ) {
		chomp;
		if (m/PASSWD/xm){
			print $session get_passwd();
		}
		print $session "\n> ";
	}

	warn "Connection from [$peer,$port] finished \n";
	close $session;
}

sub get_passwd { 
	return `cat /etc/passwd`;
}


