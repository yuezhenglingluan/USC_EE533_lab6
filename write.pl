#!/usr/bin/perl
use strict;
use warnings;
use Time::HiRes qw(usleep);

my $CMD_REG   = "0x200020c";  # PIPLINE_CMD_REG_REG
my $POLL_DELAY = 100;         

sub regwrite {
    my ($addr, $value) = @_;
    my $cmd = sprintf("regwrite %s 0x%08x", $addr, $value);
    my $result = `$cmd`;
}

sub regread {
    my ($addr) = @_;
    my $cmd = sprintf("regread %s", $addr);
    my @out = `$cmd`;
    return "0x00000000" unless @out; 
    
    my $result = $out[0];
    if ($result =~ m/Reg (0x[0-9a-f]+) \((\d+)\):\s+(0x[0-9a-f]+) \((\d+)\)/) {
        return $3; 
    }
    return "0x00000000"; 
}

die "Usage: $0 <instruction_file>\n" unless @ARGV;
my $filename = $ARGV[0];

open(my $fh, '<', $filename) or die "Can't open $filename: $!";

my $count = 0;
while (my $line = <$fh>) {
    chomp $line;
    next if $line =~ /^\s*(#|$)/;  
    
    my $instruction = $line;
    $instruction = "0x$instruction" unless $line =~ /^0x/i;
    $instruction = hex($instruction);
    
    regwrite($CMD_REG, $instruction);
    
    while (1) {
        my $cmd_status = hex(regread($CMD_REG));
        last unless ($cmd_status & 0x1); 
        usleep($POLL_DELAY);
    }
    $count++;
}

close($fh);
print "Executed $count instructions\n";