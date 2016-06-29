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
	my $handle = shift;
	Thread->self->detach;
	print "Accepted a connection\n";
	print $handle "Hello\n";
}
